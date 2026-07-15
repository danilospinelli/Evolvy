class UserModel {
  final double proteine;
  final double carboidrati;
  final double grassi;

  UserModel({
    required this.proteine,
    required this.carboidrati,
    required this.grassi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      proteine: (json['proteine'] as num).toDouble(),
      carboidrati: (json['carboidrati'] as num).toDouble(),
      grassi: (json['grassi'] as num).toDouble(),
    );
  }

  double? get calorie => (proteine )*4 + (carboidrati )*4 + (grassi )*9;

  UserModel copyWith({
    double? proteine,
    double? carboidrati,
    double? grassi,
  }) {
    return UserModel(
      proteine: proteine ?? this.proteine,
      carboidrati: carboidrati ?? this.carboidrati,
      grassi: grassi ?? this.grassi,
    );
  }

}



  



