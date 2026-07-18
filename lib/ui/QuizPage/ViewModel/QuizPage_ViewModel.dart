import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

class QuizPage_ViewModel extends ChangeNotifier {
  final QuizRepository repo;

  QuizPage_ViewModel(this.repo);

  // TODO: GESTIRE DINAMICAMENTE L'UTENTE
  static const int _currentUserId = 1;
  static const int expPerCorrectAnswer = 2;

  // Stato
  bool _isLoading = false;
  // Lista dei 5 quiz giornalieri. null = non ancora caricata con successo
  // (primo giro, o caricamento fallito); [] = caricata e vuota per davvero.
  List<QuizModel>? _quizzes;
  // Indice della domanda (da 0 a 4)
  int _currentIndex = 0;
  // Indice della risposta selezionata (da 0 a 2)
  int? _selectedIndex;
  // True se ho finito tutti i quiz
  bool _finished = false;

  bool get isLoading => _isLoading;
  bool get hasError => !_isLoading && _quizzes == null;
  bool get finished => _finished;
  int get totalQuestions => _quizzes?.length ?? 0;
  int get currentQuestionNumber => _currentIndex + 1;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;
  int? get selectedIndex => _selectedIndex;

  QuizModel? get _currentQuiz =>
      (_quizzes == null || _quizzes!.isEmpty) ? null : _quizzes![_currentIndex];
  
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


  // Completa la domanda corrente rispondendo con l'opzione [index]: prima accredita
  // all'avatar l'exp del quiz (con eventuale level up e monete), poi registra la
  // risposta sul db. L'avatar arriva dalla View perché il calcolo del level up
  // vive in Avatar_ViewModel.
  Future<int> completaQuiz(int index, Avatar_ViewModel avatarVM) async {
    final quiz = _currentQuiz;
    if (quiz == null || quiz.risposta) return 0;

    // tengo lo stato precedente: se il salvataggio fallisce ci torno indietro
    final precedente = quiz;
    final i = _currentIndex;

    // mostro subito la risposta selezionata, poi la persisto
    _selectedIndex = index;
    _quizzes![i] = quiz.copyWith(risposta: true);
    notifyListeners();

    try {
      await repo.checkQuiz(quiz.id, _currentUserId);
    } catch (e) {
      debugPrint('Errore invio risposta quiz: $e');
      // la risposta non è stata registrata: la domanda torna disponibile
      _quizzes![i] = precedente;
      _selectedIndex = null;
      notifyListeners();
      return 0;
    }

    // exp solo dopo che la risposta è sul db, altrimenti un errore di rete
    // la lascerebbe rifattibile e l'utente incasserebbe l'exp due volte.
    // La risposta sbagliata viene comunque registrata, ma non dà exp.
    if (!isCorrect(index)) return 0;

    return avatarVM.aumentaExp(expPerCorrectAnswer);
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
