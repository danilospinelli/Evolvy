import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';

class QuizPage_ViewModel extends ChangeNotifier {
  final QuizRepository repo = QuizRepository();

  static const int _currentUserId = 1;
  static const int expPerCorrectAnswer = 2;

  // Stato
  bool _isLoading = false;
  
  // Lista dei 5 quiz giornalieri. null = non ancora caricata con successo
  List<QuizModel>? _quizzes;
  
  // Indice della domanda (da 0 a 4)
  int _currentIndex = 0;
  // Indice della risposta selezionata (da 0 a 2)
  int? _selectedIndex;
  // True se ho finito tutti i quiz
  bool _finished = false;
  // True mentre la risposta è in corso di salvataggio sul db
  bool _isSubmitting = false;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get finished => _finished;
  int get totalQuestions => _quizzes?.length ?? 0;
  int get currentQuestionNumber => _currentIndex + 1;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;
  int? get selectedIndex => _selectedIndex;

  QuizModel? get _currentQuiz =>(_quizzes == null || _quizzes!.isEmpty) ? null : _quizzes![_currentIndex];
  
  String get question => _currentQuiz?.question ?? '';
  String get spiegazione => _currentQuiz?.spiegazione ?? '';
  bool get answered => _currentQuiz?.risposta ?? false;



  //Restituisce le risposte della domanda corrente come lista (testo + correttezza)
  List<({String text, bool correct})> get answers {
    final quiz = _currentQuiz;
    if (quiz == null) return [];
    return [
      (text: quiz.answers1, correct: quiz.value1),
      (text: quiz.answers2, correct: quiz.value2),
      (text: quiz.answers3, correct: quiz.value3),
    ];
  }

  //restituisce True se l'indice della risposta selezionata è quello della risposta corretta
  bool isCorrect(int index) => answers[index].correct;

  // Carica le domande del quiz giornaliero dell'utente dal repository
  Future<void> initialize({int idUtente = _currentUserId}) async {
    _isLoading = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella a schermo intero resta accesa per tutta la durata dei tentativi.
    final result = await eseguiConRetry(() => repo.getQuiz(idUtente));

    // Si arriva qui solo a caricamento riuscito.
    // scarta le domande già risposte oggi, anche se il backend le restituisce comunque
    _quizzes = result.where((q) => !q.risposta).toList();
    _currentIndex = 0;
    _selectedIndex = null;
    _finished = false;
    _isLoading = false;
    notifyListeners();
  }


  // Invia la risposta selezionata al backend e aggiorna l'avatar con l'exp guadagnata
  Future<int> completaQuiz(int index, Avatar_ViewModel avatarVM) async {
    final quiz = _currentQuiz;

    if (quiz == null || quiz.risposta || _isSubmitting) return 0;

    final i = _currentIndex;

    _isSubmitting = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella sotto le risposte resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repo.checkQuiz(quiz.id, _currentUserId);
    });

    // Si arriva qui solo a invio riuscito.
    _isSubmitting = false;
    _selectedIndex = index;
    _quizzes![i] = quiz.copyWith(risposta: true);
    notifyListeners();


    if (!isCorrect(index)) return 0;

    return avatarVM.aumentaExp(expPerCorrectAnswer);
  }

  // Passa alla domanda successiva
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
