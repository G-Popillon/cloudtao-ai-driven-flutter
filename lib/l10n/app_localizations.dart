import 'package:flutter/material.dart';

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

/// 应用多语言文案（与 ARB 键保持一致；也可由 flutter gen-l10n 覆盖生成）。
abstract class AppLocalizations {
  AppLocalizations(this.localeName);

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('zh'),
    Locale('en'),
    Locale('th'),
    Locale('vi'),
    Locale('id'),
  ];

  String get appTitle;
  String get welcomeTitle;
  String get welcomeMessage;
  String get inputHint;
  String get send;
  String get recordStart;
  String get recordStop;
  String get recording;
  String get sourcePanelTitle;
  String get sourceEmpty;
  String get loading;
  String get errorNetwork;
  String get errorGeneric;
  String get errorPermissionMic;
  String get errorSttEmpty;
  String get language;
  String get clearHistory;
  String get clearHistoryConfirm;
  String get cancel;
  String get confirm;
  String get playingAudio;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['zh', 'en', 'th', 'vi', 'id'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'zh':
        return AppLocalizationsZh();
      case 'th':
        return AppLocalizationsTh();
      case 'vi':
        return AppLocalizationsVi();
      case 'id':
        return AppLocalizationsId();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
