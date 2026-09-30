import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/chat_provider.dart';
import 'providers/locale_provider.dart';
import 'services/chat_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = ChatStorage();
  final localeProvider = LocaleProvider(storage);
  await localeProvider.load();

  final chatProvider = ChatProvider(localeProvider: localeProvider);
  await chatProvider.loadHistory();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localeProvider),
        ChangeNotifierProvider.value(value: chatProvider),
      ],
      child: const AseanWeatherApp(),
    ),
  );
}
