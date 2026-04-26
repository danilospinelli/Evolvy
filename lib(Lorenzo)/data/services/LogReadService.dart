import '../local/DatabaseEntryPoint.dart';

class LogReadService {
  String _today() => DateTime.now().toIso8601String().split('T').first;

  /// Recupera righe raw dalla tabella diario_alimentare, unendo i dati degli alimenti.
  Future<List<Map<String, dynamic>>> getTodayLogRows() async {
    final db = await AppDatabaseService.instance.database;

    return db.rawQuery(
      '''
			SELECT
				d.pasto AS pasto,
				d.quantita_grammi AS quantita_grammi,
				a.id AS alimento_id,
				a.nome AS alimento_nome,
				a.kcal AS kcal_100,
				a.proteine AS proteine_100,
				a.carboidrati AS carboidrati_100,
				a.grassi AS grassi_100
			FROM diario_alimentare d
			INNER JOIN alimenti a ON a.id = d.alimento_id
			WHERE d.data_log = ?
			ORDER BY d.id ASC
			''',
      [_today()],
    );
  }
}
