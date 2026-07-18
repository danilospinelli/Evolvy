import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import 'package:flutter_application_1/data/repositories/UserRepository.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MealBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/InsertedFood.dart';

// Creazione di Repository Mock per i test: per interagire con il ViewModel è necessario passargli una repository, ma nei test non facciamo
// delle vere chiamate al db, quindi creiamo delle sotto-classi mock che fano override dei loro metodi che non implementiamo visto che
// le interazioni con il db non ci interessano, i salvataggi locali che vogliamo testare sono fatti dai metodi del ViewModel che
// vengono chiamati ed eseguiti correttamente;
// gli oggetti dei ViewModel che vengono caricati dalle repository qui vengono passati come parametri di esse, in questo modo siamo noi
// che possiamo "creare artificialmente" gli oggetti del finto db passandoli come parametri alle repository
class Mock_LogMealRepository implements LogMealRepository {
  Mock_LogMealRepository({
    List<LoggedFood> colazione = const [],
    List<LoggedFood> pranzo = const [],
    List<LoggedFood> cena = const [],
    List<LoggedFood> spuntino = const [],
  }) {
    logMeal = LogMealModel(
      colazione: colazione,
      pranzo: pranzo,
      cena: cena,
      spuntino: spuntino
    );
  }

  late LogMealModel logMeal;

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
}

class Mock_UserRepository implements UserRepository {
  @override
  Future<UserModel> getUserMacro({required int idUtente}) async {
    return UserModel(
      proteine: 0,
      carboidrati: 0,
      grassi: 0
    );
  }
}

// METODI HELPER --------------------------------------------------------------------------------------------------------------------------------
// Testiamo solo la presenza dei nomi corretti dei cibi, quindi gli altri dati non ci interessano
LoggedFood _food(String nome) {
  return LoggedFood(
    nome: nome,
    quantita: 0,
    calorie: 0,
    carboidrati: 0,
    proteine: 0,
    grassi: 0,
  );
}

// Costruzione del ViewModel inizializzando una situazione con dei cibi già caricati nei pasti
Future<Homepage_ViewModel> _buildViewModel(Mock_LogMealRepository repo) async {
  final vm = Homepage_ViewModel(repo, Mock_UserRepository());
  await vm.initialize();
  return vm;
}

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (MealBox) in uno Scaffold, collegandolo al ViewModel
Widget _arrange(Homepage_ViewModel vm, {required MealType_Enum mealType}) {
  return MaterialApp(
    home: ChangeNotifierProvider<Homepage_ViewModel>.value(
      value: vm,
      child: Scaffold(body: MealBox(mealType: mealType)),
    ),
  );
}

// TESTING -----------------------------------------------------------------------------------------------------------------------------------

void main() {

  // Verifica che alla creazione di un MealBox il suo stato sia "chiuso", con CrossFadeState.showFirst
  testWidgets('MealBox chiuso all\'inizio', (tester) async {
    // Ora attendiamo correttamente la creazione del ViewModel
    final vm = await _buildViewModel(Mock_LogMealRepository(colazione: [_food('Pane')]));
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    final crossFade = tester.widget<AnimatedCrossFade>(
      find.byType(AnimatedCrossFade),
    );

    // Di base, la MealBox è chiusa, mostrando CrossFadeState.showFirst
    expect(crossFade.crossFadeState, CrossFadeState.showFirst);
  });

  // Verifica che quando premi una volta su un MealBox si apra, se ci ripremi si richiude
  testWidgets('on/off di sezione espandibile MealBox', (tester) async {
    final vm = await _buildViewModel(Mock_LogMealRepository(colazione: [_food('Pane')]));
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();
    // Dopo 1 tocco, la MealBox si apre, mostrando CrossFadeState.showSecond
    expect(
      tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade)).crossFadeState,
      CrossFadeState.showSecond,
    );

    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();
    // Dopo 2 tocchi, la MealBox si richiude, mostrando CrossFadeState.showFirst
    expect(
      tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade)).crossFadeState,
      CrossFadeState.showFirst,
    );
  });

  // Verifica che, aprendo un MealBox, ci sia il numero corretto di InsertedFood all'interno e che siano i cibi corretti
  testWidgets('corrispondenza MealBox-InsertedFood', (tester) async {
    final vm = await _buildViewModel(Mock_LogMealRepository(
      colazione: [_food('Pane'), _food('Latte')],
      pranzo: [_food('Pasta')],
    ));
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Colazione));

    await tester.tap(find.text('Colazione'));
    await tester.pumpAndSettle();

    expect(find.byType(InsertedFood), findsNWidgets(2));
    expect(find.textContaining('Pane'), findsOneWidget);
    expect(find.textContaining('Latte'), findsOneWidget);
    // Non da trovare, è stato caricato in Pranzo
    expect(find.textContaining('Pasta'), findsNothing);
  });

  // Verifica che, aprendo un MealBox con nessun cibo caricato, mostri "Nessun cibo caricato"
  testWidgets('out "Nessun cibo caricato" quando il pasto in MealBox è vuoto', (tester) async {
    final vm = await _buildViewModel(Mock_LogMealRepository(colazione: [_food('Pane')]));
    await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Pranzo));

    await tester.tap(find.text('Pranzo'));
    await tester.pumpAndSettle();

    // Ho caricato un cibo (Pane) in colazione, ma sto verificando il MealBox del pranzo
    expect(find.text('Nessun cibo caricato'), findsOneWidget);
    expect(find.byType(InsertedFood), findsNothing);
  });

  // Verifica che, aprendo un MealBox, mostri SOLO i cibi caricati nel suo pasto e nessun altro
  testWidgets(
    'mostra solo i cibi del proprio pasto (MealType_Enum) in MealBox', (tester) async {
      final vm = await _buildViewModel(Mock_LogMealRepository(
        colazione: [_food('Pane')],
        pranzo: [_food('Pasta')],
        cena: [_food('Pesce')],
        spuntino: [_food('Mela')],
      ));

      await tester.pumpWidget(_arrange(vm, mealType: MealType_Enum.Cena));
      await tester.tap(find.text('Cena'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Pesce'), findsOneWidget);
      expect(find.textContaining('Pane'), findsNothing);
      expect(find.textContaining('Pasta'), findsNothing);
      expect(find.textContaining('Mela'), findsNothing);
    },
  );
}