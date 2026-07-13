import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

class QuizPage_ViewModel extends ChangeNotifier {
  final QuizRepository repo = QuizRepository();

  // TODO: GESTIRE DINAMICAMENTE L'UTENTE
  static const int _currentUserId = 1;
  static const int _expPerCorrectAnswer = 2;

  // Stato
  bool _isLoading = false;
  // Lista dei 5 quiz giornalieri
  List<QuizModel> _quizzes = [];
  // Indice della domanda (da 0 a 4)
  int _currentIndex = 0;
  // Indice della risposta selezionata (da 0 a 2)
  int? _selectedIndex;
  // True se ho finito tutti i quiz
  bool _finished = false;

  bool get isLoading => _isLoading;
  bool get finished => _finished;
  int get totalQuestions => _quizzes.length;
  int get currentQuestionNumber => _currentIndex + 1;
  bool get isLastQuestion => _currentIndex >= _quizzes.length - 1;
  int? get selectedIndex => _selectedIndex;

  QuizModel? get _currentQuiz =>
      _quizzes.isEmpty ? null : _quizzes[_currentIndex];
  String get question => _currentQuiz?.question ?? '';
  String get spiegazione => _currentQuiz?.spiegazione ?? '';
  bool get answered => _currentQuiz?.risposta ?? false;
  // Restituisce le risposte della domanda corrente come lista di record (testo + correttezza)
  List<({String text, bool correct})> get answers {
    final quiz = _currentQuiz;
    if (quiz == null) return [];
    return [
      (text: quiz.answers1, correct: quiz.value1),
      (text: quiz.answers2, correct: quiz.value2),
      (text: quiz.answers3, correct: quiz.value3),
    ];
  }
  // True se l'indice della risposta selezionata è quello della risposta corretta
  bool isCorrect(int index) => answers[index].correct;


  // Carica le domande del quiz giornaliero dell'utente dal repository
  Future<void> initialize({int idUtente = _currentUserId}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await repo.getQuiz(idUtente);
      // scarta le domande già risposte oggi, anche se il backend le restituisce comunque
      _quizzes = result.where((q) => !q.risposta).toList();
      _currentIndex = 0;
      _selectedIndex = null;
      _finished = false;
    } catch (e) {
      debugPrint('Errore caricamento quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Metodo per quando l'utente seleziona una risposta di un Quiz: marca il Quiz come risposto e
  // se la risposta era corretta dà l'exp
  // TODO: PARAMETRO VIEWMODEL POSSIBILE???
  void selectAnswer(int index, Avatar_ViewModel avatarVM) {
    if (answered) return;
    _selectedIndex = index;
    _currentQuiz!.risposta = true;
    notifyListeners();

    final quiz = _currentQuiz;
    if (quiz == null) return;

    final expGuadagnata = isCorrect(index) ? _expPerCorrectAnswer : 0;
    avatarVM.aggiornaExp(expGuadagnata);

    final avatar = avatarVM.user!;
    _submitAnswer(quiz.id, avatar.exp, avatar.livello, avatar.monete);
  }

  // Invia al backend la singola risposta appena data
  Future<void> _submitAnswer(int idQuiz, int exp, int livello, int monete) async {
    try {
      await repo.checkQuiz(idQuiz, _currentUserId, exp, livello, monete);
    } catch (e) {
      debugPrint('Errore invio risposta quiz: $e');
    }
    notifyListeners();
  }

  // Passa alla domanda successiva della sessione, o la conclude se era l'ultima
  void nextQuestion() {
    if (isLastQuestion) {
      _finished = true;
      notifyListeners();
      return;
    }
    _currentIndex++;
    _selectedIndex = null;
    notifyListeners();
  }
}
