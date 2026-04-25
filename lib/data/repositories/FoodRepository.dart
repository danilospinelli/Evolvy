import '../model(dto)/FoodDto.dart';
import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

class FoodRepository {
  FoodRepository({FoodService? service}) : _service = service ?? FoodService();

  final FoodService _service;

  Future<List<FoodModel>> getFoods() async {
    final rawFoods = await _service.getFoods();
    return rawFoods.map((row) {
      final dto = FoodDto.fromDbRow(row);
      return FoodModel(
        id: dto.id,
        name: dto.name,
        kcal: dto.kcal,
        proteins: dto.proteins,
        carbs: dto.carbs,
        fats: dto.fats,
      );
    }).toList();
  }
}
