import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarService {
  late final SupabaseClient client;

  AvatarService() {
    this.client = Supabase.instance.client;
  }


  //restituisce tutte le informazione per la pagina avatar
  Future<dynamic> getAvatarInfoService({required int id_utente}) async {
    try {
      final response = await client.rpc(
        'get_dati_avatar',
        params: {'p_utente_id': id_utente},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero dell\'avatar: $e');
    }
  }

  //restituisce tutte le informazione per la pagina avatar
  Future<dynamic> updateAvatarInfoService({required int id_utente, required String nome_avatar, required String colore_avatar}) async {
    try {
      final response = await client.rpc(
        'update_dati_avatar',
        params: {'p_utente_id': id_utente, 'p_nome_avatar': nome_avatar, 'p_colore_avatar': colore_avatar},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

  //aggiorna il database con l'obiettivo completato e restituisce la lista aggiornata degli obiettivi
  //e fa le varie operazioni che ne posono derivare
  Future<dynamic> updateAvatarObbietivoService({required int id_utente,required String id_obiettivo,required int livello,required int exp}) async {
    try {
      final response = await client.rpc(
        'completa_obietivi',
        params: {'p_utente_id': id_utente, 'p_id_obiettivo': id_obiettivo, 'p_livello': livello, 'p_exp': exp},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante l\'aggiornamento dell\'avatar: $e');
    }
  }

}