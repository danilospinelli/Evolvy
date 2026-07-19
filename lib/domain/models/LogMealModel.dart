class LogMealModel {

  // Qesta classe ed i suoi parametri rappresentano il LogMealModel, ovvero la suddivisione della struttura vera e propria
  // del diario di un utente nei 4 pasti principali. Inizialmente non sa che cibi ci sono dentro ogni pasto.

  List<LoggedFood> colazione = [];
  List<LoggedFood> pranzo = [];
  List<LoggedFood> cena = [];
  List<LoggedFood> spuntino = [];

//Costruttore per il LogMeal con parametri required. Anche se non c'è nessun cibo mangiato a colazione
//vogliamo comunque la lista vuota.

  LogMealModel({
    required this.colazione,
    required this.pranzo,
    required this.cena,
    required this.spuntino,
  });

  //Metodo Factory che prende in input i file JSON della repository e restituisce un ogetto Dart ben definito e parametrizzato.
  //Questo metodo utilizza il metodo di LoggedFood e alla fine restituisce la lista compatta. 
  //Ciclerà tramite map su ogni alimento contenuto nel file JSON della repository e LoggedFood trasofmerà ogni cibo in un ogetto ben definito, assegnato poi ad un pasto.

  factory LogMealModel.fromJson(Map<String, dynamic> json) {
    return LogMealModel(
      colazione: (json['colazione'] as List<dynamic>).map((item) => LoggedFood.fromJson(item as Map<String, dynamic>)).toList(),
      pranzo: (json['pranzo'] as List<dynamic>).map((item) => LoggedFood.fromJson(item as Map<String, dynamic>)).toList(),
      cena: (json['cena'] as List<dynamic>).map((item) => LoggedFood.fromJson(item as Map<String, dynamic>)).toList(),
      spuntino: (json['spuntino'] as List<dynamic>).map((item) => LoggedFood.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}



class LoggedFood {

  //Classe e parametri che rappresentano un cibo singolo loggato con le proprie caratteristiche nutrizionali.

  final String nome;
  final double quantita;
  final double calorie;
  final double carboidrati;
  final double proteine;
  final double grassi;

//Costruttore per un singolo cibo loggato. Ovviamente required perchè un cibo deve avere tutti i valori nutrizionali

  LoggedFood({
    required this.nome,
    required this.quantita,
    required this.calorie,
    required this.carboidrati,
    required this.proteine,
    required this.grassi,
  });

  //Metodo factory che prende in input i JSON dal metodo sopra LogMealModel. Ogni singolo cibo verra preso e verra convertito in un ogetto Dart
  //ben parametrizzato e definito. I suoi valori verranno messi a Double per completezza. Il risultato verra resrtituito al metodo sopra e messo nella 
  //lista corretta.
  
  factory LoggedFood.fromJson(Map<String, dynamic> json) {
    return LoggedFood(
      nome: json['nome'] as String,
      quantita: (json['quantita'] as num).toDouble(),
      calorie: (json['calorie'] as num).toDouble(),
      carboidrati: (json['carboidrati'] as num).toDouble(),
      proteine: (json['proteine'] as num).toDouble(),
      grassi: (json['grassi'] as num).toDouble(),
    );
  }


}

