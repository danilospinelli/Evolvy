class AvatarModel {

  final String  username;
  final int livello;
  final int exp;
  final int monete;
  final int streak;
  final String chosen_color;
  final Map<String, dynamic> obietivo1;
  final Map<String, dynamic> obietivo2;
  final Map<String, dynamic> obietivo3;


  AvatarModel({
    required this.username,
    required this.livello,
    required this.exp,
    required this.monete,
    required this.streak,
    required this.chosen_color,
    required this.obietivo1,
    required this.obietivo2,
    required this.obietivo3
  });

  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      username: json['username'] as String,
      livello: json['livello'] as int,
      exp: json['exp'] as int,
      monete: json['monete'] as int,
      streak: json['streak'] as int,
      chosen_color: json['chosen_color'] as String,
      obietivo1: json['obiettivi_giornalieri'][0] as Map<String, dynamic>,
      obietivo2: json['obiettivi_giornalieri'][1] as Map<String, dynamic>,
      obietivo3: json['obiettivi_giornalieri'][2] as Map<String, dynamic>,
    );
  }

}



