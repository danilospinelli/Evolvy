import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealType_Enum.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/domain/models/MacroType_Enum.dart';

class Homepage_ViewModel extends ChangeNotifier {
  final LogMealRepository repo = LogMealRepository();

  // Stato condiviso da più widget
  bool _isLoading = false;
  LogMeal logMeal = LogMeal(
    colazione: [],
    pranzo: [],
    cena: [],
    spuntino: [],
  );
  String _dailyTip = '⭐ Aggiungi il primo alimento del giorno!';

  bool get isLoading => _isLoading;
  // Restituisce una lista di LoggedFood con tutti i cibi caricati nel giorno corrente
  List<LoggedFood> get allFoods => [
        ...logMeal.colazione,
        ...logMeal.pranzo,
        ...logMeal.cena,
        ...logMeal.spuntino,
      ];
  String get dailyTip => _dailyTip;

  // Inizializza il LogMeal del giorno corrente caricandolo dalla repository
  // TODO: gestire la data dinamicamente: fai il metodo loadLogMealByDate che prende in input la data e lo chiami con la data di oggi
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      logMeal = await repo.getLogMealByDate(
        1,
        DateTime.parse('2026-04-28'),
      );
      updateDailyTip(allFoods);
    } catch (e) {
      debugPrint('Errore caricamento log pasti: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Restituisce una lista di LoggedFood in base al tipo di pasto del giorno corrente
  List<LoggedFood> foodsByMeal(MealType_Enum mealType) {
    switch (mealType) {
      case MealType_Enum.Colazione:
        return logMeal.colazione;
      case MealType_Enum.Pranzo:
        return logMeal.pranzo;
      case MealType_Enum.Cena:
        return logMeal.cena;
      case MealType_Enum.Spuntino:
        return logMeal.spuntino;
    }
  }

  // This method returns an icon based on the meal type
  IconData mealTypeIcon(MealType_Enum mealType) {
    switch (mealType) {
      case MealType_Enum.Colazione:
        return Icons.free_breakfast;
      case MealType_Enum.Pranzo:
        return Icons.lunch_dining;
      case MealType_Enum.Cena:
        return Icons.dinner_dining;
      case MealType_Enum.Spuntino:
        return Icons.fastfood;
    }
  }

  // Aggiunge un cibo al pasto specificato, aggiornando sia lo stato locale che la repository
  // TODO: gestire la data dinamicamente: fai il metodo loadLogMealByDate che prende in input la data e lo chiami con la data di oggi
  Future<void> addFood(
    MealType_Enum mealType,
    LoggedFood food,
  ) async {
    // Aggiorna la lista locale
    _addFoodToLocal(mealType, food);
    updateDailyTip(allFoods);
    notifyListeners();
    // Aggiorna il Database
    try {
      await repo.addCibo(
        id_utente: 1,
        data: DateTime.parse('2026-04-28'),
        meal: mealType.toString().split('.').last.toLowerCase(),
        nome_cibo: food.nome,
        quantita: food.quantita,
        calorie: food.calorie,
        carboidrati: food.carboidrati,
        proteine: food.proteine,
        grassi: food.grassi,
      );
    } catch (e) {
      // Rollback sulla lista locale se c'è un errore nel Database
      _removeFoodFromLocal(mealType, food);
      updateDailyTip(allFoods);
      notifyListeners();
      debugPrint('Errore aggiunta cibo: $e');
      rethrow;
    }
  }

  // Rimuove un cibo dal pasto specificato, aggiornando sia lo stato locale che la repository
  // TODO: gestire la data dinamicamente: fai il metodo loadLogMealByDate che prende in input la data e lo chiami con la data di oggi
  Future<void> removeFood({
    required MealType_Enum mealType,
    required LoggedFood food,
  }) async {
    // Aggiorna la lista locale
    _removeFoodFromLocal(mealType, food);
    updateDailyTip(allFoods);
    notifyListeners();
    // Aggiorna il Database
    try {
      await repo.removeCibo(
        id_utente: 1,
        data: DateTime.parse('2026-04-28'),
        meal: mealType.toString().split('.').last.toLowerCase(),
        nome_cibo: food.nome,
        quantita: food.quantita,
      );
    } catch (e) {
      // Rollback sulla lista locale se c'è un errore nel Database
      _addFoodToLocal(mealType, food);
      updateDailyTip(allFoods);
      notifyListeners();
      debugPrint('Errore rimozione cibo: $e');
      rethrow;
    }
  }

  // Rimuove un cibo solo dalla lista locale
  void _removeFoodFromLocal(MealType_Enum mealType, LoggedFood food) {
    foodsByMeal(mealType).remove(food);
  }

  // Aggiunge un cibo solo dalla lista locale
  void _addFoodToLocal(MealType_Enum mealType, LoggedFood food) {
    foodsByMeal(mealType).add(food);
  }

  // SEZIONE DAILYRECAP -----------------------------------------------------------------------------
  // TODO: non aggiorna le macro, usa notify

  // Restituisce la somma totale di un macro specifico (calorie, carboidrati, proteine o grassi) consumato nel giorno corrente
  double obtainedMacros(MacroType_Enum macro, List<LoggedFood> foods) {
    double result = foods.fold<double>(0.0, (sum, food) {
      switch (macro) {
        case MacroType_Enum.Calorie:
          return sum + food.calorie;
        case MacroType_Enum.Carboidrati:
          return sum + food.carboidrati;
        case MacroType_Enum.Proteine:
          return sum + food.proteine;
        case MacroType_Enum.Grassi:
          return sum + food.grassi;
      }
    });
    // Tronca il risultato a 1 decimale per una visualizzazione più pulita
    return double.parse(result.toStringAsFixed(1));
}

  // Ritorna i macro goal giornalieri
  // TODO: caricare i goal dall'oggetto del dominio User (preso da MainScreen_ViewAModel (?))
  double dailyMacroGoal(MacroType_Enum macro, List<LoggedFood> foods) {
    return 0.0;
  }

  // Aggiorna il daily tip in base ai macro consumati finora
  // TODO: migliorare la logica dei suggerimenti, magari con più condizioni e consigli più specifici
  void updateDailyTip(List<LoggedFood> foods) {
    final carbs = obtainedMacros(MacroType_Enum.Carboidrati, foods);
    final proteins = obtainedMacros(MacroType_Enum.Proteine, foods);
    final fats = obtainedMacros(MacroType_Enum.Grassi, foods);

    if (foods.isEmpty) {
      _dailyTip = '⭐ Aggiungi il primo alimento del giorno!';
    } else if (carbs > proteins && carbs > fats) {
      _dailyTip = '❌ Hai consumato più carboidrati; bilancia con proteine e grassi sani.';
    } else if (proteins > carbs && proteins > fats) {
      _dailyTip = '✅ Ottimo apporto proteico; assicurati di aggiungere anche carboidrati complessi.';
    } else if (fats > carbs && fats > proteins) {
      _dailyTip = '❌ Stai assumendo molti grassi; prova ad aumentare le proteine e i carboidrati.';
    } else {
      _dailyTip = '✅ Il tuo piano alimentare è equilibrato, continua così!';
    }
  }
}