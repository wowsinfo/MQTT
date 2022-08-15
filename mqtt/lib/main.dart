import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:mqtt/localisation/localisation.dart';
import 'package:mqtt/model/storage_provider.dart';
import 'package:mqtt/repository/app_repository.dart';
import 'package:mqtt/repository/game_repository.dart';
import 'package:mqtt/ui/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode) {
      final message = '${record.loggerName}: ${record.message}';
      print('${record.level.name}|$message');
    }
  });

  final pref = PreferenceProvider();
  await pref.initialise();
  AppRepository.instance.inject(pref);
  await GameRepository.instance.initialise();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MQTT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      localizationsDelegates: Localisation.localizationsDelegates,
      supportedLocales: Localisation.supportedLocales,
      locale: Localisation.defaultLocale(),
      home: const HomePage(),
    );
  }
}
