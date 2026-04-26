import 'FoodModel.dart';

class MealFoodSelectionModel {
  const MealFoodSelectionModel({
    required this.food,
    required this.quantityGrams,
    required this.kcal,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  final FoodModel food;
  final int quantityGrams;
  final int kcal;
  final double proteins;
  final double carbs;
  final double fats;
}
