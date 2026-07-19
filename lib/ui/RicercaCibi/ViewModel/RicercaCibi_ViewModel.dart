import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/FoodRepository.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';

//ViewModel relativo alla pagina di ricerca cibi, quindi quella con la searchbar che ti restituisce i cibi dal database in base 
//ad una stringa messa dall'utente.

class RicercaCibi_ViewModel extends ChangeNotifier {
  final FoodRepository _foodRepository;

  RicercaCibi_ViewModel() : _foodRepository = FoodRepository();

  //Lista nullable se l'utente non cerca nulla e vuota se non restituisce risultati.
  List<FoodModel>? _risultati;
  var _isLoading = false;

  //Query dell'ultima ricerca lanciata: serve a scartare i risultati di una
  //ricerca superata, se ne parte un'altra mentre la prima sta ancora ritentando nel metodo eseguiconretry.
  String _ultimaQuery = '';

  List<FoodModel>? get risultati => _risultati;
  bool get isLoading => _isLoading;

  //salva i risultati della ricerca dei cibi in _risultati. Chiamata ogni volta che l'utente digita sulla 
  //barra di ricerca.
  Future<void> cercaCibi(String query) async {
    _isLoading = true;
    if (query.trim().isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    _ultimaQuery = query;
    notifyListeners();

    //Riprova finché la connessione al DB non si ristabilisce:
    //la rotella al posto della lista resta accesa per tutta la durata dei tentativi.
    final dati = await eseguiConRetry(() => _foodRepository.getCibo(query));

    //Se nel frattempo è partita un'altra ricerca, questi risultati sono superati:
    //li scarto e lascio comandare la ricerca più recente.
    if (_ultimaQuery != query) return;

    //Si arriva qui solo a ricerca riuscita.
    _risultati = dati;
    _isLoading = false;
    notifyListeners();
  }
}