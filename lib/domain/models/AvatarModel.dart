import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';


class AvatarModel {

//variabili che compongono l'aspetto gamificato dell'utente
//rappresentato dall'avatar. 

  final String username;
  final int livello;
  final int exp;
  final int monete;
  final int streak;
  final int chosenColor;
  final List<Obiettivo> obiettivi;

//Costruttore principale. I parametri sono required per non formare
//mai un utente senza qualche dato significativo.

  AvatarModel({
    required this.username,
    required this.livello,
    required this.exp,
    required this.monete,
    required this.streak,
    required this.chosenColor,
    required this.obiettivi,
  });

//Metodo factory che prende in input il JSON mandato dalla repository e crea un oggetto Dart
//ben parametrizzato. il map funziona esattamente come quello in FoodRep, restituendo una lista di
//obiettivi compatta.

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

//Se viene modificato un parametro dell'ogetto AvatarModel si restituisce
//un nuovo record con il copywith aggiornando solo il dato cambiato.

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

