import 'package:flutter_application_1/data/services/UserService.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';

//Dichiarato final perche non vogliamo in nessun modo che l'ogetto che comunica con internet possa essere modificato
//durante le operazioni o le query.

class UserRepository {
  late final UserService _userService;

  UserRepository(){
    this._userService=UserService();
  }

//Metodo perfettamente equivalente agli altri metodi della repository.
//Da un IdUtente restituisce uno UserModel caratterizzato dai Macro nutrienti dell'utente.
//Questo ci servirà per tutta la gestione degli obiettivi personali e fabbisogni.

  Future<UserModel> getUserMacro({required int idUtente}) async {
    final userJson = await _userService.getUserMacroService(idUtente: idUtente,);
    return UserModel.fromJson(userJson);
  }


}