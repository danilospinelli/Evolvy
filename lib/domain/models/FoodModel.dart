class FoodModel {
  String? nome;
  double? kcalper100;
  double? protper100;
  double? carbper100;
  double? grasper100;
  double? sodper100;

  FoodModel({
    this.nome,
    this.kcalper100,
    this.protper100,
    this.carbper100,
    this.grasper100,
    this.sodper100,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      nome: json['nome'] as String?,
      kcalper100: (json['kcalper100'] as num?)?.toDouble(),
      protper100: (json['protper100'] as num?)?.toDouble(),
      carbper100: (json['carbper100'] as num?)?.toDouble(),
      grasper100: (json['grasper100'] as num?)?.toDouble(),
      sodper100: (json['sodper100'] as num?)?.toDouble(),
    );
  }
}


