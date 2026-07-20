import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';
import 'package:flutter_application_1/data/repositories/UserRepository.dart';
import '../utils/Model_Builders.dart';

// Creazione di Repository Mock per i test: per creare un ViewModel è necessario passargli una repository, ma nei test non facciamo
// delle vere chiamate al db, quindi creiamo delle sotto-classi mock che fano override dei loro metodi che non implementiamo visto che
// le interazioni con il db non ci interessano, i salvataggi locali che vogliamo testare sono fatti dai metodi del ViewModel che
// vengono chiamati ed eseguiti correttamente.
// Ogni repository si occupa di un oggetto del model, quindi per simulare un caricamento da db, passiamo quell'oggetto del model come
// parametro per creare il mock della repository, in questo modo possiamo far caricare dalla nostra repository mock un'istanza creata da noi.

// In Dart, i campi final devono essere iizializzati prima che nizi il corpo del costruttore: per questo si usa l'operatore ":" = initializer list
// -> prima di inziiare il corpo del costruttore, esegue ciò che c'è dopo :
class Mock_UserRepository implements UserRepository {
  Mock_UserRepository({UserModel? user}):
    user = user ?? buildUserModel();

  final UserModel user;

  @override
  Future<UserModel> getUserMacro({required int idUtente}) async {
    return UserModel(
      proteine: 0,
      carboidrati: 0,
      grassi: 0
    );
  }
}