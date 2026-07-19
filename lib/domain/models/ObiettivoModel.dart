class Obiettivo {
  
  //Parametri per la logica di gamification di un obiettivo.

  final int id;
  final String testo;
  final int xpReward;
  final bool completed;

//Costruttore con parametri required di un generico task giornaliero
//this.completed = false, assumiamo ovviamente che un nuovo obiettivo non sia stato completato.

  Obiettivo({
    required this.id,
    required this.testo,
    required this.xpReward,
    this.completed = false,
  });

//Metodo factory che prende i dati dal JSON e tramite gli appositi casting crea l'oggetto
//Dart ben strutturato.

  factory Obiettivo.fromJson(Map<String, dynamic> json) {
    return Obiettivo(
      id: (json['id_obiettivo'] as num).toInt(),
      testo: (json['testo'] as String),
      xpReward: (json['exp_obiettivo'] as num).toInt(),
      completed: (json['completato'] as bool),
    );
  }

//Metodo che restituisce un nuovo record per l'ogetto Obiettivo.
//Quando viene completato si aggiorna e si aggiorna modificando solo quel campo, lasciano gli altri inaletarti.

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
