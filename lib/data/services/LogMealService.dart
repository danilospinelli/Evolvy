import 'package:supabase_flutter/supabase_flutter.dart';

class LogMealService {

  late final SupabaseClient _client;

  LogMealService(){
    this._client = Supabase.instance.client;
  }




  //Recupera i pasti giornalieri per un utente e una data specifica
  Future<dynamic> getPastiGiornalieriService({required int utenteId,required DateTime data,
  }) async {
    final dateParam = dateFormatter(data);
    try {
      final response = await _client.rpc(
        'get_pasti_giornalieri',
        params: {'p_utente_id': utenteId, 'p_data': dateParam},
      );
      return response;
    } catch (e) {
      throw Exception('Errore durante il recupero dei pasti giornalieri: $e');
    }
  }

  //rimuove un cibo specifico da un pasto per un utente e una data specifica
  Future<void> removeCiboService({
    required int idUtente,
    required DateTime data,
    required String meal,
    required String nomeCibo,
    required double quantita,
  }) async {
    final dateParam = dateFormatter(data);
    try {
      await _client.rpc(
        'elimina_log_pasto',
        params: {
          'p_id_utente': idUtente,
          'p_data': dateParam,
          'p_meal': meal,
          'p_nome_cibo': nomeCibo,
          'p_quantita': quantita,
        },
      );
    } catch (e) {
      throw Exception('Errore durante l\'eliminazione del cibo: $e');
    }
  }

  //aggiunge un cibo specifico a un pasto per un utente e una data specifica
  Future<void> addCiboService({
    required int idUtente,
    required DateTime data,
    required String meal,
    required String nomeCibo,
    required double quantita,
    required double calorie,
    required double carboidrati,
    required double proteine,
    required double grassi,
  }) async {
    final dateParam = dateFormatter(data);
    try {
      await _client.rpc(
        'aggiungi_log_pasto',
        params: {
          'p_id_utente': idUtente,
          'p_data': dateParam,
          'p_meal': meal,
          'p_nome_cibo': nomeCibo,
          'p_quantita': quantita,
          'p_calorie': calorie,
          'p_carboidrati': carboidrati,
          'p_proteine': proteine,
          'p_grassi': grassi,
        },
      );
    } catch (e) {
      throw Exception('Errore durante l\'aggiunta del cibo: $e');
    }
  }


}


  //formatta la data nel formato corretto
  String dateFormatter(DateTime data) {
    final y = data.year.toString().padLeft(4, '0');
    final m = data.month.toString().padLeft(2, '0');
    final d = data.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }