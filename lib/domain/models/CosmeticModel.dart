// TODO: DA ELIMINARE
class CosmeticModel {
  final int id;
  final String path;

  CosmeticModel({required this.id, required this.path});

  factory CosmeticModel.fromJson(Map<String, dynamic> json) {
    return CosmeticModel(
      id: json['id'] as int,
      path: json['path'] as String,
    );
  }

}

class CosmeticsListModel {
  final List<CosmeticModel> nonAcquistati;
  final List<CosmeticModel> acquistati;
  final CosmeticModel ? equipaggiato;

  CosmeticsListModel({
    required this.nonAcquistati,
    required this.acquistati,
    required this.equipaggiato,
  });

  factory CosmeticsListModel.fromJson(Map<String, dynamic> json) {
    return CosmeticsListModel(
      nonAcquistati: (json['non_acquistati'] as List<dynamic>)
          .map((item) => CosmeticModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      acquistati: (json['acquistati'] as List<dynamic>)
          .map((item) => CosmeticModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      equipaggiato: json['equipaggiato'] != null
          ? CosmeticModel.fromJson(json['equipaggiato'] as Map<String, dynamic>)
          : null,
    );
}
}