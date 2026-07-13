import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {
  
  late final SupabaseClient _client;

  AvatarService() {
    this._client = Supabase.instance.client;
  }


  //restituisce tutte le informazione per la pagina avatar
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

  //aggiorna i dati dell'avatar e restituisce le informazioni aggiornate
  Future<void> updateAvatarInfoService({required int idUtente, required String nomeAvatar, required int coloreAvatar}) async {
    try {
      await _client.rpc(
        'update_dati_avatar',
        params: {'p_utente_id': idUtente, 'p_nome_avatar': nomeAvatar, 'p_colore_avatar': coloreAvatar},
      );
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

  //aggiorna lo stato dell obbiettivo giornaliero e restituisce le informazioni 
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
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

  //funzione per aggiornare i dati dell'avatar (livello, exp, monete)
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
      throw Exception('Errore durante il recupero dell\'avatar: $e');
    }
  }

}