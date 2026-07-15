import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';

class Avatar_ViewModel extends ChangeNotifier {
  
  
  final AvatarRepository repo=AvatarRepository();

  static const int expPerLivello = 10;
  static const int monetePerLevelUp = 5;

  AvatarModel? _user;
  AvatarModel? get user => _user;

  // FLAG DI CARICAMENTO SPECIFICI
  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  bool _isUpdatingColor = false;
  bool get isUpdatingColor => _isUpdatingColor;

  bool _isUpdatingObjective = false;
  bool get isUpdatingObjective => _isUpdatingObjective;

  // Il getter generico ora controlla se c'è un caricamento bloccante iniziale
  bool get isLoading => _isLoadingProfile && _user == null;

  

  /// Carica profilo utente e sfide giornaliere dal database
  Future<void> initialize() async {
    _isLoadingProfile = true;
    notifyListeners();
    try {
      _user = await repo.getAvatarInfo(idUtente: 1);
    } catch (e) {
      debugPrint('Errore caricamento dei dati: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Aggiorna username di AvatarModel in uso
  Future<void> editName(String name) async {
    if (_user == null) return;

    _user = _user!.copyWith(username: name);
    notifyListeners();

    _isLoadingProfile = true;
    notifyListeners();
    try {
      await repo.updateNomeAvatar(
        idUtente: 1, 
        nomeAvatar: name,
      );
    } catch (e) {
      debugPrint('Errore aggiornamento nome: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Aggiorna colore scelto e sprite mascotte in uso
  Future<void> aggiornaColore(int new_color) async {
    if (_user == null) return;

    _user = _user!.copyWith(chosenColor: new_color);
    notifyListeners();

    _isUpdatingColor = true;
    notifyListeners();
    try {
      await repo.updateColoreAvatar(
        idUtente: 1, 
        coloreAvatar: new_color,
      );
    } catch (e) {
      debugPrint('Errore aggiornamento colore: $e');
    } finally {
      _isUpdatingColor = false;
      notifyListeners();
    }
  }


  //TODO verificare perche restituisce il livello gaudaganto spin lo sapevi?
  // Gestione dell'esperienza
  Future<int> aumentaExp(int expGuadagnata) async {
    if (_user == null || expGuadagnata <= 0) return 0;

    final precedente = _user!;
    int livelloIniziale = precedente.livello;

    int livello = precedente.livello;
    int exp = precedente.exp + expGuadagnata;
    int monete = precedente.monete;

    while (livello > 0 && exp >= livello * expPerLivello) {
      exp -= livello * expPerLivello;
      livello += 1;
      monete += monetePerLevelUp;
    }

    _user = precedente.copyWith(livello: livello, exp: exp, monete: monete);
    notifyListeners();

    _isLoadingProfile = true;
    notifyListeners();
    try {
      await repo.aggiornaDatiAvatar(
        idUtente: 1, 
        livello: livello,
        exp: exp,
        monete: monete,
      );
      return livello - livelloIniziale;
    } catch (e) {
      debugPrint('Errore aggiornamento exp: $e');
      _user = precedente;
      notifyListeners();
      return 0;
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Completa un obiettivo giornaliero
  Future<int> completaObiettivo(Obiettivo obiettivo) async {
    if (_user == null || obiettivo.completed) return 0;

    int nLivelli = await aumentaExp(obiettivo.xpReward);

    final obiettivi = List<Obiettivo>.of(_user!.obiettivi);
    final i = obiettivi.indexWhere((o) => o.id == obiettivo.id);
    obiettivi[i] = obiettivi[i].copyWith(completed: true);

    _user = _user!.copyWith(obiettivi: obiettivi);
    _isUpdatingObjective = true;
    notifyListeners();
    try {
      await repo.completaObiettivoAvatar(
        idUtente: 1, 
        idObiettivo: obiettivo.id,
      );
      return nLivelli;
    } catch (e) {
      debugPrint('Errore completamento obiettivo: $e');
      return 0;
    } finally {
      _isUpdatingObjective = false;
      notifyListeners();
    }
  }

  void aumentaStreak() {
    if (_user == null) return;
    _user = _user!.copyWith(streak: _user!.streak + 1);
    notifyListeners();
  }
}