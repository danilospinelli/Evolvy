import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/QuizRepository.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';

//ViewModel per la gestione dei quiz giornalieri gestiti tramite una logica indicizzata. 
//2a componente di gamification dell'applicazione.

class QuizPage_ViewModel extends ChangeNotifier {
  final QuizRepository repo = QuizRepository();

  //Hardcoded. TODO: renderlo dinamico nei prossimi sprint.
  static const int _currentUserId = 1;

  //Costante di gamification per le risposte corrette.
  static const int expPerCorrectAnswer = 2;

  bool _isLoading = false;
  
  //Lista dei 5 quiz giornalieri. null = non ancora caricata con successo.
  List<QuizModel>? _quizzes;
  
  //Indice della domanda (da 0 a 4)
  int _currentIndex = 0;
  //Indice della risposta selezionata (da 0 a 2)
  int? _selectedIndex;
  //True se ho finito tutti i quiz
  bool _finished = false;
  //True mentre la risposta è in corso e si sta salvando sul DB.
  bool _isSubmitting = false;

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get finished => _finished;
  int get totalQuestions => _quizzes?.length ?? 0;
  int get currentQuestionNumber => _currentIndex + 1;
  bool get isLastQuestion => _currentIndex >= totalQuestions - 1;
  int? get selectedIndex => _selectedIndex;

  //ritorna l'ogetto quiz corrente in base a "_currentIndex", altrimenti non ritorna nulla.
  QuizModel? get _currentQuiz =>(_quizzes == null || _quizzes!.isEmpty) ? null : _quizzes![_currentIndex];
  
  String get question => _currentQuiz?.question ?? '';
  String get spiegazione => _currentQuiz?.spiegazione ?? '';
  bool get answered => _currentQuiz?.risposta ?? false;



  //Restituisce le risposte della domanda corrente come lista (testo + correttezza) di una stringa piu il suo booleano associato.
  List<({String text, bool correct})> get answers {
    final quiz = _currentQuiz;
    if (quiz == null) return [];
    return [
      (text: quiz.answers1, correct: quiz.value1),
      (text: quiz.answers2, correct: quiz.value2),
      (text: quiz.answers3, correct: quiz.value3),
    ];
  }

  //Restituisce True se l'indice della risposta selezionata è quello della risposta corretta.
  bool isCorrect(int index) => answers[index].correct;

  //Carica le domande del quiz giornaliero dell'utente "idUtente" dal repository.
  Future<void> initialize({int idUtente = _currentUserId}) async {
    _isLoading = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella a schermo intero resta accesa per tutta la durata dei tentativi.
    final result = await eseguiConRetry(() => repo.getQuiz(idUtente));

    //Si arriva qui solo a caricamento riuscito.
    //Scarta le domande già risposte oggi, anche se il backend le restituisce comunque. Ad esempio magari l'utente ha 
    //chiuso l'app alla 3a domanda su 5.
    _quizzes = result.where((q) => !q.risposta).toList();
    //Ripartiamo da capo sulla nuova lista.
    _currentIndex = 0;
    _selectedIndex = null;
    _finished = false;
    _isLoading = false;
    notifyListeners();
  }


  //Invia la risposta selezionata al backend e aggiorna l'avatar con l'exp guadagnata. Logica di gamification che si collega
  //all'aumentaXp dell'avatarViewModel.
  Future<int> completaQuiz(int index, Avatar_ViewModel avatarVM) async {
    final quiz = _currentQuiz;

    //Blocco dell'esecuzione in questi casi.
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
    //Ricreiamo i record per i quiz come abbiamo sempre fatto con CopyWith mettendo il flag di risposta a True.
    _quizzes![i] = quiz.copyWith(risposta: true);
    notifyListeners();

    if (!isCorrect(index)) return 0;

    //Metodo dell'AvararVM!
    return avatarVM.aumentaExp(expPerCorrectAnswer);
  }

  //Passa alla domanda successiva.
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
