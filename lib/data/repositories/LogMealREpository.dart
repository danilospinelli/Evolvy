import '../../domain/models/LogMealModel.dart';
import '../services/LogMealService.dart';

class LogMealRepository {
  late final LogMealService logmealservice;

  
  LogMealRepository(){
    this.logmealservice=LogMealService();
  }


  // metodi che la repository espone al di fuori
  Future<LogMeal> getPastiGiornalieri(int utenteId, DateTime data) async {
    final mealJson = await logmealservice.getPastiGiornalieriService(
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
    await logmealservice.removeCiboService(
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
    await logmealservice.addCiboService(
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
