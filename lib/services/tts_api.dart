import '../config/api_config.dart';
import 'api_client.dart';

/// 云端语音合成（TTS）：返回二进制音频字节。
class TtsApi {
  TtsApi(this._client);

  final ApiClient _client;

  Future<List<int>> synthesize({
    required String text,
    required String lang,
  }) {
    return _client.postJsonBytes(ApiConfig.ttsUrl, {
      'text': text,
      'lang': lang,
    });
  }
}
