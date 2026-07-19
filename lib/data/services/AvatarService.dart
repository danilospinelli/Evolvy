import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {

  //inizializzazione del client di Supabase. Final per i motivi analoghi descritti prima,
  //non vogliamo sia un oggetto modificabile durante l'esecuzione.
  
  late final SupabaseClient _client;

  AvatarService() {
    this._client = Supabase.instance.client;
  }

  //Restituisce tutte le informazione per la pagina dell'avatar tramite una chiamata asincrona al DB.
  //utilizza una funzione rpc che abbianmo definito all'interno di Supabase.

  Future<dynamic> getAvatarInfoService({required int idUtente}) async {
    try {
      final response = await _client.rpc(
        'get_dati_avatar',
        params: {'p_utente_id': idUtente},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero dell\'avatar: $e');
    }
  }

  //Aggiorna il nome dell'avatar dell'utente "idUetnte" con la stringa "nomeAvatar" tramite chiamata asincrona al DB.
  //Anch'esso è gestito tramite una rpc definita in Supabase.

  Future<void> updateNomeAvatarService({required int idUtente, required String nomeAvatar}) async {
    try {
      await _client.rpc(
        'update_utente_nome',
        params: {'p_utente_id': idUtente, 'p_nome': nomeAvatar},
      );
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

  //Aggiorna il colore dell'avatar dell'utente "idUtente" con il colore "coloreAvatar" tramite chiamata asincrona al DB.
  //Gestito tramite una funzione rpc definita in Supabase.

  Future<void> updateColoreAvatarService({required int idUtente,required int coloreAvatar}) async {
    try {
      await _client.rpc(
        'update_utente_colore',
        params: {'p_utente_id': idUtente, 'p_colore': coloreAvatar},
      );
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\' colore: $e');
    }
  }
  
  //Aggiorna lo stato dell obbiettivo giornaliero dell'utente "idUtente" dell'obiettivo "idObiettivo" tramite chiamata asincrona al DB.
  //Gestito tramite una funzione rpc definita in Supabase.

  Future<void> completaObbietivoAvatarService({required int idUtente,required int idObiettivo,}) async {
    try {
      await _client.rpc(
        'completa_obiettivo_giornaliero',
        params: {
          'p_utente_id': idUtente,
          'p_id_obiettivo': idObiettivo,
        },
      );
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'obbietivo: $e');
    }
  }

  //Funzione per aggiornare i dati dell'avatar: livello, exp, monete dell'utente "idUtente". Chiamata asincrona al DB
  //gestita tramite una funzione rpc definita in Supabase.
  
  Future<void> aggiornaDatiAvatarService({required int idUtente, required int livello, required int exp, required int monete}) async {
    try {
      await _client.rpc(
        'aggiorna_dati_avatar',
        params: {
          'p_utente_id': idUtente,
          'p_livello': livello,
          'p_exp': exp,
          'p_monete': monete
        },
      );
    } catch (e) {
      throw Exception('Errore durante il cambiamento dei dati: $e');
    }
  }

}