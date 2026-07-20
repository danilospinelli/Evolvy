import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import '../mock_repository/Mock_UserRepository.dart';
import '../mock_repository/Mock_LogMealRepository.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import '../mock_repository/Mock_AvatarRepository.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import '../mock_repository/Mock_QuizRepository.dart';

// File di metodi helper per la istanziazione ed inizializzazione dei ViewModel utilizzati nei file di test.
// Ciascuno prende come parametro la repository di cui ha bisogno il ViewModel, lo crea e chiama .initialize().

Future<QuizPage_ViewModel> buildQuizViewModel(Mock_QuizRepository repo) async {
  final vm = QuizPage_ViewModel(repo);
  await vm.initialize();
  return vm;
}

Future<Homepage_ViewModel> buildHomepageViewModel(Mock_LogMealRepository repoLogMeal, Mock_UserRepository repoUser) async {
  final vm = Homepage_ViewModel(repoLogMeal, repoUser);
  await vm.initialize();
  return vm;
}

Future<Avatar_ViewModel> buildAvatarViewModel(Mock_AvatarRepository repo) async {
  final vm = Avatar_ViewModel(repo);
  await vm.initialize();
  return vm;
}