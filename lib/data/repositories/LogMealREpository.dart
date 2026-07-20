import '../../domain/models/LogMealModel.dart';
import '../services/LogMealService.dart';

//Dichiarato final perche non vogliamo in nessun modo che l'ogetto che comunica con internet possa essere modificato
//durante le operazioni o le query.

//Questa classe riguarda tutto il cibo legato all'utente, quindi nel suo LogMeal.

class LogMealRepository {
  late final LogMealService _logmealservice;

  
  LogMealRepository(){
    this._logmealservice = LogMealService();
  }

//Metodo asincrono che restituisce i pasti dell'utente identificati dal suo id e dalla data di inserimento
//(Il concetto di data ci servirà nel TODO: calndario)
//Non si preoccupa della differenza tra [Colazione], [Pranzo] etc... lo delega al model.

  Future<LogMealModel> getPastiGiornalieri(int utenteId, DateTime data) async {
    final mealJson = await _logmealservice.getPastiGiornalieriService(
      utenteId: utenteId,
      data: data,
    );
    return LogMealModel.fromJson(mealJson);
  }

//Metodo di aggiornamento che rimuove un pasto dal diario di un utente, rimuovendolo anche dal database.

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

//Metodo di aggiornamento che aggiunge un pasto al diario di un utente, aggiungendolo anche dal database.

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

//Metodo che aggiorna un cibo di un pasto. Funzione necessaria quando l'utente vuole cambiare
//delle quantità di un cibo inserito o la sua unità di misura. Lo aggiorna nel database.

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
