import 'package:supabase_flutter/supabase_flutter.dart';

class QuizService {
  late final SupabaseClient client;

  QuizService(){
    this.client = Supabase.instance.client;
  }

    Future<dynamic> getQuizService({required int id_utente}) async {
        try {
        final response = await client.rpc(
            'get_quiz_utente',
            params: {'p_utente_id': id_utente},
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante il recupero del quiz: $e');
        }
    }

    Future<dynamic> checkQuizService({required int id_quiz, required int id_utente, required int exp_guadagnata}) async {
        try {
        final response = await client.rpc(
            'rispondi_quiz',
            params: {'p_utente_id': id_utente, 'p_id_quiz': id_quiz, 'p_exp_guadagnata': exp_guadagnata}
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante l\'invio della risposta al quiz: $e');
        }
    }

}
