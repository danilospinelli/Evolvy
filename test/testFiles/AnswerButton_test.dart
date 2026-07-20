import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/AnswerButton.dart';
import '../mock_repository/Mock_QuizRepository.dart';
import '../mock_repository/Mock_AvatarRepository.dart';
import '../utils/ViewModel_Builders.dart';

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (AnswerButton) in uno Scaffold,
// collegandolo ai due ViewModel con MultiProvider.
// E' necessario passare anche i parametri per la creazione di un widgert AnswerButton:
// index = indice della risposta nel quiz; text = testo della risposta
Widget _arrange(QuizPage_ViewModel quizVM, Avatar_ViewModel avatarVM, {required int index, required String text}) {
  return MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizPage_ViewModel>.value(value: quizVM),
        ChangeNotifierProvider<Avatar_ViewModel>.value(value: avatarVM),
      ],
      child: Scaffold(body: AnswerButton(index: index, text: text)),
    ),
  );
}

// Come _arrange, ma monta tutti e tre gli AnswerButton della domanda corrente, come fa la QuizPage vera:
// serve per i test in cui il colore di un bottone dipende da quale altro bottone è stato cliccato
Widget _arrangeAll(QuizPage_ViewModel quizVM, Avatar_ViewModel avatarVM) {
  final answers = quizVM.answers;
  return MaterialApp(
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizPage_ViewModel>.value(value: quizVM),
        ChangeNotifierProvider<Avatar_ViewModel>.value(value: avatarVM),
      ],
      child: Scaffold(
        body: Column(
          children: [
            for (int i = 0; i < answers.length; i++) AnswerButton(index: i, text: answers[i].text),
          ],
        ),
      ),
    ),
  );
}

// Restituisce il colore del bordo del bottone che mostra la risposta text, per velocizzare la fase di ACT.
// Il bordo sta sul Container decorato che avvolge text, quindi partiamo text e risaliamo al primo Container con ancestor:
// find.byType(Container) da solo non basta, AnswerButton ne ha due annidati (quello del margin e quello della decoration)
// e li matcherebbe entrambi; risalendo dal testo prendiamo sempre quello giusto con .first.
Color? _coloreBordo(WidgetTester tester, String text) {
  final button = tester.widget<Container>(
    find.ancestor(of: find.text(text), matching: find.byType(Container)).first,
  );
  final decoration = button.decoration as BoxDecoration;
  return decoration.border?.top.color;
}

// TESTING -----------------------------------------------------------------------------------------------------------------------------------

void main() {

  // --- Verifica che, finché la domanda non è stata risposta, i bottoni abbiano il bordo grigio
  testWidgets('sulla creazione i bordi di AnswerButton sono neutri (grigi)', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // ASSERT
    // Restano tutte neutre
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // --- Verifica che, azzeccando, venga mostrata la risposta corretta in verde, le altre rimangono neutre
  testWidgets('risposta giusta, mostra verde', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // ACT
    // Clicco la prima risposta, che è giusta
    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    // ASSERT
    // Evidenzia la risposta corretta
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.green.shade400);
    // Le altre restano neutre
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // --- Verifica che, sbagliando, oltre al bottone rosso, venga evidenziata in verde anche la risposta corretta
  testWidgets('risposta sbagliata, mostra rosso e verde', (tester) async {
    // ARRENGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // ACT
    // Clicco la seconda risposta, che è sbagliata
    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    // ASSERT
    // La corretta diventa verde anche se non l'ho selezionata
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.green.shade400);
    // Quella sbagliata diventa rossa
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.red.shade400);
    // La terza è sbagliata ma non l'ho selezionata: resta neutra
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // --- Verifica che, cliccando un AnswerButton, la domanda risulti risposta nel ViewModel,
  // e che venga registrato l'indice della risposta scelta
  testWidgets('persistenza della risposta', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    // ACT
    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    // ASSERT
    // Dopo il click: answered = true, selectedIndex = 1
    expect(vm_quiz.answered, isTrue);
    expect(vm_quiz.selectedIndex, 1);
  });

  // --- Verifica che, rispondendo correttamente, l'avatar guadagni l'exp del quiz
  testWidgets('risposta giusta, guadagno di exp', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 0, text: 'Risposta 1'));

    // ACT
    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(vm_avatar.user!.exp, QuizPage_ViewModel.expPerCorrectAnswer);
  });

  // --- Verifica che, rispondendo correttamente, appaia la SnackBar per l'exp
  testWidgets('risposta giusta, apparizione SnackBar', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 0, text: 'Risposta 1'));

    // ACT
    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(SnackBar), findsOneWidget);
  });

  // --- Verifica che, sbagliando, non si guadagni exp
  testWidgets('risposta sbagliata, non guadagno di exp', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    // ACT
    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(vm_avatar.user!.exp, 0);
  });

  // --- Verifica che, sbagliando, non appaia la SnackBar
  testWidgets('risposta sbagliata, nessuna SnackBar', (tester) async {
    // ARRANGE
    final vm_quiz = await buildQuizViewModel(Mock_QuizRepository());
    final vm_avatar = await buildAvatarViewModel(Mock_AvatarRepository());
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    // ACT
    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    // ASSERT
    expect(find.byType(SnackBar), findsNothing);
  });

}
