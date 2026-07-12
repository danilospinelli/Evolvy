import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';

class Avatar_ViewModel extends ChangeNotifier {
  final AvatarRepository repo = AvatarRepository();

  // Exp necessaria per salire di livello: livello * _expPerLivello
  // (stessa soglia mostrata dalla barra XP in ProfileHeader)
  static const int _expPerLivello = 10;
  // Monete regalate ad ogni passaggio di livello
  static const int _monetePerLevelUp = 5;

  AvatarModel? _user;
  AvatarModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Ultimo errore da mostrare a schermo. Senza questo un fallimento della RPC
  // e' indistinguibile da un tap ignorato.
  String? _errore;
  String? get errore => _errore;
  void consumaErrore() => _errore = null;

  /// Carica profilo utente e sfide giornaliere dal database
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    try {
      // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
      _user = await repo.getAvatarInfo(idUtente: 1);
    } catch (e) {
      debugPrint('Errore caricamento dei dati: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Ricarica i dati dal DB senza mostrare lo spinner.
  /// Serve perché l'avatar può cambiare da altre schermate (es. l'exp guadagnata
  /// nel quiz): la pagina resta viva nell'IndexedStack e altrimenti mostrerebbe
  /// dati vecchi. Teniamo a video i valori attuali finché non arrivano i nuovi.
  Future<void> refresh() async {
    try {
      // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
      _user = await repo.getAvatarInfo(idUtente: 1);
      notifyListeners();
    } catch (e) {
      debugPrint('Errore aggiornamento dati avatar: $e');
    }
  }

  /// Aggiorna username di AvatarModel in uso
  Future<void> editName(String name) async {
    if (_user == null) return;

    try {
      _user = await repo.updateAvatarInfo(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        nomeAvatar: name,
        coloreAvatar: _user!.chosenColor,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Errore aggiornamento nome: $e');
    }
  }

  // Aggiorna colore scelto e sprite mascotte in uso
  Future<void> aggiornaColore(int new_color) async {
    if (_user == null) return;

    try {
      _user = await repo.updateAvatarInfo(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        nomeAvatar: _user!.username,
        coloreAvatar: new_color,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Errore aggiornamento colore: $e');
    }
  }

  // Setta come completato l'obiettivo challenge e agggiungi le sue exp all'utente
  Future<void> completaObiettivo(Obiettivo challenge) async {
    if (_user == null) return;

    // Applica exp ed eventuale level up in locale, così da inviare al backend i
    // totali già calcolati (livello, exp, monete) come richiesto dalla RPC.
    aggiornaExp(challenge.xpReward);

    try {
      _user = await repo.updateAvatarObiettivo(
        idUtente: 1,
        idObiettivo: challenge.id,
        livello: _user!.livello,
        exp: _user!.exp,
        monete: _user!.monete,
      );
      _errore = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Errore completamento obiettivo: $e');
      _errore = e.toString();
      // il calcolo locale non è stato persistito: riallineo con il DB
      await refresh();
    }
  }

  // Aggiunge expGuadagnata a _user e chiama il metodo di controllo di aumento di livello
  void aggiornaExp(int expGuadagnata) {
    if (_user == null || expGuadagnata <= 0) return;

    _user = _user!.copyWith(exp: _user!.exp + expGuadagnata);
    levelUp(); // notifica lui i listener
  }

  // Verifica se l'utente ha superato la soglia di lvl*10 con la sua exp, ed in caso affermativo
  // aumenta il livello, modula l'exp e dà 5 monete all'utente
  void levelUp() {
    if (_user == null) return;

    var aggiornato = _user!;

    // while e non if: una singola ricompensa può far salire più livelli insieme
    while (aggiornato.exp >= aggiornato.livello * _expPerLivello) {
      aggiornato = aggiornato.copyWith(
        livello: aggiornato.livello + 1,
        exp: aggiornato.exp - aggiornato.livello * _expPerLivello,
        monete: aggiornato.monete + _monetePerLevelUp,
      );
    }

    _user = aggiornato;
    notifyListeners();
  }

  // Gestisce l'aumento della streak corrente
  void aumentaStreak() {
    if (_user == null) return;

    _user = _user!.copyWith(streak: _user!.streak + 1);
    notifyListeners();
  }
}
