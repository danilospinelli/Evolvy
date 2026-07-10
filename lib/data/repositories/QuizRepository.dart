import 'package:flutter_application_1/data/services/QuizService.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';

class QuizRepository {
  late final QuizService quizService;

  QuizRepository(){
    this.quizService=QuizService();
  }

  //metodi che la repository espone al di fuori,
  Future<QuizModelList> getQuiz(int id_utente) async {
    final QuizJson = await quizService.getQuizService(id_utente: id_utente);
    return QuizModelList.fromJson(QuizJson);
  }

  Future<void> checkQuiz(int id_quiz, int id_utente, int exp_guadagnata) async {
    await quizService.checkQuizService(id_quiz: id_quiz, id_utente: id_utente, exp_guadagnata: exp_guadagnata);
  }
}