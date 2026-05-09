import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';

class Mealbox_ViewModel {
  final LogMealRepository repo = LogMealRepository();

  Future<List<LoggedFood>> getFoodsByMeal(MealTypes_Enum mealType) async {
    LogMeal log = await repo.getLogMealByDate(1, DateTime.parse('2026-04-28')); // UN MODO PER PRENDERE L'ID DELL'UTENTE LOGGATO
    switch (mealType) {
      case MealTypes_Enum.Colazione:
        return log.colazione;
      case MealTypes_Enum.Pranzo:
        return log.pranzo;
      case MealTypes_Enum.Cena:
        return log.cena;
      case MealTypes_Enum.Altro:
        return log.spuntino;
    }
  }

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
}

class InsertedFood_ViewModel {
  final LogMealRepository repo = LogMealRepository();

  // Rimuove un cibo dal pasto specificato
  Future<void> removeFoodFromMeal({
    required MealTypes_Enum mealtype,
    required LoggedFood food,
  }) async {
    await repo.removeCibo(
      id_utente: 1, // UN MODO PER PRENDERE L'ID DELL'UTENTE LOGGATO
      data: DateTime.parse('2026-04-28'), // DA ELIMINARE LA DATA, NON SO QUANDO è STATO CARICATO QUEL CIBO
      meal: mealtype.toString().split('.').last.toLowerCase(),
      nome_cibo: food.nome,
      quantita: food.quantita,
    );
  }
}