import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  
  //inizializzazione del client di Supabase. Final per i motivi analoghi descritti prima,
  //non vogliamo sia un oggetto modificabile durante l'esecuzione.

  final SupabaseClient _client= Supabase.instance.client;


//Metodo che recupera le informazioni sui macro nutrienti di un utente "idUtente" con una chiamata asincrona al DB
//e tramite una funzione rpc in Supabase.

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