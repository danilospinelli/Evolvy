import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'ui/core/MainScreen/MainScreen_View.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ggadagheuyryxssoacpe.supabase.co',
    anonKey: 'sb_publishable_rAfErRtksjBHZMX9k70B4w_RGLa7vs7',
  );

  OpenFoodAPIConfiguration.userAgent = UserAgent(
    name: 'Evolvy',
    version: '1.0.0',
    system: 'Flutter',
    url: 'mail',
    comment: 'App per tracciare cibi e calorie',
  );

  OpenFoodAPIConfiguration.globalLanguages = [OpenFoodFactsLanguage.ITALIAN];
  OpenFoodAPIConfiguration.globalCountry = OpenFoodFactsCountry.ITALY;

  runApp(
    const MyApp(),
  ); // Aggiunto 'const' se MyApp lo supporta (ottimizzazione Flutter)
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Evolvy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen_View(),
    );
  }
}
