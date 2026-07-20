class FoodModel {

  //Parametri che definiscono un generico cibo. Totalmente indipendente dal logMeal dell'utente.

  final String nome;
  final double kcalper100;
  final double protper100;
  final double carbper100;
  final double grasper100;

//Costruttore principale. I parametri sono required per costruire sempre un cibo
//senza mancanza di informazioni.

  FoodModel({
    required this.nome,
    required this.kcalper100,
    required this.protper100,
    required this.carbper100,
    required this.grasper100,
  });

//Metodo factory che prende il file JSON mandato dalla repository e costruisce l'ogetto Dart FoodModel 
//ben parametrizzato con valori Double per rappresentare bene i macro nutrienti.

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      nome: json['nome'] as String,
      kcalper100: (json['kcalper100'] as num).toDouble(),
      protper100: (json['protper100'] as num).toDouble(),
      carbper100: (json['carbper100'] as num).toDouble(),
      grasper100: (json['grasper100'] as num).toDouble(),
    );
  }

}
