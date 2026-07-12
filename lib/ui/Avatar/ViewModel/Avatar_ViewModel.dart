import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';

class Avatar_ViewModel extends ChangeNotifier {
  final AvatarRepository repo = AvatarRepository();

  AvatarModel? _user;
  AvatarModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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

    try {
      _user = await repo.updateAvatarObiettivo(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        idObiettivo: challenge.id,
        livello: _user!.livello,
        exp: _user!.exp + challenge.xpReward,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Errore completamento obiettivo: $e');
    }
  }

  // Aggiunge expGuadagnata a _user e chiama il metodo di controllo di aumento di livello 
  Future<void> aggiornaExp(int expGuadagnata){

  }

  // Verifica se l'utente ha superato la soglia di lvl*10 con la sua exp, ed in caso affermativo
  // aumenta il livello, modula l'exp e dà 5 monete all'utente
  Future<void> levelUp(){

  }

  // Gestisce l'aumento della streak corrente
  Future<void> aumentaStreak(){

  }
}
