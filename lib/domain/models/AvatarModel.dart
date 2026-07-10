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
      username: _asString(json['username'] ?? json['nome_avatar']),
      livello: _asInt(json['livello']),
      exp: _asInt(json['exp']),
      monete: _asInt(json['monete']),
      streak: _asInt(json['streak']),
      chosen_color: _asInt(json['chosen_color'] ?? json['colore_avatar']),
      // La RPC restituisce null quando non ci sono obiettivi per la giornata
      obiettivi: (json['obiettivi_giornalieri'] as List<dynamic>? ?? [])
          .map((o) => Obiettivo.fromMap(o as Map<String, dynamic>))
          .toList(),
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
      id: _asString(json['id_obiettivo'] ?? json['id']),
      title: _asString(json['testo'] ??
          json['title'] ??
          json['titolo'] ??
          json['descrizione'] ??
          json['nome']),
      xpReward: _asInt(json['exp_obiettivo'] ??
          json['xpReward'] ??
          json['xp_reward'] ??
          json['exp'] ??
          json['ricompensa'] ??
          json['xp']),
      completed: _asBool(json['completato'] ?? json['completed']),
    );
  }
}

// Helper di conversione difensivi: la forma esatta restituita dalle RPC di
// Supabase puo' variare (nomi di campo IT/EN, numeri come stringa, null), quindi
// evitiamo cast rigidi che farebbero crashare l'intera pagina.
String _asString(dynamic value) => value?.toString() ?? '';

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

bool _asBool(dynamic value) {
  if (value is bool) return value;
  final s = value?.toString().toLowerCase();
  return s == 'true' || s == 't' || s == '1';
}
