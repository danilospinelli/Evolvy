import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';

class Mealbox_ViewModel {

  // This method returns an icon based on the meal type
  IconData getMealTypeIcon(MealTypes_Enum mealType) {
    switch (mealType) {
      case MealTypes_Enum.Colazione:
        return Icons.free_breakfast;
      case MealTypes_Enum.Pranzo:
        return Icons.lunch_dining;
      case MealTypes_Enum.Cena:
        return Icons.dinner_dining;
      case MealTypes_Enum.Altro:
        return Icons.fastfood;
    }
  }

  // Richiama la schermata per aggiungere un alimento al pasto
  void addFood() {
    // Da fare: implementare la logica per aprire la schermata di aggiunta alimento
  }

}
