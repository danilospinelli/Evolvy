import 'package:openfoodfacts/openfoodfacts.dart';
import '../services/OpenFoodFactorService.dart';

class FoodRepository {
  FoodRepository({OpenFoodFactorService? foodService})
    : foodService = foodService ?? OpenFoodFactorService();

  final OpenFoodFactorService foodService;

  //metodi che la repository espone al di fuori

  Future<List<Product>> getFoodsbyName(String cibo) async {
    final foods = await foodService.searchByNome(cibo);
    return foods;
  }

  Future<List<Product>> getFoodsbyBarCode(String barcode) async {
    final foods = await foodService.searchByCodiceBarre(barcode);
    return foods;
  }
}
