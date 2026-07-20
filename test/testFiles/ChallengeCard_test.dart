import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ChallengeCard.dart';
import '../mock_repository/Mock_AvatarRepository.dart';
import '../utils/ViewModel_Builders.dart';
import '../utils/Model_Builders.dart';

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (ChallengeCard) in uno Scaffold, collegandolo al ViewModel
// E' necessario passare anche i parametri per la creazione di un widgert ChallengeCard:
// challenge = obiettivo a cui si riferisce la card
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

  // --- Verifica che alla creazione l'obiettivo è completabile
  testWidgets('creazione di ChallengeCard, completabile', (tester) async {
    // ARRANGE
    final vm = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: buildObiettivo()));

    // ASSERT
    // L'unico obiettivo che ho inserito nella lista di obiettivi dell'utente (nella repository) è quello di indice 0
    expect(vm.user?.obiettivi[0].completed, false);
  });

  // --- Verifica che alla creazione l'obiettivo è graficamente neutro
  testWidgets('creazione di ChallengeCard, grafica neutra', (tester) async {
    // ARRANGE
    final vm = await buildAvatarViewModel((Mock_AvatarRepository()));
    await tester.pumpWidget(_arrange(vm, challenge: buildObiettivo()));

    // ACT
    final card = tester.widget<Text>(find.text('Sfida'));
    
    // ASSERT
    // Marker di completamento Obiettivo assenti
    expect(card.style?.decoration, TextDecoration.none);
    expect(find.byType(Icon), findsNothing);
  });

  // --- Verifica che, completando l'obiettivo, esso è marcato come tale
  testWidgets('completamento di un obiettivo', (tester) async {
    // ARRANGE
    final vm = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: buildObiettivo()));

    // ACT
    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // ASSERT
    // L'unico obiettivo che ho inserito nella lista di obiettivi dell'utente (nella repository) è quello di indice 0
    expect(vm.user?.obiettivi[0].completed, true);
  });

  // --- Verifica che, completando l'obiettivo, viene mostrato un bollino verde e una linea orizzontale che copre il testo
  testWidgets('marker grafico per il completamento dell\'obiettivo', (tester) async {
    // ARRANGE
    final vm = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: buildObiettivo(completed: true)));

    // ACT
    final card = tester.widget<Text>(find.text('Sfida'));

    // ASSERT
    // Marker di completamento Obiettivo presenti
    expect(card.style?.decoration, TextDecoration.lineThrough);
    expect(find.byType(Icon), findsOneWidget);
  });

  // --- Verifica che, completando l'obiettivo, l'utente guadagna l'exp dell'obiettivo
  testWidgets('guadagno di exp al completamento dell\'obiettivo', (tester) async {
    // ARRANGE
    final challenge = buildObiettivo();
    final vm = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: challenge));

    // ACT
    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // ASSERT
    // L'utente ha di base 0 exp e l'obiettivo ne da 20 (nei costruttore di deafult dei metodi helper)
    expect(vm.user?.exp, 20);
  });

  // --- Verifica che, completando l'obiettivo, viene mostrata la SnackBar
  testWidgets('SnackBar mostrata al completamento dell\'obiettivo', (tester) async {
    // ARRANGE
    final challenge = buildObiettivo();
    final vm = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm, challenge: challenge));

    // ACT
    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(SnackBar), findsOneWidget);
  });

  // --- Verifica che, una volta completato l'obiettivo, non si può completare di nuovo
  testWidgets('disattivamento dell\'obiettivo dopo averlo completato', (tester) async {
    // ARRANGE
    final vm = await buildAvatarViewModel((Mock_AvatarRepository()));
    await tester.pumpWidget(_arrange(vm, challenge: buildObiettivo(completed: true)));

    // ACT
    int oldXp = 0;
    await tester.tap(find.text('Sfida'));
    await tester.pumpAndSettle();

    // ASSERT
    // L'obiettivo è già completato, se ci ripremo sopra non succede niente
    expect(find.byType(SnackBar), findsNothing);
    expect(vm.user?.exp, oldXp);
  });
}