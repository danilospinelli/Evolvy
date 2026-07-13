import 'package:flutter_application_1/data/services/QuizService.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';

class QuizRepository {
  late final QuizService _quizService;

  QuizRepository(){
    this._quizService=QuizService();
  }

  //metodi che la repository espone al di fuori,
  Future<List<QuizModel>> getQuiz(int idUtente) async {
    final quizJson = await _quizService.getQuizService(idUtente: idUtente) as List;
    List<QuizModel> quizzes = quizJson.map((json) => QuizModel.fromJson(json as Map<String, dynamic>)).toList();
    return quizzes;
  }
  

  //livello, exp e monete sono totali assoluti, non incrementi
  Future<void> checkQuiz(int idQuiz, int idUtente) async {
    await _quizService.checkQuizService(idQuiz: idQuiz, idUtente: idUtente);
  }
}