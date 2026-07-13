class UserModel {
  int? proteine;
  int? carboidrati;
  int? grassi;


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



  



