import 'package:supabase_flutter/supabase_flutter.dart';

class CosmeticsService {
  late final SupabaseClient client;

  CosmeticsService() {
    this.client = Supabase.instance.client;
  }
  //restituisce una lista dei path edi cosmetici, evidenziando quelli gia acquistati
  //e quelli non ancora acquistati, e quello equipagiato
  Future<dynamic> getCosmeticsService({required int id_utente}) async {
    try {
      final response = await client.rpc(
        'get_cosmetics_utente',
        params: {'p_utente_id': id_utente},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }

  //aggiorna il database con il cosmetico acquistato
  //e quelli non ancora acquistati, e quello equipagiato
  //e restituisce la lista aggiornata dei cosmetici
  Future<dynamic> buyCosmeticsService({required int id_utente, required int id_cosmetico}) async {
    try {
      final response = await client.rpc(
        'buy_cosmetic',
        params: {'p_utente_id': id_utente, 'p_cosmetico_id': id_cosmetico},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }

  //aggiorna il database con il cosmetico equipaggiato
  //e restituisce la lista aggiornata dei cosmetici
  Future<dynamic> equipCosmeticsService({required int id_utente, required int id_cosmetico}) async {
    try {
      final response = await client.rpc(
        'equip_cosmetic',
        params: {'p_utente_id': id_utente, 'p_cosmetico_id': id_cosmetico},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero delle cosmetics: $e');
    }
  }



}
