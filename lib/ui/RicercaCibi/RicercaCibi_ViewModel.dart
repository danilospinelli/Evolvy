import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/FoodRepository.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';

class RicercaViewModel extends ChangeNotifier {
  final Foodrepository _foodRepository;
  RicercaViewModel() : _foodRepository = Foodrepository();

  FoodList? _risultati;
  var _isLoading = false;

  FoodList? get risultati => _risultati;
  bool get isLoading => _isLoading;

  Future<void> cercaCibi(String query) async {
    _isLoading = true;
    if (query.trim().isEmpty) {
      return;
    }
    notifyListeners();

    try {
      final dati = await _foodRepository.getFoods(query);
      _risultati = dati;
    } catch (e) {
      print('Errore durante la ricerca dei cibi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
