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
  Future<dynamic> updateAvatarInfoService({required int idUtente, required String nomeAvatar, required int coloreAvatar}) async {
    try {
      final response = await _client.rpc(
        'update_dati_avatar',
        params: {'p_utente_id': idUtente, 'p_nome_avatar': nomeAvatar, 'p_colore_avatar': coloreAvatar},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }


  //aggiorna i dati dell'avatar relati agli obiettivi e restituisce le informazioni aggiornate
  //livello, exp e monete sono tutti totali assoluti gia' calcolati dal viewmodel
  Future<dynamic> updateAvatarObbietivoService({required int idUtente,required int idObiettivo,required int livello,required int exp,required int monete}) async {
    try {
      final response = await _client.rpc(
        'completa_obiettivo_giornaliero',
        params: {
          'p_utente_id': idUtente,
          'p_id_obiettivo': idObiettivo,
          'p_nuovo_livello': livello,
          'p_nuovo_exp': exp,
          'p_monete_totali': monete,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

}