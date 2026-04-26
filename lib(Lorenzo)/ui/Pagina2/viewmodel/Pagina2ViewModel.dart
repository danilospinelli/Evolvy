import 'package:flutter/foundation.dart';

import '../../../domain/models/FoodModel.dart';
import '../../../domain/models/MealFoodSelectionModel.dart';

class Pagina2ViewModel extends ChangeNotifier {
  Pagina2ViewModel({required FoodModel food}) : _food = food;

  final FoodModel _food;
  static const int _minQuantity = 10;
  static const int _maxQuantity = 500;
  static const int _step = 10;
  int _quantityGrams = 100;

  FoodModel get food => _food;

  int get quantityGrams => _quantityGrams;
  int get minQuantity => _minQuantity;
  int get maxQuantity => _maxQuantity;
  int get step => _step;

  double get _multiplier => _quantityGrams / 100;

  int get kcal => (food.kcal * _multiplier).round();
  double get proteins => food.proteins * _multiplier;
  double get carbs => food.carbs * _multiplier;
  double get fats => food.fats * _multiplier;

  MealFoodSelectionModel buildSelection() {
    return MealFoodSelectionModel(
      food: food,
      quantityGrams: quantityGrams,
      kcal: kcal,
      proteins: proteins,
      carbs: carbs,
      fats: fats,
    );
  }

  void setQuantity(int value) {
    final normalized = value.clamp(_minQuantity, _maxQuantity);
    if (normalized == _quantityGrams) return;
    _quantityGrams = normalized;
    notifyListeners();
  }

  void increaseQuantity() {
    setQuantity(_quantityGrams + _step);
  }

  void decreaseQuantity() {
    setQuantity(_quantityGrams - _step);
  }
}
