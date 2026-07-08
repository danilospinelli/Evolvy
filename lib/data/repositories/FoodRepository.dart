import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

class FoodRepository {
  late final FoodService foodService;

  FoodRepository(){
    this.foodService=FoodService();
  }

  //metodi che la repository espone al di fuori,
  Future<FoodList> getCibo(String nome_cibo) async {
    final FoodJson = await foodService.getCiboService(nome_cibo: nome_cibo);
    return FoodList.fromJson(FoodJson);
  }
}
