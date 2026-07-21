import 'package:supabase_flutter/supabase_flutter.dart';

class LogMealService {

  //inizializzazione del client di Supabase. Final per i motivi analoghi descritti prima,
  //non vogliamo sia un oggetto modificabile durante l'esecuzione.

  final SupabaseClient _client= Supabase.instance.client;





  //Recupera i pasti giornalieri per l'utente "utendeId" data una data specifica "data" e una chiamata asincrona al DB
  //gestita tramite una funzione rpc. Utilizza "dateFormatter" per far combaciare il fromato di data di Dart con Supabase.

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

  //Rimuove un cibo specificato da parametri come "Meal" {pranzo cena etc} "nomeCibo" o "quantita" dal diario dell'utente "idUtente". Lo fa tramite una
  //chiamata asincrona al DB e una funzione rpc. Utilizza "dateFormatter" per far combaciare il fromato di data di Dart con Supabase.

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

  //Aggiunge un cibo specificato da parametri come "Meal" {pranzo cena etc.} "nomeCibo" o "quantita" al diario dell'utente "idUtente" con le sue caratteristiche
  //"calorie" "proteine" etc. Lo fa tramite una chiamata asincrona al DB e una funzione rpc. 
  //Utilizza "dateFormatter" per far combaciare il fromato di data di Dart con Supabase.

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

  //Aggiorna un cibo specificato da parametri come "Meal" {pranzo cena etc.} "nomeCibo" o "quantita" al diario dell'utente "idUtente" con le sue caratteristiche
  //"calorie" "proteine" etc. Lo fa tramite una chiamata asincrona al DB e una funzione rpc. 
  //Utilizza "dateFormatter" per far combaciare il fromato di data di Dart con Supabase.
  //Utilizzato quando l'utente vuole modificare le quantità di un pasto già inserito nel LogMeal.

  Future<void> updateCiboService({
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
        'aggiorna_log_pasto',
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
      throw Exception('Errore durante l\'aggiornamento del cibo: $e');
    }
  }


}


  //Funzione helper per formattare la data fornita da Dart con "DataTime" nella classica
  //notazione ""anno-mese-giorno" per farla combaciare con quella di Supabase.
  //Usa padLeft per accomunare mesi e giorni con singola cifra allo stesso formato. (1 gennaio = 01 01).

  String dateFormatter(DateTime data) {
    final y = data.year.toString().padLeft(4, '0');
    final m = data.month.toString().padLeft(2, '0');
    final d = data.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }