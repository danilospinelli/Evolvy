import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/data/repositories/LogMealRepository.dart';
import 'package:flutter_application_1/data/repositories/UserRepository.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/ui/core/utils/RetryConnessione.dart';

class Homepage_ViewModel extends ChangeNotifier {
  final LogMealRepository repoLogMeal = LogMealRepository();
  final UserRepository repoUser = UserRepository();

  // Stato condiviso da più widget
  bool _isLoading = false;
  LogMealModel logMeal = LogMealModel(
    colazione: [],
    pranzo: [],
    cena: [],
    spuntino: [],
  );
  UserModel? _user;
  
  String _dailyTip = '⭐ Aggiungi il primo alimento del giorno!';

  bool get isLoading => _isLoading || _user == null;

  // Operazione su un cibo in corso: la guardano SOLO i box in alto
  // (macro, calorie, suggerimenti). La lista dei pasti resta invariata.
  bool _isUpdatingFood = false;
  bool get isUpdatingFood => _isUpdatingFood;
  // Restituisce una lista di LoggedFood con tutti i cibi caricati nel giorno corrente
  List<LoggedFood> get allFoods => [
        ...logMeal.colazione,
        ...logMeal.pranzo,
        ...logMeal.cena,
        ...logMeal.spuntino,
      ];
  String get dailyTip => _dailyTip;

  //Inizializza il LogMeal del giorno corrente caricandolo dalla repository
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce. Due blocchi
    // separati, così un fallimento sul secondo non fa ri-scaricare anche il primo.
    logMeal = await eseguiConRetry(
      () => repoLogMeal.getPastiGiornalieri(
        1,
        DateTime.parse('2026-04-28'),
      ),
    );
    updateDailyTip(allFoods);
    _user = await eseguiConRetry(() => repoUser.getUserMacro(idUtente: 1));

    // Si arriva qui solo a caricamento riuscito.
    _isLoading = false;
    notifyListeners();
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

  // Aggiunge un cibo al pasto specificato: prima il Database, poi lo stato locale.
  // La lista locale viene toccata solo a scrittura riuscita, così non può divergere dal db.
  Future<void> addFood(
    MealType_Enum mealType,
    LoggedFood food,
  ) async {
    _isUpdatingFood = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella al posto del tasto OK resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repoLogMeal.addCibo(
        idUtente: 1,
        data: DateTime.parse('2026-04-28'),
        meal: mealType.toString().split('.').last.toLowerCase(),
        nomeCibo: food.nome,
        quantita: food.quantita,
        calorie: food.calorie,
        carboidrati: food.carboidrati,
        proteine: food.proteine,
        grassi: food.grassi,
      );
    });

    // Si arriva qui solo a inserimento riuscito.
    _addFoodToLocal(mealType, food);
    updateDailyTip(allFoods);
    _isUpdatingFood = false;
    notifyListeners();
  }

  // Rimuove un cibo dal pasto specificato: prima il Database, poi lo stato locale.
  Future<void> removeFood({
    required MealType_Enum mealType,
    required LoggedFood food,
  }) async {
    _isUpdatingFood = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // le rotelle nei box in alto restano accese per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repoLogMeal.removeCibo(
        idUtente: 1,
        data: DateTime.parse('2026-04-28'),
        meal: mealType.toString().split('.').last.toLowerCase(),
        nomeCibo: food.nome,
        quantita: food.quantita,
      );
    });

    // Si arriva qui solo a rimozione riuscita.
    _removeFoodFromLocal(mealType, food);
    updateDailyTip(allFoods);
    _isUpdatingFood = false;
    notifyListeners();
  }
  
  // Aggiorna un cibo già loggato con nuovi valori: prima il Database, poi lo stato locale.
  Future<void> updateFood(
    MealType_Enum mealType,
    LoggedFood oldFood,
    LoggedFood newFood,
  ) async {
    _isUpdatingFood = true;
    notifyListeners();

    // Riprova finché la connessione al DB non si ristabilisce:
    // la rotella al posto del tasto OK resta accesa per tutta la durata dei tentativi.
    await eseguiConRetry(() async {
      await repoLogMeal.updateCibo(
        idUtente: 1,
        data: DateTime.parse('2026-04-28'),
        meal: mealType.toString().split('.').last.toLowerCase(),
        nomeCibo: newFood.nome,
        quantita: newFood.quantita,
        calorie: newFood.calorie,
        carboidrati: newFood.carboidrati,
        proteine: newFood.proteine,
        grassi: newFood.grassi,
      );
    });

    // Si arriva qui solo ad aggiornamento riuscito.
    _updateFoodInLocal(mealType, oldFood, newFood);
    updateDailyTip(allFoods);
    _isUpdatingFood = false;
    notifyListeners();
  }

  // Ricostruisce i valori nutrizionali per 100g partendo da un cibo loggato.
  // Pura logica matematica isolata dal contesto grafico.
  FoodModel resetValori(LoggedFood food) {
    // Se la quantità è nulla, assumiamo 100g di base
    final moltiplicatore = (food.quantita) / 100;
    
    return FoodModel(
      nome: food.nome,
      kcalper100: (food.calorie) / moltiplicatore,
      carbper100: (food.carboidrati) / moltiplicatore,
      protper100: (food.proteine) / moltiplicatore,
      grasper100: (food.grassi) / moltiplicatore,
    );
  }

  // Rimuove un cibo solo dalla lista locale
  void _removeFoodFromLocal(MealType_Enum mealType, LoggedFood food) {
    foodsByMeal(mealType).remove(food);
  }

  // Aggiunge un cibo solo dalla lista locale
  void _addFoodToLocal(MealType_Enum mealType, LoggedFood food) {
    foodsByMeal(mealType).add(food);
  }

  // Sostituisce un cibo con uno aggiornato solo nella lista locale, mantenendone la posizione
  void _updateFoodInLocal(
    MealType_Enum mealType,
    LoggedFood oldFood,
    LoggedFood newFood,
  ) {
    final foods = foodsByMeal(mealType);
    final index = foods.indexOf(oldFood);
    if (index != -1) {
      foods[index] = newFood;
    }
  }

  
  
  // SEZIONE DAILYRECAP -----------------------------------------------------------------------------

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
  double dailyMacroGoal(MacroType_Enum macro) {
    switch(macro) {
      case MacroType_Enum.Calorie:
        return (_user?.calorie ?? 0).toDouble();
      case MacroType_Enum.Carboidrati:
        return (_user?.carboidrati ?? 0).toDouble();
      case MacroType_Enum.Proteine:
        return (_user?.proteine ?? 0).toDouble();
      case MacroType_Enum.Grassi:
        return (_user?.grassi ?? 0).toDouble();
    }
  }

  // Aggiorna il daily tip in base ai macro consumati finora
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