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

    //Invia la risposta al quiz e aggiorna l'esperienza dell'utente
    Future<dynamic> checkQuizService({required int idQuiz, required int idUtente, required int exp_guadagnata}) async {
        try {
        final response = await _client.rpc(
            'rispondi_quiz',
            params: {'p_utente_id': idUtente, 'p_id_quiz': idQuiz, 'p_exp_guadagnata': exp_guadagnata}
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante l\'invio della risposta al quiz: $e');
        }
    }

}
