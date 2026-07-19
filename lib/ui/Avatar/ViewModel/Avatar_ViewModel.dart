import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';

//ViewModel dedicato alla gestione della pagina dell'avatar e uno dei 2 file principali
//a contenere logiche di gamification dell'applicazione.

class Avatar_ViewModel extends ChangeNotifier {
  
  final AvatarRepository repo;

  Avatar_ViewModel(this.repo);

  //Costanti di bilanciamento di levelup e ottenimento monete.
  static const int expPerLivello = 10;
  static const int monetePerLevelUp = 5;


  AvatarModel? _user;
  AvatarModel? get user => _user;

  //FLAG DI CARICAMENTO SPECIFICI. Verrà caricata quindi solo quella sezione della pagina
  //e non tutta intera da capo.
  bool _isLoadingProfile = false;
  bool get isLoadingProfile => _isLoadingProfile;

  bool _isUpdatingColor = false;
  bool get isUpdatingColor => _isUpdatingColor;

  bool _isUpdatingObjective = false;
  bool get isUpdatingObjective => _isUpdatingObjective;

  bool _isUpdatingName = false;
  bool get isUpdatingName => _isUpdatingName;

  //Carica profilo utente e sfide giornaliere dal database.
  Future<void> initialize() async {
    _isLoadingProfile = true;
    notifyListeners();

    //Riprova finché la connessione al DB non si ristabilisce: la rotella a
    //schermo intero (mostrata finché user == null) resta accesa per tutta la durata.
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

    //Riprova finché la connessione al DB non si ristabilisce:
    //la rotella sul solo nome resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repo.updateNomeAvatar(idUtente: 1, nomeAvatar: name);
    });

    // Si arriva qui solo a operazione riuscita.
    //Sfruttiamo il pattern definito con copywith forzando l'aggiornamento aggiornando solo il nome.
    _user = _user!.copyWith(username: name);
    _isUpdatingName = false;
    notifyListeners();
  }

  // Aggiorna colore scelto per l'avatar, esattamente come il nome.
  Future<void> aggiornaColore(int new_color) async {
    if (_user == null) return;

    _isUpdatingColor = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella (isUpdatingColor) resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repo.updateColoreAvatar(idUtente: 1, coloreAvatar: new_color);
    });

    // Si arriva qui solo a operazione riuscita.
    //Sfruttiamo il pattern definito con copywith forzando l'aggiornamento aggiornando solo il nome.
    _user = _user!.copyWith(chosenColor: new_color);
    _isUpdatingColor = false;
    notifyListeners();
  }

  //Metodo che gestisce il calcolo dell aumento di XP e LevelUp data una certa xp "expGuadagnata".
  Future<int> aumentaExp(int expGuadagnata) async {
    if (_user == null || expGuadagnata <= 0) return 0;

    //Salviamo alcuni dati che ci serviranno dopo come il delta livelli.
    final precedente = _user!;
    int livelloIniziale = precedente.livello;

    int livello = precedente.livello;
    int exp = precedente.exp + expGuadagnata;
    int monete = precedente.monete;

    //Gestisce la logica del LevelUp. Finchè ci sono XP da distribuire il while non si ferma e puoi fare più levelUp.
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
    //Copywith come prima.
    _user = precedente.copyWith(livello: livello, exp: exp, monete: monete);
    notifyListeners();

    //Ritorniamo la differenza di livelli che ci è utile per mostrare quanti livelli ha fatto l'utente.
    return livello - livelloIniziale;
  }


  //Gestisce il completamento di un certo Obiettivo giornaliero "obiettivo".
  Future<int> completaObiettivo(Obiettivo obiettivo) async {
    if (_user == null || obiettivo.completed) return 0;

    // Accendo SUBITO la rotella sulla sezione obiettivi: resta lì per tutta
    // l'operazione (aggiornamento exp + completamento), senza toccare l'header.
    _isUpdatingObjective = true;
    notifyListeners();

    //Se lo completo avrò certi xp guadagnati, li passo al metodo sopra.
    int nLivelli = await aumentaExp(obiettivo.xpReward);

    // Riprova finché la connessione al DB non si ristabilisce:
    // lo spinner degli obiettivi (isUpdatingObjective) resta acceso per tutta la durata.
    await eseguiConRetry(() async {
      await repo.completaObiettivoAvatar(
        idUtente: 1,
        idObiettivo: obiettivo.id,
      );
    });

    //Aggiornamento della lista obiettivi. Prendo quella che avevo già, vedo quale ho completato e tramite
    //CopyWith restituisco un nuovo ogetto con il flag completed a true.
    final obiettivi = List<Obiettivo>.of(_user!.obiettivi);
    final i = obiettivi.indexWhere((o) => o.id == obiettivo.id);
    obiettivi[i] = obiettivi[i].copyWith(completed: true);
    _user = _user!.copyWith(obiettivi: obiettivi);
    _isUpdatingObjective = false;
    notifyListeners();
    return nLivelli;
  }
}
