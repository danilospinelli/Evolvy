class LoggedFood {
  String nome;
  double quantita;
  double calorie;
  double carboidrati;
  double proteine;
  double grassi;

  LoggedFood({
    required this.nome,
    required this.quantita,
    required this.calorie,
    required this.carboidrati,
    required this.proteine,
    required this.grassi,
  });

  //converte i json in loggedfood
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

  @override
  String toString(){
    return "$nome $quantita g $calorie kcal";;
  }
}

class LogMeal {
  List<LoggedFood> colazione = [];
  List<LoggedFood> pranzo = [];
  List<LoggedFood> cena = [];
  List<LoggedFood> spuntino = [];

  LogMeal({
    required this.colazione,
    required this.pranzo,
    required this.cena,
    required this.spuntino,
  });

  //converte i json in logmeal
  factory LogMeal.fromJson(Map<String, dynamic> json) {
    return LogMeal(
      colazione: (json['colazione'] as List<dynamic>)
          .map((item) => LoggedFood.fromJson(item as Map<String, dynamic>))
          .toList(),
      pranzo: (json['pranzo'] as List<dynamic>)
          .map((item) => LoggedFood.fromJson(item as Map<String, dynamic>))
          .toList(),
      cena: (json['cena'] as List<dynamic>)
          .map((item) => LoggedFood.fromJson(item as Map<String, dynamic>))
          .toList(),
      spuntino: (json['spuntino'] as List<dynamic>)
          .map((item) => LoggedFood.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
