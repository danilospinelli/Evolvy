import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ChallengeCard.dart';

// Creazione di Repository Mock per i test: per interagire con il ViewModel è necessario passargli una repository, ma nei test non facciamo
// delle vere chiamate al db, quindi creiamo delle sotto-classi mock che fano override dei loro metodi che non implementiamo visto che
// le interazioni con il db non ci interessano, i salvataggi locali che vogliamo testare sono fatti dai metodi del ViewModel che
// vengono chiamati ed eseguiti correttamente;
// gli oggetti dei ViewModel che vengono caricati dalle repository qui vengono passati come parametri di esse, in questo modo siamo noi
// che possiamo "creare artificialmente" gli oggetti del finto db passandoli come parametri alle repository
class Mock_AvatarRepository implements AvatarRepository {
  Mock_AvatarRepository({
    // AvatarModel base
    String username = 'Utente',
    int livello = 0,
    int exp = 0,
    int monete = 0,
    int streak = 0,
    int chosenColor = 0,
    List<Obiettivo> obiettivi = const []
  }) {
    user = AvatarModel(
      username: username,
      livello: livello,
      exp: exp,
      monete: monete,
      streak: streak,
      chosenColor: chosenColor,
      obiettivi: obiettivi
    );
  }

  late AvatarModel user;

  @override
  Future<AvatarModel> getAvatarInfo({required int idUtente}) async {return user;}

  @override
  Future<void> updateNomeAvatar({required int idUtente, required String nomeAvatar}) async {}

  @override
  Future<void> updateColoreAvatar({required int idUtente, required int coloreAvatar}) async {}

  @override
  Future<void> completaObiettivoAvatar({required int idUtente, required int idObiettivo}) async {}

  @override
  Future<void> aggiornaDatiAvatar({
    required int idUtente,
    required int livello,
    required int exp,
    required int monete,
  }) async {}
}

// METODI HELPER --------------------------------------------------------------------------------------------------------------------------------
// Crea un obiettivo base
Obiettivo _challenge({
  int id = 0,
  String testo = 'Sfida',
  int xpReward = 20,
  bool completed = false
}) {
  return Obiettivo(
    id: id,
    testo: testo,
    xpReward: xpReward,
    completed: completed
  );
}

// Crea un Avatar_ViewModel iniettando la repository (che avrà al suo interno l'utente)
Future<Avatar_ViewModel> _buildViewModel(Mock_AvatarRepository repo) async {
  final vm = Avatar_ViewModel(repo);
  await vm.initialize();
  return vm;
}

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (ChallengeCard) in uno Scaffold, collegandolo al ViewModel
Widget _arrange(Avatar_ViewModel vm, {required Obiettivo challenge}) {
  return MaterialApp(
    home: ChangeNotifierProvider<Avatar_ViewModel>.value(
      value: vm,
      child: Scaffold(body: ChallengeCard(challenge: challenge)),
    ),
  );
}

// TESTING -----------------------------------------------------------------------------------------------------------------------------------

void main(){

  // Verifica che alla creazione l'obiettivo è completabile
  testWidgets('creazione di ChallengeCard, completabile', (tester) async {
    final vm = await _buildViewModel(Mock_AvatarRepository(obiettivi: [_challenge()]));
    await tester.pumpWidget(_arrange(vm, challenge: _challenge()));

    // L'unico obiettivo che ho inserito nella lista di obiettivi dell'utente (nella repository) è quello di indice 0
    expect(vm.user?.obiettivi[0].completed, false);
  });

  // Verifica che alla creazione l'obiettivo è graficamente neutro
  testWidgets('creazione di ChallengeCard, grafica neutra', (tester) async {
    final vm = await _buildViewModel((Mock_AvatarRepository()));
    await tester.pumpWidget(_arrange(vm, challenge: _challenge()));

    final card = tester.widget<Text>(find.text('Sfida'));
    
    // Marker di completamento Obiettivo assenti
    expect(card.style?.decoration, TextDecoration.none);
    expect(find.byType(Icon), findsNothing);
  });

  // Verifica che, completando l'obiettivo, esso è marcato come tale
  testWidgets('completamento di un obiettivo', (tester) async {
    final vm = await _buildViewModel(Mock_AvatarRepository(obiettivi: [_challenge()]));
    await tester.pumpWidget(_arrange(vm, challenge: _challenge()));

    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // L'unico obiettivo che ho inserito nella lista di obiettivi dell'utente (nella repository) è quello di indice 0
    expect(vm.user?.obiettivi[0].completed, true);
  });

  // Verifica che, completando l'obiettivo, viene mostrato un bollino verde e una linea orizzontale che copre il testo
  testWidgets('marker grafico per il completamento dell\'obiettivo', (tester) async {
    final vm = await _buildViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: _challenge(completed: true)));

    final card = tester.widget<Text>(find.text('Sfida'));

    // Marker di completamento Obiettivo presenti
    expect(card.style?.decoration, TextDecoration.lineThrough);
    expect(find.byType(Icon), findsOneWidget);
  });

  // Verifica che, completando l'obiettivo, l'utente guadagna l'exp dell'obiettivo
  testWidgets('guadagno di exp al completamento dell\'obiettivo', (tester) async {
    final challenge = _challenge();
    final vm = await _buildViewModel(Mock_AvatarRepository(obiettivi: [challenge]));
    await tester.pumpWidget(_arrange(vm, challenge: challenge));

    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // L'utente ha di base 0 exp e l'obiettivo ne da 20 (nei costruttore di deafult dei metodi helper)
    expect(vm.user?.exp, 20);
  });

  // Verifica che, completando l'obiettivo, viene mostrata la SnackBar
  testWidgets('SnackBar mostrata al completamento dell\'obiettivo', (tester) async {
    final challenge = _challenge();
    final vm = await _buildViewModel(Mock_AvatarRepository(obiettivi: [challenge]));
    await tester.pumpWidget(_arrange(vm, challenge: challenge));

    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  // Verifica che, una volta completato l'obiettivo, non si può completare di nuovo
  testWidgets('disattivamento dell\'obiettivo dopo averlo completato', (tester) async {
    final vm = await _buildViewModel((Mock_AvatarRepository()));
    await tester.pumpWidget(_arrange(vm, challenge: _challenge(completed: true)));

    int oldXp = 0;
    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // L'obiettivo è già completato, se ci ripremo sopra non succede niente
    expect(find.byType(SnackBar), findsNothing);
    expect(vm.user?.exp, oldXp);
  });
}