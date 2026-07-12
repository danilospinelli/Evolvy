import 'package:flutter_application_1/data/services/QuizService.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';

class QuizRepository {
  late final QuizService _quizService;

  QuizRepository(){
    this._quizService=QuizService();
  }

  //metodi che la repository espone al di fuori,
  Future<List<QuizModel>> getQuiz(int idUtente) async {
    final quizJson = await _quizService.getQuizService(idUtente: idUtente);
    List<QuizModel> quizzes=quizJson.map((json) => QuizModel.fromJson(json)).toList();
    return quizzes;
  }
  

  Future<void> checkQuiz(int idQuiz, int idUtente, int expGuadagnata) async {
    await _quizService.checkQuizService(idQuiz: idQuiz, idUtente: idUtente, exp_guadagnata: expGuadagnata);
  }
}