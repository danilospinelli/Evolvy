class Food {
  String? nome;
  double? kcalper100;
  double? protper100;
  double? carbper100;
  double? grasper100;
  double? sodper100;

  Food({
    this.nome,
    this.kcalper100,
    this.protper100,
    this.carbper100,
    this.grasper100,
    this.sodper100,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      nome: json['nome'] as String?,
      kcalper100: (json['kcalper100'] as num?)?.toDouble(),
      protper100: (json['protper100'] as num?)?.toDouble(),
      carbper100: (json['carbper100'] as num?)?.toDouble(),
      grasper100: (json['grasper100'] as num?)?.toDouble(),
      sodper100: (json['sodper100'] as num?)?.toDouble(),
    );
  }
}

class FoodList {
  List<Food> foods;

  FoodList({required this.foods});

  factory FoodList.fromJson(List<dynamic> json) {
    return FoodList(
      foods: json
          .map((item) => Food.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
