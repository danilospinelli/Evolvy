import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {
  late final SupabaseClient _client;

  FoodService() {
    this._client = Supabase.instance.client;
  }
  //Recupera i cibi dal database in base al nome del cibo fornito come parametro
  Future<dynamic> getCiboService({required String nomeCibo}) async {
    try {
      final response = await _client.rpc(
        'cerca_alimenti_json',
        params: {'search_term': nomeCibo},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero del cibo: $e');
    }
  }
}
