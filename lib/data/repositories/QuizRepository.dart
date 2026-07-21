import 'package:flutter_application_1/data/services/QuizService.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';


//Dichiarato final perche non vogliamo in nessun modo che l'ogetto che comunica con internet possa essere modificato
//durante le operazioni o le query.

class QuizRepository {
  final QuizService _quizService=QuizService();


//Metodo perfettamente speculare a quello del FoodRepository, da un id Utente prende la sua lista 
//di quiz e tramite Map e toList allla fine restituisce una lista compatta.

  Future<List<QuizModel>> getQuiz(int idUtente) async {
    final quizJson = await _quizService.getQuizService(idUtente: idUtente) as List;
    List<QuizModel> quizzes = quizJson.map((json) => QuizModel.fromJson(json as Map<String, dynamic>)).toList();
    return quizzes;
  }
  
//Metodo per la verifica di completamento di un quiz tramite l'id del quiz e dell'utente.

  Future<void> checkQuiz(int idQuiz, int idUtente) async {
    await _quizService.checkQuizService(idQuiz: idQuiz, idUtente: idUtente);
  }


}