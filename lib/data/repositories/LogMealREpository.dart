import '../../domain/models/LogMealModel.dart';
import '../services/LogMealService.dart';

class LogMealRepository {
  late final LogMealService _logmealservice;

  
  LogMealRepository(){
    this._logmealservice = LogMealService();
  }


  Future<LogMealModel> getPastiGiornalieri(int utenteId, DateTime data) async {
    final mealJson = await _logmealservice.getPastiGiornalieriService(
      utenteId: utenteId,
      data: data,
    );
    return LogMealModel.fromJson(mealJson);
  }

  Future<void> removeCibo({
    required int idUtente,
    required DateTime data,
    required String meal,
    required String nomeCibo,
    required double quantita,
  }) async {
    await _logmealservice.removeCiboService(
      idUtente: idUtente,
      data: data,
      meal: meal,
      nomeCibo: nomeCibo,
      quantita: quantita,
    );
  }

  Future<void> addCibo({
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
    await _logmealservice.addCiboService(
      idUtente: idUtente,
      data: data,
      meal: meal,
      nomeCibo: nomeCibo,
      quantita: quantita,
      calorie: calorie,
      carboidrati: carboidrati,
      proteine: proteine,
      grassi: grassi,
    );
  }

    Future<void> updateCibo({
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
      await _logmealservice.updateCiboService(
        idUtente: idUtente,
        data: data,
        meal: meal,
        nomeCibo: nomeCibo,
        quantita: quantita,
        calorie: calorie,
        carboidrati: carboidrati,
        proteine: proteine,
        grassi: grassi,
      );
    }



}
