import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

/// 使用 record 插件采集音频，上传给云端 STT。不使用系统本地语音识别。
class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _currentPath;

  bool get isRecording => _isRecording;

  /// 申请麦克风权限。
  Future<bool> ensurePermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) return true;
    // Windows / 桌面端可能走 record 自身权限检查
    return _recorder.hasPermission();
  }

  /// 开始录音，返回待写入文件路径。
  Future<String> start() async {
    if (_isRecording) {
      throw StateError('Already recording');
    }
    final ok = await ensurePermission();
    if (!ok) {
      throw StateError('Microphone permission denied');
    }

    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      'asean_stt_${DateTime.now().millisecondsSinceEpoch}.wav',
    );

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    _isRecording = true;
    _currentPath = path;
    return path;
  }

  /// 结束录音，返回音频文件；失败返回 null。
  Future<File?> stop() async {
    if (!_isRecording) return null;
    final path = await _recorder.stop();
    _isRecording = false;
    final filePath = path ?? _currentPath;
    _currentPath = null;
    if (filePath == null) return null;
    final file = File(filePath);
    if (!await file.exists()) return null;
    return file;
  }

  Future<void> cancel() async {
    if (!_isRecording) return;
    await _recorder.cancel();
    _isRecording = false;
    _currentPath = null;
  }

  Future<void> dispose() async {
    await cancel();
    await _recorder.dispose();
  }
}
