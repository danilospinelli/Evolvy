import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';

class QuizPage_ViewModel extends ChangeNotifier {
  final QuizRepository repo = QuizRepository();

  // TODO: sostituire con l'id dell'utente autenticato quando sarà disponibile un sistema di auth
  static const int _currentUserId = 1;
  static const int _expPerCorrectAnswer = 2;


  // TODO: SONO VARIABILI DA METTERE NEL DOMINIO

  // Stato
  bool _isLoading = false;
  List<QuizModel> _quizzes = [];
  // Indice della domanda (da 0 a 4)
  int _currentIndex = 0;
  // Indice della risposta selezionata (da 0 a 2)
  int? _selectedIndex;
  // True se ho risposto alla domanda
  bool _answered = false;
  // True se ho finito tutti i quiz
  bool _finished = false;
  // ???
  String? _error;
  String? _submitError;

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get submitError => _submitError;
  bool get finished => _finished;
  int get totalQuestions => _quizzes.length;
  int get currentQuestionNumber => _currentIndex + 1;
  bool get isLastQuestion => _currentIndex >= _quizzes.length - 1;
  int? get selectedIndex => _selectedIndex;
  bool get answered => _answered;

  QuizModel? get _currentQuiz =>
      _quizzes.isEmpty ? null : _quizzes[_currentIndex];
  String get question => _currentQuiz?.question ?? '';
  String get spiegazione => _currentQuiz?.spiegazione ?? '';

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
      _quizzes = result.quizzes.where((q) => !q.risposta).toList();
      _currentIndex = 0;
      _selectedIndex = null;
      _answered = false;
      _finished = false;
      _error = null;
      _submitError = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Errore caricamento quiz: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Salva la risposta scelta dall'utente e la invia al backend con l'exp guadagnata
  void selectAnswer(int index) {
    if (_answered) return;
    _selectedIndex = index;
    _answered = true;
    notifyListeners();

    final quiz = _currentQuiz;
    if (quiz == null) return;
    final expGuadagnata = isCorrect(index) ? _expPerCorrectAnswer : 0;
    _submitAnswer(quiz.id, expGuadagnata);
  }

  // Invia al backend la singola risposta appena data
  Future<void> _submitAnswer(int idQuiz, int expGuadagnata) async {
    try {
      await repo.checkQuiz(idQuiz, _currentUserId, expGuadagnata);
      _submitError = null;
    } catch (e) {
      _submitError = e.toString();
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
    _answered = false;
    _submitError = null;
    notifyListeners();
  }
}
