import 'package:supabase_flutter/supabase_flutter.dart';

class QuizService {
  late final SupabaseClient _client;

  QuizService(){
    this._client = Supabase.instance.client;
  }

    //Recupera i quiz per un utente specifico
    Future<dynamic> getQuizService({required int idUtente}) async {
        try {
        final response = await _client.rpc(
            'get_quiz_utente',
            params: {'p_utente_id': idUtente},
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante il recupero del quiz: $e');
        }
    }

    //cambia la flag del quiz da non completato a completato
    Future<void> checkQuizService({required int idQuiz, required int idUtente}) async {
        try {
        await _client.rpc(
            'completa_quiz_giornaliero',
            params: {
              'p_utente_id': idUtente,
              'p_id_quiz': idQuiz,
            },
        );
        } catch (e) {
        throw Exception('Errore durante l\'invio della risposta al quiz: $e');
        }
    }

}
