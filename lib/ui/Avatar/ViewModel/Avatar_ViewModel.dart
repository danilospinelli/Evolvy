import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/AvatarRepository.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';

class Avatar_ViewModel extends ChangeNotifier {
  final AvatarRepository repo = AvatarRepository();

  // Moltiplicatore per livello epr decidere la solgia di exp necessaria per il prossimo livello
  static const int expPerLivello = 10;
  // Monete regalate ad ogni passaggio di livello
  static const int monetePerLevelUp = 5;

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


  // Aggiorna username di AvatarModel in uso
  Future<void> editName(String name) async {
    if (_user == null) return;

    // aggiorno subito lo stato locale: senza questo la UI ridisegna
    // gli stessi identici dati e a schermo non cambia niente
    _user = _user!.copyWith(username: name);
    notifyListeners();

    try {
      await repo.updateNomeAvatar(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        nomeAvatar: name,
      );
    } catch (e) {
      debugPrint('Errore aggiornamento nome: $e');
      notifyListeners();
    }
  }

  // Aggiorna colore scelto e sprite mascotte in uso
  Future<void> aggiornaColore(int new_color) async {
    if (_user == null) return;

    _user = _user!.copyWith(chosenColor: new_color);
    notifyListeners();

    try {
      await repo.updateColoreAvatar(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        coloreAvatar: new_color,
      );
    } catch (e) {
      debugPrint('Errore aggiornamento colore: $e');
      notifyListeners();
    }
  }

  // Aggiunge a _user l'exp guadagnata da una fonte qualsiasi (quiz, obiettivo, ...),
  // calcola quanti livelli sono stati superati, le monete guadagnate e l'exp residua
  // dal raggiungimento dell'ultimo livello, poi salva i nuovi totali sul db.
  Future<int> aumentaExp(int expGuadagnata) async {
    if (_user == null || expGuadagnata <= 0) return 0;

    // tengo lo stato precedente: se il salvataggio fallisce ci torno indietro
    final precedente = _user!;
    int livelloIniziale = precedente.livello;

    int livello = precedente.livello;
    int exp = precedente.exp + expGuadagnata;
    int monete = precedente.monete;

    // GESTIONE LIVELLO --------------------------------------------------------------------

    // while e non if: una singola ricompensa può far salire più livelli insieme.
    // livello > 0 evita il loop infinito se il db restituisse livello 0 (soglia 0).
    while (livello > 0 && exp >= livello * expPerLivello) {
      exp -= livello * expPerLivello;
      livello += 1;
      monete += monetePerLevelUp;
    }

    // mostro subito i nuovi valori, poi li persisto
    _user = precedente.copyWith(livello: livello, exp: exp, monete: monete);
    notifyListeners();

    try {
      await repo.aggiornaDatiAvatar(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        livello: livello,
        exp: exp,
        monete: monete,
      );
      return livello - livelloIniziale;
    } catch (e) {
      debugPrint('Errore aggiornamento exp: $e');
      // il calcolo locale non è stato persistito: torno ai valori precedenti
      _user = precedente;
      notifyListeners();
      return 0;
    }
  }



  // Completa un obiettivo giornaliero: prima accredita l'exp dell'obiettivo
  // (con eventuale level up e monete), poi lo segna come completato sul db.
  Future<int> completaObiettivo(Obiettivo obiettivo) async {
    if (_user == null || obiettivo.completed) return 0;

    int nLivelli = await aumentaExp(obiettivo.xpReward);

    final obiettivi = List<Obiettivo>.of(_user!.obiettivi);
    final i = obiettivi.indexWhere((o) => o.id == obiettivo.id);
    obiettivi[i] = obiettivi[i].copyWith(completed: true);

    _user = _user!.copyWith(obiettivi: obiettivi);
    notifyListeners();

    try {
      await repo.completaObiettivoAvatar(
        idUtente: 1, // TODO: GESTIRE DINAMICAMENTE L'ID UTENTE
        idObiettivo: obiettivo.id,
      );
      return nLivelli;
    } catch (e) {
      debugPrint('Errore completamento obiettivo: $e');
      notifyListeners();
      return 0;
    }
  }

  // Gestisce l'aumento della streak corrente
  // TODO: DARE UN SENSO A STREAK
  void aumentaStreak() {
    if (_user == null) return;

    _user = _user!.copyWith(streak: _user!.streak + 1);
    notifyListeners();
  }
}
