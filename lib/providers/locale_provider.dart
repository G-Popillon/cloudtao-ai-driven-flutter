import 'package:flutter/material.dart';

import '../services/chat_storage.dart';

/// 支持的东盟演示语言：zh / en / th / vi / id。
class AppLanguage {
  final String code;
  final String label;
  final Locale locale;

  const AppLanguage({
    required this.code,
    required this.label,
    required this.locale,
  });
}

const List<AppLanguage> supportedLanguages = [
  AppLanguage(code: 'zh', label: '中文', locale: Locale('zh')),
  AppLanguage(code: 'en', label: 'English', locale: Locale('en')),
  AppLanguage(code: 'th', label: 'ไทย', locale: Locale('th')),
  AppLanguage(code: 'vi', label: 'Tiếng Việt', locale: Locale('vi')),
  AppLanguage(code: 'id', label: 'Bahasa Indonesia', locale: Locale('id')),
];

/// 全局语言状态：切换后即时刷新 UI，并持久化。
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._storage);

  final ChatStorage _storage;

  AppLanguage _language = supportedLanguages.first;

  AppLanguage get language => _language;
  String get langCode => _language.code;
  Locale get locale => _language.locale;

  Future<void> load() async {
    final saved = await _storage.loadLocaleCode();
    if (saved == null) return;
    final matched = supportedLanguages.where((l) => l.code == saved);
    if (matched.isNotEmpty) {
      _language = matched.first;
      notifyListeners();
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    if (_language.code == language.code) return;
    _language = language;
    await _storage.saveLocaleCode(language.code);
    notifyListeners();
  }

  Future<void> setByCode(String code) async {
    final matched = supportedLanguages.where((l) => l.code == code);
    if (matched.isEmpty) return;
    await setLanguage(matched.first);
  }
}
