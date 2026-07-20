import 'package:supabase_flutter/supabase_flutter.dart';

class FoodService {

  //inizializzazione del client di Supabase. Final per i motivi analoghi descritti prima,
  //non vogliamo sia un oggetto modificabile durante l'esecuzione.

  late final SupabaseClient _client;

  FoodService() {
    this._client = Supabase.instance.client;
  }

  //Recupera i cibi dal database in base al nome del cibo fornito come parametro dall'utente. Gestito tramite
  //chiamata asincrona al DB e tramite funzione rcp.
  //Se la ricerca è "p"(nomeCibo) verranno restituiti TUTTI i cibi con all'interno una p.

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
