import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/domain/models/QuizModel.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';

// File di metodi helper per la creazione di ogegtti del model.
// E' possibile passare qualsiasi parametro per personalizzare quell'istanza, ma hanno tutti dei valori di default per rendere
// il codice di test più pulito.

QuizModel buildQuizModel({
  int id = 1,
  String answers1 = 'Risposta 1',
  String answers2 = 'Risposta 2',
  String answers3 = 'Risposta 3',
  bool value1 = true,
  bool value2 = false,
  bool value3 = false,
  bool risposta = false,
}) {
  return QuizModel(
    id: id,
    question: 'Domanda',
    answers1: answers1,
    answers2: answers2,
    answers3: answers3,
    value1: value1,
    value2: value2,
    value3: value3,
    spiegazione: 'Spiegazione',
    risposta: risposta,
  );
}

LogMealModel buildLogMealModel({
  List<LoggedFood> colazione = const [],
  List<LoggedFood> pranzo = const [],
  List<LoggedFood> cena = const [],
  List<LoggedFood> spuntino = const [],
}) {
  return LogMealModel(
    colazione: colazione,
    pranzo: pranzo,
    cena: cena,
    spuntino: spuntino
  );
}

AvatarModel buildAvatarModel({
  String username = 'Utente',
  int livello = 0,
  int exp = 0,
  int monete = 0,
  int streak = 0,
  int chosenColor = 0,
  List<Obiettivo> obiettivi = const []
}) {
  return AvatarModel(
    username: username,
    livello: livello,
    exp: exp,
    monete: monete,
    streak: streak,
    chosenColor: chosenColor,
    obiettivi: obiettivi
  );
}

Obiettivo buildObiettivo({
  int id = 0,
  String testo = 'Sfida',
  int xpReward = 20,
  bool completed = false
}) {
  return Obiettivo(
    id: id,
    testo: testo,
    xpReward: xpReward,
    completed: completed
  );
}

UserModel buildUserModel({
  double proteine = 0,
  double carboidrati = 0,
  double grassi = 0
}) {
  return UserModel(
  proteine: proteine,
  carboidrati: carboidrati,
  grassi: grassi);
}

LoggedFood buildLoggedFood(String nome) {
  return LoggedFood(
    nome: nome,
    quantita: 0,
    calorie: 0,
    carboidrati: 0,
    proteine: 0,
    grassi: 0,
  );
}