import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  
  late final SupabaseClient _client;

  UserService() {
    this._client = Supabase.instance.client;
  }


  Future<dynamic> getUserMacroService({required int idUtente}) async {
    try {
      final response = await _client.rpc(
        'get_macro_utente',
        params: {'p_utente_id': idUtente},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero dei dati utente: $e');
    }
  }
}