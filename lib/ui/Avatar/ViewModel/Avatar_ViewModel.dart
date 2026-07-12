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
}
