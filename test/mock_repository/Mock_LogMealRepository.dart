import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import '../utils/Model_Builders.dart';

// Creazione di Repository Mock per i test: per creare un ViewModel è necessario passargli una repository, ma nei test non facciamo
// delle vere chiamate al db, quindi creiamo delle sotto-classi mock che fano override dei loro metodi che non implementiamo visto che
// le interazioni con il db non ci interessano, i salvataggi locali che vogliamo testare sono fatti dai metodi del ViewModel che
// vengono chiamati ed eseguiti correttamente.
// Ogni repository si occupa di un oggetto del model, quindi per simulare un caricamento da db, passiamo quell'oggetto del model come
// parametro per creare il mock della repository, in questo modo possiamo far caricare dalla nostra repository mock un'istanza creata da noi.

// In Dart, i campi final devono essere iizializzati prima che nizi il corpo del costruttore: per questo si usa l'operatore ":" = initializer list
// -> prima di inziiare il corpo del costruttore, esegue ciò che c'è dopo :
class Mock_LogMealRepository implements LogMealRepository {
  Mock_LogMealRepository({LogMealModel? logMeal}) :
    logMeal = logMeal ?? buildLogMealModel();
  
  final LogMealModel logMeal;

  @override
  Future<LogMealModel> getPastiGiornalieri(int utenteId, DateTime data) async {return logMeal;}
  @override
  Future<void> removeCibo({
    required int idUtente,
    required DateTime data,
    required String meal,
    required String nomeCibo,
    required double quantita,
  }) async {}
  @override
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
  }) async {}
  @override
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
    }) async {}
}