import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/ui/core/MainScreen/View/MainScreen_View.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/core/MainScreen/ViewModel/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import 'package:flutter_application_1/data/repositories/UserRepository.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://ggadagheuyryxssoacpe.supabase.co',
    anonKey: 'sb_publishable_rAfErRtksjBHZMX9k70B4w_RGLa7vs7',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MainScreen_ViewModel>(
          create: (_) => MainScreen_ViewModel(),
        ),
        ChangeNotifierProvider<Homepage_ViewModel>(
          create: (_) {
            final viewModel = Homepage_ViewModel(
              LogMealRepository(),
              UserRepository(),
            );
            viewModel.initialize();
            return viewModel;
          },
        ),
        ChangeNotifierProvider<Avatar_ViewModel>(
          create: (_) {
            final viewModel = Avatar_ViewModel(AvatarRepository());
            viewModel.initialize();
            return viewModel;
          },
        ),
        ChangeNotifierProvider<QuizPage_ViewModel>(
          create: (_) {
            final viewModel = QuizPage_ViewModel(QuizRepository());
            viewModel.initialize();
            return viewModel;
          },
        ),
      ],

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
      home: const MainScreen_View(),
    );
  }
}
