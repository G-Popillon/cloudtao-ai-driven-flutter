/// API 配置：后端地址与路径集中管理，改一处即可。
class ApiConfig {
  ApiConfig._();

  /// 可通过 `--dart-define=API_BASE_URL=http://x.x.x.x:8000` 覆盖。
  /// Android 模拟器访问本机请用 `http://10.0.2.2:8000`。
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );

  static const String chatPath = '/api/chat';
  static const String sttPath = '/api/stt';
  static const String ttsPath = '/api/tts';
  static const String langsPath = '/api/i18n/langs';

  /// STT multipart 文件字段名；若后端不同，只改这里。
  static const String sttFileField = 'file';

  static const Duration timeout = Duration(seconds: 60);

  static String get chatUrl => '$baseUrl$chatPath';
  static String get sttUrl => '$baseUrl$sttPath';
  static String get ttsUrl => '$baseUrl$ttsPath';
  static String get langsUrl => '$baseUrl$langsPath';
}
