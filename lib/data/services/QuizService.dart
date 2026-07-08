import 'package:supabase_flutter/supabase_flutter.dart';

class QuizService {
  late final SupabaseClient client;

  QuizService(){
    this.client = Supabase.instance.client;
  }

    Future<dynamic> getQuizService({required int id_quiz}) async {
        try {
        final response = await client.rpc(
            'getquiz',
            params: {'p_id': id_quiz},
        );
        return response;
        } catch (e) {
        throw Exception('Errore durante il recupero del quiz: $e');
        }
    }
  
}
