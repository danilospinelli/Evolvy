import '../local/DatabaseEntryPoint.dart';

class FoodService {
  /// Recupera righe raw dalla tabella alimenti.
  Future<List<Map<String, dynamic>>> getFoods() async {
    final db = await AppDatabaseService.instance.database;
    return db.query('alimenti', orderBy: 'id ASC');
  }
}
