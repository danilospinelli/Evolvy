import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';


class Avatar_ViewModel extends ChangeNotifier {
  final AvatarRepository repo = AvatarRepository();

  AvatarModel? _user;
  AvatarModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Carica profilo utente e sfide giornaliere dal database.
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE (CLAUDE NON TOCCARE, grazie)
      _user = await repo.getAvatarInfo(id_utente: 1);
    } catch (e) {
      debugPrint('Errore caricamento dei dati: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Aggiorna username di AvatarModel in uso
  void editName(String name) {

  }

  // Aggiorna colore scelto e sprite mascotte in uso
  // TODO: TROVARE UN MODO PER SETTARE LO SPRITE DELLA MASCOTTE IN USO, MAGARI COME VARIABILE INSIEME ALLO USER
  void aggiornaColore(int new_color){

  }

  // setta come completato l'obiettivo challenge e agggiungi le sue exp all'utente
  void completaObiettivo(Obiettivo challenge){

  }
}
