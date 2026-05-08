import 'package:flutter_application_1/data/services/LogMealService.dart';
import '../../domain/models/LogMealModel.dart';

class LogMealRepository {
  LogMealRepository({LogMealService? logMealService})
    : _logMealService = logMealService ?? LogMealService();

  final LogMealService _logMealService;

  // metodi che la repository espone al di fuori
  Future<LogMeal> getLogMealByDate(int utenteId, DateTime data) async {
    final mealJson = await _logMealService.getPastiGiornalieriService(
      utenteId: utenteId,
      data: data,
    );
    return LogMeal.fromJson(mealJson);
  }

  Future<void> removeCibo({
    required int id_utente,
    required DateTime data,
    required String meal,
    required String nome_cibo,
    required double quantita,
  }) async {
    await _logMealService.removeCiboService(
      id_utente: id_utente,
      data: data,
      meal: meal,
      nome_cibo: nome_cibo,
      quantita: quantita,
    );
  }

  Future<void> addCibo({
    required int id_utente,
    required DateTime data,
    required String meal,
    required String nome_cibo,
    required double quantita,
    required double calorie,
    required double carboidrati,
    required double proteine,
    required double grassi,
  }) async {
    await _logMealService.addCiboService(
      id_utente: id_utente,
      data: data,
      meal: meal,
      nome_cibo: nome_cibo,
      quantita: quantita,
      calorie: calorie,
      carboidrati: carboidrati,
      proteine: proteine,
      grassi: grassi,
    );
  }
}
