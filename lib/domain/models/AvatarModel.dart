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
<<<<<<< HEAD
      username: json['username'] as String,
      livello: (json['livello'] as num).toInt(),
      exp: (json['exp'] as num).toInt(),
      monete: (json['monete'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      chosenColor: (json['chosen_color'] as num).toInt(),
      obiettivi: (json['obiettivi_giornalieri'] as List<dynamic>).map((o) => Obiettivo.fromMap(o as Map<String, dynamic>)).toList(),
    );
  }


=======
      username: _asString(json['username']),
      livello: _asInt(json['livello']),
      exp: _asInt(json['exp']),
      monete: _asInt(json['monete']),
      streak: _asInt(json['streak']),
      chosen_color: _asInt(json['chosen_color']),
      obiettivi: (json['obiettivi_giornalieri'] as List<dynamic>? ?? [])
          .map((o) => Obiettivo.fromMap(o as Map<String, dynamic>))
          .toList(),
    );
  }
>>>>>>> origin/main
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

  factory Obiettivo.fromMap(Map<String, dynamic> json) {
    return Obiettivo(
<<<<<<< HEAD
      id: (json['id_obiettivo'] as num).toInt(),
      testo: (json['testo'] as String),
      xpReward: (json['exp_obiettivo'] as num).toInt(),
      completed: (json['completato'] as bool),
    );
  }
}
=======
      id: _asString(json['id']),
      title: _asString(json['testo']),
      xpReward: _asInt(json['exp_obiettivo']),
      completed: _asBool(json['completato']),
    );
  }
}

String _asString(dynamic value) => value?.toString() ?? '';

int _asInt(dynamic value) => value.toInt(); 

bool _asBool(dynamic value) {
  if (value is bool) return value;
  final s = value?.toString().toLowerCase();
  return s == 'true' || s == 't' || s == '1';
}
>>>>>>> origin/main
