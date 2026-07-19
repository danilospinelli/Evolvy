class UserModel {

  //Classe UserModel in cui vengono gestiti questi parametri come i nutrienti assunti
  //da un utente tramite i suoi cibi loggati.

  final double proteine;
  final double carboidrati;
  final double grassi;

//Costruttore di userModel sempre parametrizzato con required.
  UserModel({
    required this.proteine,
    required this.carboidrati,
    required this.grassi,
  });

  //Metodo factory che prende come input un JSON dalla repository e crea un ogetto UserModel ben definito
  //in cui trattiamo tutti gli obiettivi nutrizionali come double per la maggior precisione possibile.

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      proteine: (json['proteine'] as num).toDouble(),
      carboidrati: (json['carboidrati'] as num).toDouble(),
      grassi: (json['grassi'] as num).toDouble(),
    );
  }

//Le calorie sono un parametro calcolato in base alle nostre variabili di istanza, seguono la logica nutrizionale del: 4kcal proteine/carbo, 9kcal grassi.
//Usiamo questo metodo e non creiamo un campo nel DB per far si che le calorie siano SEMPRE legate ai nostri macro, calcolate così a runtime.

  double get calorie => (proteine )*4 + (carboidrati )*4 + (grassi )*9;

//Metodo copywith per creare nuovi record senza modificare tutti i parametri dell'ogetto
//come abbiamo sempre visto precedentemente.

  UserModel copyWith({
    double? proteine,
    double? carboidrati,
    double? grassi,
  }) {
    return UserModel(
      proteine: proteine ?? this.proteine,
      carboidrati: carboidrati ?? this.carboidrati,
      grassi: grassi ?? this.grassi,
    );
  }

}



  



