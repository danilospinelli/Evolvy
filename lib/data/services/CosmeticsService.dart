/*
import 'package:supabase_flutter/supabase_flutter.dart';

class CosmeticsService {
  late final SupabaseClient _client;

  CosmeticsService() {
    this._client = Supabase.instance.client;
  }
  //restituisce una lista dei path edi cosmetici, evidenziando quelli gia acquistati
  //e quelli non ancora acquistati, e quello equipagiato
  Future<dynamic> getCosmeticsService({required int idUtente}) async {
    try {
      final response = await _client.rpc(
        'get_cosmetics_utente',
        params: {'p_utente_id': idUtente},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }

  //aggiorna il database con il cosmetico acquistato
  //e quelli non ancora acquistati, e quello equipagiato
  //e restituisce la lista aggiornata dei cosmetici
  Future<dynamic> buyCosmeticsService({required int idUtente, required int idCosmetico}) async {
    try {
      final response = await _client.rpc(
        'buy_cosmetic',
        params: {'p_utente_id': idUtente, 'p_cosmetico_id': idCosmetico},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }

  //aggiorna il database con il cosmetico equipaggiato
  //e restituisce la lista aggiornata dei cosmetici
  Future<dynamic> equipCosmeticsService({required int idUtente, required int idCosmetico}) async {
    try {
      final response = await _client.rpc(
        'equip_cosmetic',
        params: {'p_utente_id': idUtente, 'p_cosmetico_id': idCosmetico},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }



}
*/