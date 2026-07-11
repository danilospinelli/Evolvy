class QuizModel {
  final int id;
  final String question;
  final String answers1;
  final String answers2;
  final String answers3;
  final bool value1;
  final bool value2;
  final bool value3;
  final String spiegazione;
  final bool risposta;

  QuizModel({
    required this.id,
    required this.question,
    required this.answers1,
    required this.answers2,
    required this.answers3,
    required this.value1,
    required this.value2,
    required this.value3,
    required this.spiegazione,
    required this.risposta
  });


  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
        id: json['id'] as int,
        question: json['domanda'] as String,
        answers1: json['risposta1'] as String,
        answers2: json['risposta2'] as String,
        answers3: json['risposta3'] as String,
        value1: json['check1'] as bool,
        value2: json['check2'] as bool,
        value3: json['check3'] as bool,
        spiegazione: json['spiegazione'] as String,
        // di default lo trattiamo come non risposto
        risposta: json['risposto'] as bool? ?? false
    );

  }
}

class QuizModelList {
  final List<QuizModel> quizzes;

  QuizModelList({required this.quizzes});

  factory QuizModelList.fromJson(List<dynamic> jsonList) {
    List<QuizModel> quizzes = jsonList.map((json) => QuizModel.fromJson(json)).toList();
    return QuizModelList(quizzes: quizzes);
  }
}

