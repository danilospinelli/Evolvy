import 'package:flutter/foundation.dart';

import '../../../data/repositories/FoodRepository.dart';
import '../../../domain/models/FoodModel.dart';

// Il ViewModel contiene i dati e la logica che la UI deve mostrare.
// Estende ChangeNotifier per poter avvisare la view quando i dati cambiano.
class Pagina1ViewModel extends ChangeNotifier {
	// Se non viene passato un repository dall'esterno, ne crea uno di default.
	Pagina1ViewModel({FoodRepository? repository})
			: _repository = repository ?? FoodRepository();

	// Repository privato: serve per leggere i dati dal livello data.
	final FoodRepository _repository;

	// Lista privata dei cibi caricati.
	List<FoodModel> _foods = [];
	String _query = '';

	// Getter pubblico: la view puo leggere i cibi, ma non modificarli direttamente.
	List<FoodModel> get foods => _foods;
	String get query => _query;

	// Lista filtrata in base al testo cercato.
	List<FoodModel> get filteredFoods {
		if (_query.isEmpty) {
			return _foods;
		}

		final normalizedQuery = _query.toLowerCase();
		return _foods
				.where((food) => food.name.toLowerCase().contains(normalizedQuery))
				.toList();
	}

	// Aggiorna il testo di ricerca e notifica la UI.
	void setQuery(String value) {
		_query = value;
		notifyListeners();
	}

	// Metodo async: carica i cibi e poi notifica la UI per fare il rebuild.
	Future<void> loadFoods() async {
		_foods = await _repository.getFoods();
		// Dice a Flutter/Provider che lo stato e cambiato.
		notifyListeners();
	}
}
