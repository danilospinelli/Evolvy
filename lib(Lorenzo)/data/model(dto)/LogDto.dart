class LogRowDto {
  const LogRowDto({
    required this.pasto,
    required this.alimentoId,
    required this.alimentoNome,
    required this.quantitaGrammi,
    required this.kcal100,
    required this.proteine100,
    required this.carboidrati100,
    required this.grassi100,
  });

  final String pasto;
  final int alimentoId;
  final String alimentoNome;
  final double quantitaGrammi;
  final double kcal100;
  final double proteine100;
  final double carboidrati100;
  final double grassi100;

  factory LogRowDto.fromDbRow(Map<String, dynamic> row) {
    return LogRowDto(
      pasto: (row['pasto'] ?? '').toString(),
      alimentoId: ((row['alimento_id'] as num?) ?? 0).toInt(),
      alimentoNome: (row['alimento_nome'] ?? '').toString(),
      quantitaGrammi: ((row['quantita_grammi'] as num?) ?? 0).toDouble(),
      kcal100: ((row['kcal_100'] as num?) ?? 0).toDouble(),
      proteine100: ((row['proteine_100'] as num?) ?? 0).toDouble(),
      carboidrati100: ((row['carboidrati_100'] as num?) ?? 0).toDouble(),
      grassi100: ((row['grassi_100'] as num?) ?? 0).toDouble(),
    );
  }

  double get _factor => quantitaGrammi / 100;
  double get kcal => kcal100 * _factor;
  double get proteine => proteine100 * _factor;
  double get carboidrati => carboidrati100 * _factor;
  double get grassi => grassi100 * _factor;

  Map<String, dynamic> toMealFoodJson() {
    return {
      'id': alimentoId.toString(),
      'name': alimentoNome,
      'quantity': quantitaGrammi.round(),
      'unit': 'g',
      'kcal': kcal,
      'proteins': proteine,
      'carbs': carboidrati,
      'fats': grassi,
    };
  }
}
