import 'package:asean_weather_ai/app.dart';
import 'package:asean_weather_ai/providers/chat_provider.dart';
import 'package:asean_weather_ai/providers/locale_provider.dart';
import 'package:asean_weather_ai/services/chat_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Chat screen shows localized title', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = ChatStorage();
    final localeProvider = LocaleProvider(storage);
    final chatProvider = ChatProvider(localeProvider: localeProvider);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: localeProvider),
          ChangeNotifierProvider.value(value: chatProvider),
        ],
        child: const AseanWeatherApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('东盟气象智能助手'), findsOneWidget);
  });
}
