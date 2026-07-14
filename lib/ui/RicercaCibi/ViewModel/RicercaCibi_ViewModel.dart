import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/FoodRepository.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';

class RicercaCibi_ViewModel extends ChangeNotifier {
  
  final FoodRepository _foodRepository= FoodRepository();

  List<FoodModel>? _risultati;
  var _isLoading = false;

  List<FoodModel>? get risultati => _risultati;
  bool get isLoading => _isLoading;

  Future<void> cercaCibi(String query) async {
    _isLoading = true;
    if (query.trim().isEmpty) {
      return;
    }
    notifyListeners();

    try {
      final dati = await _foodRepository.getCibo(query);
      _risultati = dati;
    } catch (e) {
      print('Errore durante la ricerca dei cibi: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
