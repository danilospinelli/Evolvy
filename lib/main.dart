import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/ui/core/MainScreen/View/MainScreen_View.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/core/MainScreen/ViewModel/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';

Future<void> main() async {
  //Link di collegamento a Supabase.
  await Supabase.initialize(
    url: 'https://ggadagheuyryxssoacpe.supabase.co',
    anonKey: 'sb_publishable_rAfErRtksjBHZMX9k70B4w_RGLa7vs7',
  );

  //Abbiamo gestito l'avvio dell App tramite un MultiProvider per le pagine della navigationBar
  //Mentre altre pagine hanno provider singoli.
  //TODO: una best practice sarebbe quella di fare il 2o metodo per tutti!
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MainScreen_ViewModel>(
          create: (_) => MainScreen_ViewModel(),
        ),
        ChangeNotifierProvider<Homepage_ViewModel>(
          create: (_) {
            final viewModel = Homepage_ViewModel();
            viewModel.initialize();
            return viewModel;
          },
        ),
        ChangeNotifierProvider<Avatar_ViewModel>(
          create: (_) {
            final viewModel = Avatar_ViewModel();
            viewModel.initialize();
            return viewModel;
          },
        ),
        ChangeNotifierProvider<QuizPage_ViewModel>(
          create: (_) {
            final viewModel = QuizPage_ViewModel();
            viewModel.initialize();
            return viewModel;
          },
        ),
      ],

      //Parte l'app.
      child: const MyApp(),
    ),
  ); 
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
      //La schermata di Avvio è la MainScreen. Per come l'abbiamo definita nel core mostra le pagine in base a degli indici
      //Parte quindi dalla homepage dato che è indicizzata con 0.
      home: const MainScreen_View(),
    );
  }
}
