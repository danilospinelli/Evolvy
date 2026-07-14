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



  Future<void> updateNomeAvatar({required int idUtente, required String nomeAvatar}) async {
    await _avatarService.updateNomeAvatarService(idUtente: idUtente, nomeAvatar: nomeAvatar);
  }

  Future<void> updateColoreAvatar({required int idUtente, required int coloreAvatar}) async {
    await _avatarService.updateColoreAvatarService(idUtente: idUtente, coloreAvatar: coloreAvatar);
  }
  Future<void> completaObiettivoAvatar({required int idUtente,required int idObiettivo}) async {
      await _avatarService.completaObbietivoAvatarService(idUtente: idUtente, idObiettivo: idObiettivo);
  }

  Future<void> aggiornaDatiAvatar({required int idUtente, required int livello, required int exp, required int monete}) async {
    await _avatarService.aggiornaDatiAvatarService(idUtente: idUtente, livello: livello, exp: exp, monete: monete);
  }


}

