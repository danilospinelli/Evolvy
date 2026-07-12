/*
import 'package:flutter_application_1/data/services/CosmeticsService.dart';
import 'package:flutter_application_1/domain/models/CosmeticModel.dart';



class CosmeticsRepository {
  late final CosmeticsService cosmetictservice;

  
  CosmeticsRepository(){
    this.cosmetictservice=CosmeticsService();
  }

  Future<dynamic> getCosmetics({required int id_utente}) async {
    final cosmeticsJson = await cosmetictservice.getCosmeticsService(
      id_utente: id_utente,
    );
    return CosmeticsListModel.fromJson(cosmeticsJson);

  }

  Future<dynamic> buyCosmetics({required int id_utente, required int id_cosmetico}) async {
    final cosmeticsJson = await cosmetictservice.buyCosmeticsService(
      id_utente: id_utente,
      id_cosmetico: id_cosmetico,
    );
    return CosmeticsListModel.fromJson(cosmeticsJson);
  }

  Future<dynamic> equipCosmetics({required int id_utente, required int id_cosmetico}) async {
    final cosmeticsJson = await cosmetictservice.equipCosmeticsService(
      id_utente: id_utente,
      id_cosmetico: id_cosmetico,
    );
    return CosmeticsListModel.fromJson(cosmeticsJson);
  }

}
*/