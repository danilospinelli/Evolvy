import 'package:flutter_application_1/data/services/QuizService.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';

class QuizRepository {
  late final QuizService quizService;

  QuizRepository(){
    this.quizService=QuizService();
  }

  //metodi che la repository espone al di fuori,
  Future<QuizModel> getQuiz(int id_quiz) async {
    final QuizJson = await quizService.getQuizService(id_quiz: id_quiz);
    return QuizModel.fromJson(QuizJson);
  }
}