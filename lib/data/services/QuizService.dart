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

    //Invia la risposta al quiz e aggiorna l'esperienza dell'utente.
    //livello, exp e monete sono TOTALI assoluti gia' calcolati dal viewmodel, non incrementi
    Future<dynamic> checkQuizService({required int idQuiz, required int idUtente, required int exp, required int livello, required int monete}) async {
        try {
        final response = await _client.rpc(
            'completa_quiz_giornaliero',
            params: {
              'p_utente_id': idUtente,
              'p_id_quiz': idQuiz,
              'p_nuovo_livello': livello,
              'p_nuovo_exp': exp,
              'p_monete_totali': monete}
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante l\'invio della risposta al quiz: $e');
        }
    }

}
