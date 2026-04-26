class FoodDto {
  const FoodDto({
    required this.id,
    required this.name,
    required this.kcal,
    required this.proteins,
    required this.carbs,
    required this.fats,
  });

  final String id;
  final String name;
  final int kcal;
  final double proteins;
  final double carbs;
  final double fats;

  factory FoodDto.fromDbRow(Map<String, dynamic> row) {
    return FoodDto(
      id: ((row['id'] as num?) ?? 0).toInt().toString(),
      name: (row['nome'] ?? '').toString(),
      kcal: ((row['kcal'] as num?) ?? 0).round(),
      proteins: ((row['proteine'] as num?) ?? 0).toDouble(),
      carbs: ((row['carboidrati'] as num?) ?? 0).toDouble(),
      fats: ((row['grassi'] as num?) ?? 0).toDouble(),
    );
  }
}
