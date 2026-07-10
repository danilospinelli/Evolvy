import 'package:flutter_application_1/data/services/AvatarService.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';


class AvatarRepository {
  late final AvatarService avatarService;

  AvatarRepository(){
    this.avatarService=AvatarService();
  }

  Future<dynamic> getAvatarInfo({required int id_utente}) async {
    final avatarJson = await avatarService.getAvatarInfoService(id_utente: id_utente,);
    return AvatarModel.fromJson(avatarJson);
  }

  Future<dynamic> updateAvatarInfo({required int id_utente, required String nome_avatar, required int colore_avatar}) async {
    final avatarJson = await avatarService.updateAvatarInfoService(id_utente: id_utente, nome_avatar: nome_avatar, colore_avatar: colore_avatar);
    return AvatarModel.fromJson(avatarJson);
  }

  Future<dynamic> updateAvatarObiettivo({required int id_utente,required String id_obiettivo,required int livello,required int exp}) async {
    final avatarJson = await avatarService.updateAvatarObbietivoService(id_utente: id_utente, id_obiettivo: id_obiettivo, livello: livello, exp: exp);
    return AvatarModel.fromJson(avatarJson);
  }


}