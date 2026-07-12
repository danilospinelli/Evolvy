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
      _user = await repo.getAvatarInfo(id_utente: 1);
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
        id_utente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        nome_avatar: name,
        colore_avatar: _user!.chosen_color,
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
        id_utente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        nome_avatar: _user!.username,
        colore_avatar: new_color,
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
        id_utente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        id_obiettivo: challenge.id,
        livello: _user!.livello,
        exp: _user!.exp + challenge.xpReward,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Errore completamento obiettivo: $e');
    }
  }
}
