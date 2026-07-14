class UserModel {
  // TODO: GESTIONE SU SUPABASE
  int? userID;
  int? proteine;
  int? carboidrati;
  int? grassi;
  // calorie = proteine*4 + carboidrati*4 + grassi*9
  int? get calorie => (proteine ?? 0)*4 + (carboidrati ?? 0)*4 + (grassi ?? 0)*9;

  UserModel({
    this.proteine,
    this.carboidrati,
    this.grassi,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      proteine: (json['proteine'] as num).toInt(),
      carboidrati: (json['carboidrati'] as num).toInt(),
      grassi: (json['grassi'] as num).toInt(),
    );
  }
}



  



