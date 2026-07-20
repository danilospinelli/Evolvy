import 'package:supabase_flutter/supabase_flutter.dart';

class QuizService {

  //inizializzazione del client di Supabase. Final per i motivi analoghi descritti prima,
  //non vogliamo sia un oggetto modificabile durante l'esecuzione.

  late final SupabaseClient _client;

  QuizService(){
    this._client = Supabase.instance.client;
  }

    //Recupera i quiz per un utente specifico "idUtente" dal DB tramite una chiamata asincrona e una funzione rpc in Supabase

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

    //Metodo che controlla lo stato di completamento di un quiz "idQuiz" dell'utente "idUtente" tramite una chiamata asincrona al DB
    //e una funzione rpc in Supabse. Se necessario cambia il flag da "non completato" a "completato" nel DB.
    
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
