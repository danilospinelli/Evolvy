import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/AnswerButton.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';

// Creazione di Repository Mock per i test: per interagire con il ViewModel è necessario passargli una repository, ma nei test non facciamo
// delle vere chiamate al db, quindi creiamo delle sotto-classi mock che fano override dei loro metodi che non implementiamo visto che
// le interazioni con il db non ci interessano, i salvataggi locali che vogliamo testare sono fatti dai metodi del ViewModel che
// vengono chiamati ed eseguiti correttamente;
// gli oggetti dei ViewModel che vengono caricati dalle repository qui vengono passati come parametri di esse, in questo modo siamo noi
// che possiamo "creare artificialmente" gli oggetti del finto db passandoli come parametri alle repository
class Mock_QuizRepository implements QuizRepository {
  Mock_QuizRepository({this.quizzes = const []});

  // Quiz che getQuiz() restituirà al ViewModel
  final List<QuizModel> quizzes;

  @override
  Future<List<QuizModel>> getQuiz(int idUtente) async => quizzes;

  @override
  Future<void> checkQuiz(int idQuiz, int idUtente) async {}
}

class Mock_AvatarRepository implements AvatarRepository {
  Mock_AvatarRepository({
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
// Crea un QuizModel:
// testiamo il testo delle risposte e quale sia quella corretta, quindi gli altri dati non ci interessano;
// di default la prima risposta è quella corretta e la domanda non è ancora stata risposta.
QuizModel _quiz({
  int id = 1,
  String answers1 = 'Risposta 1',
  String answers2 = 'Risposta 2',
  String answers3 = 'Risposta 3',
  bool value1 = true,
  bool value2 = false,
  bool value3 = false,
  bool risposta = false,
}) {
  return QuizModel(
    id: id,
    question: 'Domanda',
    answers1: answers1,
    answers2: answers2,
    answers3: answers3,
    value1: value1,
    value2: value2,
    value3: value3,
    spiegazione: 'Spiegazione',
    risposta: risposta,
  );
}

// Costruzione del ViewModel inizializzando una situazione con dei quiz già caricati dalla repository
// passo repo come parametro così posso creare Mock_QuizRepository passandogli come parametri la lista dei quiz, istanziando una situazione reale
Future<QuizPage_ViewModel> _buildQuizViewModel(Mock_QuizRepository repo) async {
  final vm = QuizPage_ViewModel(repo);
  await vm.initialize(); // Esegue l'inizializzazione asincrona che carica i quiz dal mock
  return vm;
}

// AnswerButton legge anche l'Avatar_ViewModel (per accreditare l'exp), quindi serve inizializzato con un avatar valido
Future<Avatar_ViewModel> _buildAvatarViewModel() async {
  final vm = Avatar_ViewModel(Mock_AvatarRepository());
  await vm.initialize();
  return vm;
}

// Metodo helper per la fase di ARRANGE, avvolge il widget da testare (AnswerButton) in uno Scaffold,
// collegandolo ai due ViewModel con MultiProvider
// * index = indice della risposta nel quiz (parte da 0, come vm.answers); text = testo della risposta
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

// Restituisce il colore del bordo del bottone che mostra la risposta [text].
// Il bordo sta sul Container decorato che avvolge il Text, quindi partiamo dal Text e risaliamo al primo Container:
// find.byType(Container) da solo non basta, AnswerButton ne ha due annidati (quello del margin e quello della decoration)
// e li matcherebbe entrambi; risalendo dal testo prendiamo sempre quello giusto, anche con più bottoni a schermo.
Color? _coloreBordo(WidgetTester tester, String text) {
  final button = tester.widget<Container>(
    find.ancestor(of: find.text(text), matching: find.byType(Container)).first,
  );
  final decoration = button.decoration as BoxDecoration;
  return decoration.border?.top.color;
}

// TESTING -----------------------------------------------------------------------------------------------------------------------------------

void main() {

  // Verifica che, finché la domanda non è stata risposta, i bottoni abbiano il bordo grigio
  testWidgets('sulla creazione i bordi di AnswerButton sono neutri (grigi)', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // Restano tutte neutre
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // Verifica che, azzeccando, venga mostrata la risposta corretta in verde, le altre rimangono neutre
  testWidgets('risposta giusta, mostra verde', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // Clicco la prima risposta, che è giusta
    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    // Evidenzia la risposta corretta
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.green.shade400);
    // Le altre restano neutre
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.grey.shade300);
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // Verifica che, sbagliando, oltre al bottone rosso, venga evidenziata in verde anche la risposta corretta
  testWidgets('risposta sbagliata, mostra rosso e verde', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrangeAll(vm_quiz, vm_avatar));

    // Clicco la seconda risposta, che è sbagliata
    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    // La corretta diventa verde anche se non l'ho selezionata
    expect(_coloreBordo(tester, 'Risposta 1'), Colors.green.shade400);
    // Quella sbagliata diventa rossa
    expect(_coloreBordo(tester, 'Risposta 2'), Colors.red.shade400);
    // La terza è sbagliata ma non l'ho selezionata: resta neutra
    expect(_coloreBordo(tester, 'Risposta 3'), Colors.grey.shade300);
  });

  // Verifica che, cliccando un AnswerButton, la domanda risulti risposta nel ViewModel,
  // e che venga registrato l'indice della risposta scelta
  testWidgets('persistenza della risposta', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    // Prima del click la domanda non è ancora stata risposta
    expect(vm_quiz.answered, isFalse);
    expect(vm_quiz.selectedIndex, isNull);

    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();
    // Dopo il click: answered = true, selectedIndex = 1
    expect(vm_quiz.answered, isTrue);
    expect(vm_quiz.selectedIndex, 1);
  });

  // Verifica che, rispondendo correttamente, l'avatar guadagni l'exp del quiz
  testWidgets('risposta giusta, guadagno di exp', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 0, text: 'Risposta 1'));

    expect(vm_avatar.user!.exp, 0);

    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    expect(vm_avatar.user!.exp, QuizPage_ViewModel.expPerCorrectAnswer);
  });

  // Verifica che, rispondendo correttamente, appaia la SnackBar per l'exp
  testWidgets('risposta giusta, apparizione SnackBar', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 0, text: 'Risposta 1'));

    await tester.tap(find.text('Risposta 1'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });

  // Verifica che, sbagliando, non si guadagni exp
  testWidgets('risposta sbagliata, non guadagno di exp', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    expect(vm_avatar.user!.exp, 0);
  });

  // Verifica che, sbagliando, non appaia la SnackBar
  testWidgets('risposta sbagliata, nessuna SnackBar', (tester) async {
    final vm_quiz = await _buildQuizViewModel(Mock_QuizRepository(quizzes: [_quiz()]));
    final vm_avatar = await _buildAvatarViewModel();
    await tester.pumpWidget(_arrange(vm_quiz, vm_avatar, index: 1, text: 'Risposta 2'));

    await tester.tap(find.text('Risposta 2'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
  });

}
