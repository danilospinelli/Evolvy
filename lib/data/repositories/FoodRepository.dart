import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

class FoodRepository {
  late final FoodService _foodService;

  FoodRepository(){
    this._foodService=FoodService();
  }

  Future<List<FoodModel>> getCibo(String nomeCibo) async {
    final foodJson = await _foodService.getCiboService(nomeCibo: nomeCibo);
    List<FoodModel> foodList=foodJson.map((json) => FoodModel.fromJson(json)).toList();
    return foodList;
  }
}
