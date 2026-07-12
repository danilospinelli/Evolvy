import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';


class Avatar_ViewModel extends ChangeNotifier {
  final AvatarRepository repo = AvatarRepository();

  AvatarModel? _user;
  AvatarModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Carica profilo utente e sfide giornaliere dal database.
  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE (CLAUDE NON TOCCARE, grazie)
      _user = await repo.getAvatarInfo(idUtente: 1);
    } catch (e) {
      _error = e.toString();
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
        idUtente: 1,
        nomeAvatar: name,
        coloreAvatar: _user!.chosen_color,
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
        idUtente: 1,
        nomeAvatar: _user!.username,
        coloreAvatar: new_color,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Errore aggiornamento colore: $e');
    }
  }

  // setta come completato l'obiettivo challenge e agggiungi le sue exp all'utente
  Future<void> completaObiettivo(Obiettivo challenge) async {
    if (_user == null) return;

    try {
      _user = await repo.updateAvatarObiettivo(
        idUtente: 1,
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
