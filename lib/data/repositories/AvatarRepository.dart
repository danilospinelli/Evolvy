import 'package:flutter_application_1/data/services/AvatarService.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';

//Dichiarato final perche non vogliamo in nessun modo che l'ogetto che comunica con internet possa essere modificato
//durante le operazioni o le query.

class AvatarRepository {
  late final AvatarService _avatarService;

  AvatarRepository(){
    this._avatarService=AvatarService();
  }

  //Funzione asincrona che prende dati dal service tramite l'id di un utente (nel nostro caso come "mock" nel codice come id utente = 1)
  // e le converte poi in un ogetto avatar model.
 
  Future<AvatarModel> getAvatarInfo({required int idUtente}) async {
    final avatarJson = await _avatarService.getAvatarInfoService(idUtente: idUtente,);
    return AvatarModel.fromJson(avatarJson);
  }

//I successivi metodi non restituiscono nessun ogetto ma la loro funzione è semplicemente quella di prendere dei parametri
//e aggiornare i rispettivi valori nel database.
//Infatti non è presente nessuna chiamata ai models ma lavora solo con i Service.

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

