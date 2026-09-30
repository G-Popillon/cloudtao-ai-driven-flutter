import 'app_localizations.dart';

class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh() : super('zh');

  @override
  String get appTitle => '东盟气象智能助手';
  @override
  String get welcomeTitle => '欢迎使用';
  @override
  String get welcomeMessage => '可询问东盟各国天气、预报与气候问题，支持文字与语音交互。';
  @override
  String get inputHint => '输入气象相关问题...';
  @override
  String get send => '发送';
  @override
  String get recordStart => '点击录音';
  @override
  String get recordStop => '点击结束';
  @override
  String get recording => '录音中...';
  @override
  String get sourcePanelTitle => '引用气象数据源';
  @override
  String get sourceEmpty => '暂无引用来源';
  @override
  String get loading => '正在思考...';
  @override
  String get errorNetwork => '网络异常，请确认后端服务已启动。';
  @override
  String get errorGeneric => '请求失败，请重试。';
  @override
  String get errorPermissionMic => '需要麦克风权限才能使用语音输入。';
  @override
  String get errorSttEmpty => '未能识别语音，请重试。';
  @override
  String get language => '语言';
  @override
  String get clearHistory => '清空历史';
  @override
  String get clearHistoryConfirm => '确定清空全部对话历史？';
  @override
  String get cancel => '取消';
  @override
  String get confirm => '确定';
  @override
  String get playingAudio => '正在播报回答...';
}
