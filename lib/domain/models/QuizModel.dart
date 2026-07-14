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
    required this.risposta,
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


  QuizModel copyWith({
    int? id,
    String? question,
    String? answers1,
    String? answers2,
    String? answers3,
    bool? value1,
    bool? value2,
    bool? value3,
    String? spiegazione,
    bool? risposta,
  }) {
    return QuizModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answers1: answers1 ?? this.answers1,
      answers2: answers2 ?? this.answers2,
      answers3: answers3 ?? this.answers3,
      value1: value1 ?? this.value1,
      value2: value2 ?? this.value2,
      value3: value3 ?? this.value3,
      spiegazione: spiegazione ?? this.spiegazione,
      risposta: risposta ?? this.risposta,
    );
  }
}

