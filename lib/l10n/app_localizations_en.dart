import 'app_localizations.dart';

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appTitle => 'ASEAN Weather AI Assistant';
  @override
  String get welcomeTitle => 'Welcome';
  @override
  String get welcomeMessage =>
      'Ask about ASEAN weather, forecasts, and climate. Voice and text are both supported.';
  @override
  String get inputHint => 'Ask a weather question...';
  @override
  String get send => 'Send';
  @override
  String get recordStart => 'Tap to record';
  @override
  String get recordStop => 'Tap to stop';
  @override
  String get recording => 'Recording...';
  @override
  String get sourcePanelTitle => 'Weather data sources';
  @override
  String get sourceEmpty => 'No sources';
  @override
  String get loading => 'Thinking...';
  @override
  String get errorNetwork => 'Network error. Please check the backend service.';
  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
  @override
  String get errorPermissionMic =>
      'Microphone permission is required for voice input.';
  @override
  String get errorSttEmpty => 'Could not recognize speech. Please try again.';
  @override
  String get language => 'Language';
  @override
  String get clearHistory => 'Clear history';
  @override
  String get clearHistoryConfirm => 'Clear all chat history?';
  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';
  @override
  String get playingAudio => 'Playing answer...';
}
