import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'screens/chat_screen.dart';
import 'theme/app_theme.dart';

/// 根 MaterialApp：绑定多语言与主题。
class AseanWeatherApp extends StatelessWidget {
  const AseanWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      title: 'ASEAN Weather AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const ChatScreen(),
    );
  }
}
