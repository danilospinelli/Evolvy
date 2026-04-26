import 'package:flutter/material.dart';

import '../../../data/repositories/LogRepositories.dart';
import '../../../domain/models/FoodModel.dart';
import '../../../domain/models/LogModel.dart';
import '../../../domain/models/MealFoodSelectionModel.dart';
import '../../Pagina1/view/Pagina1View.dart';

class Pagina3View extends StatefulWidget {
  const Pagina3View({super.key});

  @override
  State<Pagina3View> createState() => _Pagina3ViewState();
}

class _Pagina3ViewState extends State<Pagina3View> {
  final LogRepositories _logRepository = LogRepositories();
  final Map<String, List<MealFoodSelectionModel>> _savedMeals = {
    'Colazione': [],
    'Pranzo': [],
    'Cena': [],
    'Spuntino': [],
  };
  bool _isLoading = true;
  String? _error;

  static const List<String> _mealLabels = [
    'Colazione',
    'Pranzo',
    'Cena',
    'Spuntino',
  ];

  static const Map<String, String> _mealLabelToKey = {
    'Colazione': 'breakfast',
    'Pranzo': 'lunch',
    'Cena': 'dinner',
    'Spuntino': 'snack',
  };

  @override
  void initState() {
    super.initState();
    _loadLog();
  }

  Future<void> _loadLog() async {
    try {
      final log = await _logRepository.getLog();
      final loadedMeals = {
        'Colazione': _extractMealSelections(log, 'Colazione'),
        'Pranzo': _extractMealSelections(log, 'Pranzo'),
        'Cena': _extractMealSelections(log, 'Cena'),
        'Spuntino': _extractMealSelections(log, 'Spuntino'),
      };

      if (!mounted) return;
      setState(() {
        _savedMeals
          ..clear()
          ..addAll(loadedMeals);
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Errore nel caricamento del log: $e';
      });
    }
  }

  List<MealFoodSelectionModel> _extractMealSelections(
    LogModel log,
    String mealLabel,
  ) {
    final mealKey = _mealLabelToKey[mealLabel];
    if (mealKey == null) return [];

    final meals = log.meals;
    final mealData = meals[mealKey];
    if (mealData is! Map) return [];

    final foods = mealData['foods'];
    if (foods is! List) return [];

    return foods.whereType<Map>().map((item) {
      final id = (item['id'] ?? '').toString();
      final name = (item['name'] ?? '').toString();
      final quantity = (item['quantity'] as num?)?.toInt() ?? 0;
      final kcal = ((item['kcal'] as num?) ?? 0).round();
      final proteins = (item['proteins'] as num?)?.toDouble() ?? 0.0;
      final carbs = (item['carbs'] as num?)?.toDouble() ?? 0.0;
      final fats = (item['fats'] as num?)?.toDouble() ?? 0.0;

      return MealFoodSelectionModel(
        food: FoodModel(
          id: id,
          name: name,
          kcal: kcal,
          proteins: proteins,
          carbs: carbs,
          fats: fats,
        ),
        quantityGrams: quantity,
        kcal: kcal,
        proteins: proteins,
        carbs: carbs,
        fats: fats,
      );
    }).toList();
  }

  Future<void> _persistMealsToLog() async {
    final mealsJson = <String, dynamic>{};

    for (final mealLabel in _mealLabels) {
      final mealKey = _mealLabelToKey[mealLabel]!;
      final foods = _savedMeals[mealLabel]!
          .map(
            (item) => {
              'id': item.food.id,
              'name': item.food.name,
              'quantity': item.quantityGrams,
              'unit': 'g',
              'kcal': item.kcal,
              'proteins': item.proteins,
              'carbs': item.carbs,
              'fats': item.fats,
            },
          )
          .toList();

      mealsJson[mealKey] = {
        'id': mealKey,
        'name': mealLabel,
        'order': _mealLabels.indexOf(mealLabel) + 1,
        'foods': foods,
      };
    }

    final dailyTotals = _calculateDailyTotals(_savedMeals);
    final log = LogModel(meals: mealsJson, dailyTotals: dailyTotals);
    await _logRepository.saveLog(log);
  }

  Map<String, dynamic> _calculateDailyTotals(
    Map<String, List<MealFoodSelectionModel>> meals,
  ) {
    double totalKcal = 0;
    double totalProteins = 0;
    double totalCarbs = 0;
    double totalFats = 0;

    for (final mealItems in meals.values) {
      for (final item in mealItems) {
        totalKcal += item.kcal;
        totalProteins += item.proteins;
        totalCarbs += item.carbs;
        totalFats += item.fats;
      }
    }

    return {
      'kcal': totalKcal,
      'proteins': totalProteins,
      'carbs': totalCarbs,
      'fats': totalFats,
    };
  }

  Future<void> _openSearchAndSave(String mealLabel) async {
    final selection = await Navigator.push<MealFoodSelectionModel>(
      context,
      MaterialPageRoute(
        builder: (_) => Pagina1View(targetMealLabel: mealLabel),
      ),
    );

    if (selection == null) return;

    setState(() {
      _savedMeals[mealLabel]!.add(selection);
    });

    await _persistMealsToLog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagina 3')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : ListView(
                children: _mealLabels
                    .map(
                      (label) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => _openSearchAndSave(label),
                                    child: const Text('Aggiungi cibo'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              if (_savedMeals[label]!.isEmpty)
                                const Text('Nessun alimento salvato')
                              else
                                ..._savedMeals[label]!.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      '${item.food.name} - ${item.quantityGrams} g | '
                                      '${item.kcal} kcal | '
                                      'P ${item.proteins.toStringAsFixed(1)} '
                                      'C ${item.carbs.toStringAsFixed(1)} '
                                      'F ${item.fats.toStringAsFixed(1)}',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}
