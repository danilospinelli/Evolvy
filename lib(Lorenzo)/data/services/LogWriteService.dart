import '../local/DatabaseEntryPoint.dart';

class LogWriteService {
  static const Map<String, String> _mealKeyToLabel = {
    'breakfast': 'Colazione',
    'lunch': 'Pranzo',
    'dinner': 'Cena',
    'snack': 'Spuntino',
  };

  String _today() => DateTime.now().toIso8601String().split('T').first;

  /// Recupera righe raw dalla tabella alimenti.
  Future<void> logCiboNelDb({
    required int alimentoId,
    required double quantitaGrammi,
    required String pasto,
  }) async {
    final db = await AppDatabaseService.instance.database;
    await db.insert('diario_alimentare', {
      'alimento_id': alimentoId,
      'quantita_grammi': quantitaGrammi,
      'pasto': pasto,
      'data_log': _today(),
    });
  }

  // Salva il log completo nel database, sovrascrivendo eventuali dati esistenti per la data odierna.
  Future<void> saveLogDb(Map<String, dynamic> logDb) async {
    final db = await AppDatabaseService.instance.database;
    final meals = Map<String, dynamic>.from(
      logDb['meals'] as Map<String, dynamic>? ?? {},
    );

    await db.transaction((txn) async {
      await txn.delete(
        'diario_alimentare',
        where: 'data_log = ?',
        whereArgs: [_today()],
      );

      for (final entry in meals.entries) {
        final mealLabel = _mealKeyToLabel[entry.key];
        if (mealLabel == null) continue;

        final mealData = Map<String, dynamic>.from(entry.value as Map);
        final foods = mealData['foods'] as List<dynamic>? ?? const [];

        for (final rawFood in foods) {
          final food = Map<String, dynamic>.from(rawFood as Map);
          final alimentoId = int.tryParse((food['id'] ?? '').toString());
          if (alimentoId == null) continue;

          await txn.insert('diario_alimentare', {
            'alimento_id': alimentoId,
            'quantita_grammi': ((food['quantity'] as num?) ?? 0).toDouble(),
            'pasto': mealLabel,
            'data_log': _today(),
          });
        }
      }
    });
  }
}
