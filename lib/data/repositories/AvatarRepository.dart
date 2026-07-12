import 'package:flutter_application_1/data/services/AvatarService.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';


class AvatarRepository {
  late final AvatarService _avatarService;

  AvatarRepository(){
    this._avatarService=AvatarService();
  }

  Future<dynamic> getAvatarInfo({required int idUtente}) async {
    final avatarJson = await _avatarService.getAvatarInfoService(idUtente: idUtente,);
    return AvatarModel.fromJson(avatarJson);
  }

  Future<dynamic> updateAvatarInfo({required int idUtente, required String nomeAvatar, required int coloreAvatar}) async {
    final avatarJson = await _avatarService.updateAvatarInfoService(idUtente: idUtente, nomeAvatar: nomeAvatar, coloreAvatar: coloreAvatar);
    return AvatarModel.fromJson(avatarJson);
  }

  Future<dynamic> updateAvatarObiettivo({required int idUtente,required int idObiettivo,required int livello,required int exp}) async {
    final avatarJson = await _avatarService.updateAvatarObbietivoService(idUtente: idUtente, idObiettivo: idObiettivo, livello: livello, exp: exp);
    return AvatarModel.fromJson(avatarJson);
  }


}