import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  late final SupabaseClient client;

  FoodService() {
    this.client = Supabase.instance.client;
  }
  // Recupera i pasti giornalieri per un utente e una data specifica
  Future<dynamic> getCiboService({required String nome_cibo}) async {
    try {
      final response = await client.rpc(
        'cerca_alimenti_json',
        params: {'search_term': nome_cibo},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero del cibo: $e');
    }
  }
}
