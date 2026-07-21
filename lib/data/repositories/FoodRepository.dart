import '../services/FoodService.dart';
import '../../domain/models/FoodModel.dart';

//Dichiarato final perche non vogliamo in nessun modo che l'ogetto che comunica con internet possa essere modificato
//durante le operazioni o le query.

//Questa classe è relativa ai cibi non legati all'utente. Per quello c'è LogMeal.

class FoodRepository {
  final FoodService _foodService=FoodService();



//Questo metodo non passa un singolo JSON al model ma da un cibo, una query restituisce una lista di risultati.
//Restituendoci una lista usiamo il metodo map per ciclare su ogni JSON presente nella lista, trasformandolo in un oggetto Map e poi
//successivamente in una lista unica compatta alla fine.

  Future<List<FoodModel>> getCibo(String nomeCibo) async {
    final foodJson = await _foodService.getCiboService(nomeCibo: nomeCibo) as List;
    List<FoodModel> foodList = foodJson.map((json) => FoodModel.fromJson(json as Map<String, dynamic>)).toList();
    return foodList;
  }


}
