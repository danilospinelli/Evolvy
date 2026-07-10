class AvatarModel {

  final String username;
  final int livello;
  final int exp;
  final int monete;
  final int streak;
  final int chosen_color;
  final List<Obiettivo> obiettivi;


  AvatarModel({
    required this.username,
    required this.livello,
    required this.exp,
    required this.monete,
    required this.streak,
    required this.chosen_color,
    required this.obiettivi,
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      username: json['username'] as String,
      livello: json['livello'] as int,
      exp: json['exp'] as int,
      monete: json['monete'] as int,
      streak: json['streak'] as int,
      chosen_color: json['chosen_color'] as int,
      obiettivi: json['obiettivi_giornalieri'] as List<Obiettivo>,
    );
  }

}


class Obiettivo {
  final String id;
  final String title;
  final int xpReward;
  final bool completed;

  Obiettivo({
    required this.id,
    required this.title,
    required this.xpReward,
    this.completed = false,
  });

  factory Obiettivo.fromMap(Map<String, dynamic> json) {
    return Obiettivo(
      id: json['id'] as String,
      title: json['title'] as String,
      xpReward: json['xpReward'] as int,
      completed: json['completed'] as bool? ?? false,
    );
  }
}
