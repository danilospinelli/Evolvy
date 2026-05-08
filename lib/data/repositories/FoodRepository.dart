import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

class FoodRepository {
  FoodRepository({FoodService? foodService})
    : _foodService = foodService ?? FoodService();

  final FoodService _foodService;

  //metodi che la repository espone al di fuori,
  Future<FoodList> getFoods(String nome_cibo) async {
    final FoodJson = await _foodService.getCiboService(nome_cibo: nome_cibo);
    return FoodList.fromJson(FoodJson);
  }
}
