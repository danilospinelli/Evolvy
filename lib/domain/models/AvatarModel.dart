class AvatarModel {

  final String username;
  final int livello;
  final int exp;
  final int monete;
  final int streak;
  final int chosenColor;
  final List<Obiettivo> obiettivi;


  AvatarModel({
    required this.username,
    required this.livello,
    required this.exp,
    required this.monete,
    required this.streak,
    required this.chosenColor,
    required this.obiettivi,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      username: json['username'] as String,
      livello: (json['livello'] as num).toInt(),
      exp: (json['exp'] as num).toInt(),
      monete: (json['monete'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      chosenColor: (json['chosen_color'] as num).toInt(),
      obiettivi: (json['obiettivi_giornalieri'] as List<dynamic>).map((o) => Obiettivo.fromJson(o as Map<String, dynamic>)).toList(),
    );
  }

  AvatarModel copyWith({
    String? username,
    int? livello,
    int? exp,
    int? monete,
    int? streak,
    int? chosenColor,
    List<Obiettivo>? obiettivi,
  }) {
    return AvatarModel(
      username: username ?? this.username,
      livello: livello ?? this.livello,
      exp: exp ?? this.exp,
      monete: monete ?? this.monete,
      streak: streak ?? this.streak,
      chosenColor: chosenColor ?? this.chosenColor,
      obiettivi: obiettivi ?? this.obiettivi,
    );
  }

}

class Obiettivo {
  final int id;
  final String testo;
  final int xpReward;
  final bool completed;

  Obiettivo({
    required this.id,
    required this.testo,
    required this.xpReward,
    this.completed = false,
  });

  factory Obiettivo.fromJson(Map<String, dynamic> json) {
    return Obiettivo(
      id: (json['id_obiettivo'] as num).toInt(),
      testo: (json['testo'] as String),
      xpReward: (json['exp_obiettivo'] as num).toInt(),
      completed: (json['completato'] as bool),
    );
  }

  Obiettivo copyWith({
    int? id,
    String? testo,
    int? xpReward,
    bool? completed,
  }) {
    return Obiettivo(
      id: id ?? this.id,
      testo: testo ?? this.testo,
      xpReward: xpReward ?? this.xpReward,
      completed: completed ?? this.completed,
    );
  }
}
