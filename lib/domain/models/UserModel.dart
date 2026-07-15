class UserModel {
  final int proteine;
  final int carboidrati;
  final int grassi;

  UserModel({
    required this.proteine,
    required this.carboidrati,
    required this.grassi,
  });

  // userId è hardcoded per ora
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      proteine: (json['proteine'] as num).toInt(),
      carboidrati: (json['carboidrati'] as num).toInt(),
      grassi: (json['grassi'] as num).toInt(),
    );
  }

  int get calorie => (proteine)*4 + (carboidrati)*4 + (grassi)*9;

  UserModel copyWith({
    int? proteine,
    int? carboidrati,
    int? grassi,
  }) {
    return UserModel(
      proteine: proteine ?? this.proteine,
      carboidrati: carboidrati ?? this.carboidrati,
      grassi: grassi ?? this.grassi,
    );
  }

}



  



