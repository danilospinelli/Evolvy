import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

class FoodRepository {
  late final FoodService _foodService;

  FoodRepository(){
    this._foodService=FoodService();
  }

  Future<List<FoodModel>> getCibo(String nomeCibo) async {
    final foodJson = await _foodService.getCiboService(nomeCibo: nomeCibo) as List;
    List<FoodModel> foodList = foodJson.map((json) => FoodModel.fromJson(json as Map<String, dynamic>)).toList();
    return foodList;
  }


}
