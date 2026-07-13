import 'package:flutter_application_1/data/services/UserService.dart';
import 'package:flutter_application_1/domain/models/UserModel.dart';


class UserRepository {
  late final UserService _userService;

  UserRepository(){
    this._userService=UserService();
  }

  Future<dynamic> getUserInfo({required int idUtente}) async {
    final userJson = await _userService.getUserMacroService(idUtente: idUtente,);
    return UserModel.fromJson(userJson);
  }


}