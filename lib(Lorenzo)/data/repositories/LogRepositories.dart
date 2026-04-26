import '../../domain/models/LogModel.dart';

class LogRepositories {
  Future<LogModel> getLog() async {
    // TODO: Implementare il caricamento del log
    // Potrebbe leggere da database locale, SharedPreferences, o un file
    return LogModel(
      meals: {},
      dailyTotals: {
        'kcal': 0,
        'proteins': 0,
        'carbs': 0,
        'fats': 0,
      },
    );
  }

  Future<void> saveLog(LogModel log) async {
    // TODO: Implementare il salvataggio del log
    // Potrebbe salvare in database locale, SharedPreferences, o un file
  }
}

