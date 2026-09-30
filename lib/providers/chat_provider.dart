import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../services/api_client.dart';
import '../services/audio_player_service.dart';
import '../services/audio_recorder_service.dart';
import '../services/chat_api.dart';
import '../services/chat_storage.dart';
import '../services/stt_api.dart';
import '../services/tts_api.dart';
import 'locale_provider.dart';

/// 聊天会话状态：文字问答、录音 STT、TTS 播报、本地历史。
class ChatProvider extends ChangeNotifier {
  ChatProvider({
    required LocaleProvider localeProvider,
    ChatStorage? storage,
    ApiClient? apiClient,
    AudioRecorderService? recorder,
    AudioPlayerService? player,
  })  : _localeProvider = localeProvider,
        _storage = storage ?? ChatStorage(),
        _apiClient = apiClient ?? ApiClient(),
        _recorder = recorder ?? AudioRecorderService(),
        _player = player ?? AudioPlayerService() {
    _chatApi = ChatApi(_apiClient);
    _sttApi = SttApi(_apiClient);
    _ttsApi = TtsApi(_apiClient);
  }

  final LocaleProvider _localeProvider;
  final ChatStorage _storage;
  final ApiClient _apiClient;
  final AudioRecorderService _recorder;
  final AudioPlayerService _player;

  late final ChatApi _chatApi;
  late final SttApi _sttApi;
  late final TtsApi _ttsApi;

  final List<ChatMessage> _messages = [];
  bool _loading = false;
  bool _recording = false;
  bool _transcribing = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _loading;
  bool get isRecording => _recording;
  bool get isTranscribing => _transcribing;
  bool get isBusy => _loading || _transcribing;
  String? get error => _error;

  Future<void> loadHistory() async {
    final saved = await _storage.loadMessages();
    _messages
      ..clear()
      ..addAll(saved);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _messages.clear();
    await _storage.clearMessages();
    notifyListeners();
  }

  /// 文字发送：追加用户消息 → 调 chat → 追加 AI 消息 → 自动 TTS。
  Future<void> sendText(String raw) async {
    final query = raw.trim();
    if (query.isEmpty || isBusy) return;

    _error = null;
    final userMsg = ChatMessage(
      id: 'u_${DateTime.now().microsecondsSinceEpoch}',
      role: MessageRole.user,
      content: query,
      createdAt: DateTime.now(),
    );
    _messages.add(userMsg);
    _loading = true;
    notifyListeners();
    await _persist();

    try {
      final response = await _chatApi.ask(
        query: query,
        lang: _localeProvider.langCode,
      );
      final aiMsg = ChatMessage(
        id: 'a_${DateTime.now().microsecondsSinceEpoch}',
        role: MessageRole.assistant,
        content: response.answer,
        sources: response.sources,
        createdAt: DateTime.now(),
      );
      _messages.add(aiMsg);
      await _persist();
      notifyListeners();

      // AI 回答返回后自动调用云端 TTS 播报
      await _speak(response.answer);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// 点击录音按钮：开始 / 结束。结束后上传 STT 并自动发送。
  Future<void> toggleRecording() async {
    if (_recording) {
      await _stopAndTranscribe();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    if (isBusy) return;
    _error = null;
    try {
      await _recorder.start();
      _recording = true;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _recording = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> _stopAndTranscribe() async {
    _recording = false;
    _transcribing = true;
    notifyListeners();
    File? file;
    try {
      file = await _recorder.stop();
      if (file == null) {
        throw StateError('Empty recording');
      }
      final text = await _sttApi.transcribe(
        audioFile: file,
        lang: _localeProvider.langCode,
      );
      if (text.isEmpty) {
        throw StateError('STT empty');
      }
      _transcribing = false;
      notifyListeners();
      await sendText(text);
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _transcribing = false;
      _recording = false;
      notifyListeners();
      if (file != null) {
        try {
          await file.delete();
        } catch (_) {}
      }
    }
  }

  Future<void> _speak(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    try {
      final bytes = await _ttsApi.synthesize(
        text: trimmed,
        lang: _localeProvider.langCode,
      );
      if (bytes.isEmpty) return;
      // 简单根据魔数判断扩展名；未知则默认 mp3
      final ext = _guessAudioExt(bytes);
      await _player.playBytes(bytes, extension: ext);
    } catch (e) {
      // TTS 失败不阻断对话展示，仅记录错误
      debugPrint('TTS failed: $e');
    }
  }

  String _guessAudioExt(List<int> bytes) {
    if (bytes.length >= 4) {
      // RIFF....WAVE
      if (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46) {
        return 'wav';
      }
      // ID3 or MPEG frame
      if (bytes[0] == 0x49 && bytes[1] == 0x44 && bytes[2] == 0x33) {
        return 'mp3';
      }
      if (bytes[0] == 0xFF && (bytes[1] & 0xE0) == 0xE0) {
        return 'mp3';
      }
    }
    return 'mp3';
  }

  Future<void> _persist() => _storage.saveMessages(_messages);

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    _apiClient.close();
    super.dispose();
  }
}
