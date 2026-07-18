import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';

class Avatar_ViewModel extends ChangeNotifier {
  
  final AvatarRepository repo;

  Avatar_ViewModel(this.repo);

  static const int expPerLivello = 10;
  static const int monetePerLevelUp = 5;

  AvatarModel? _user;
  AvatarModel? get user => _user;

  // Flag di caricamento per elementi diversi
  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  bool _isUpdatingColor = false;
  bool get isUpdatingColor => _isUpdatingColor;

  bool _isUpdatingObjective = false;
  bool get isUpdatingObjective => _isUpdatingObjective;

  bool _isUpdatingName = false;
  bool get isUpdatingName => _isUpdatingName;


  //Carica profilo utente e sfide giornaliere dal database
  Future<void> initialize() async {
    _isLoadingProfile = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce: la rotella a
    // schermo intero (mostrata finché user == null) resta accesa per tutta la durata.
    _user = await eseguiConRetry(() => repo.getAvatarInfo(idUtente: 1));

    // Si arriva qui solo a caricamento riuscito.
    _isLoadingProfile = false;
    notifyListeners();
  }

  //Aggiorna username di AvatarModel in uso
  Future<void> editName(String name) async {
    if (_user == null) return;

    _isUpdatingName = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella sul solo nome resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repo.updateNomeAvatar(
        idUtente: 1,
        nomeAvatar: name,
      );
    });

    // Si arriva qui solo a operazione riuscita.
    _user = _user!.copyWith(username: name);
    _isUpdatingName = false;
    notifyListeners();
  }

  // Aggiorna colore scelto per l'avatar
  Future<void> aggiornaColore(int new_color) async {
    if (_user == null) return;

    _isUpdatingColor = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella (isUpdatingColor) resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repo.updateColoreAvatar(
        idUtente: 1,
        coloreAvatar: new_color,
      );
    });

    // Si arriva qui solo a operazione riuscita.
    _user = _user!.copyWith(chosenColor: new_color);
    _isUpdatingColor = false;
    notifyListeners();
  }

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

    // Nessuno spinner qui: se chiamata da completaObiettivo la rotella è quella
    // della sezione obiettivi; dal quiz il feedback è gestito dalla QuizPage.
    // Riprova finché la connessione al DB non si ristabilisce.
    await eseguiConRetry(() async {
      await repo.aggiornaDatiAvatar(
        idUtente: 1,
        livello: livello,
        exp: exp,
        monete: monete,
      );
    });

    // Si arriva qui solo a operazione riuscita.
    _user = precedente.copyWith(livello: livello, exp: exp, monete: monete);
    notifyListeners();
    return livello - livelloIniziale;
  }

  //Completa un obiettivo giornaliero
  Future<int> completaObiettivo(Obiettivo obiettivo) async {
    if (_user == null || obiettivo.completed) return 0;

    // Accendo SUBITO la rotella sulla sezione obiettivi: resta lì per tutta
    // l'operazione (aggiornamento exp + completamento), senza toccare l'header.
    _isUpdatingObjective = true;
    notifyListeners();

    int nLivelli = await aumentaExp(obiettivo.xpReward);

    // Riprova finché la connessione al DB non si ristabilisce:
    // lo spinner degli obiettivi (isUpdatingObjective) resta acceso per tutta la durata.
    await eseguiConRetry(() async {
      await repo.completaObiettivoAvatar(
        idUtente: 1,
        idObiettivo: obiettivo.id,
      );
    });

    // Marco l'obiettivo solo a scrittura riuscita.
    final obiettivi = List<Obiettivo>.of(_user!.obiettivi);
    final i = obiettivi.indexWhere((o) => o.id == obiettivo.id);
    obiettivi[i] = obiettivi[i].copyWith(completed: true);
    _user = _user!.copyWith(obiettivi: obiettivi);
    _isUpdatingObjective = false;
    notifyListeners();
    return nLivelli;
  }
}