import 'package:flutter/foundation.dart';

//Questo metodo viene chiamato ogni volta che si deve eseguire una chiamata asincrona al database per ricevere dati e gestisce
//possibili errori di connessione non facendo sparire la rotella finchè non ci si riesce invece di dare errori.
//Usiamo le generics perchè può essere sia in lettura e quindi restituire void o restituire un ogetto specifico.
Future<T> eseguiConRetry<T>(
  //Operazione è l'azione che ha chiamato il metodo.
  Future<T> Function() operazione, {
  //L'attesa in termini di tempo
  Duration timeoutTentativo = const Duration(seconds: 5),
  Duration attesaTraTentativi = const Duration(seconds: 2),
}) async {
  while (true) {
    try {
      return await operazione().timeout(timeoutTentativo); //successo: esco dal loop
    } catch (e) {
      debugPrint(
        'Operazione fallita, ritento tra ${attesaTraTentativi.inSeconds}s: $e',
      );
      await Future.delayed(attesaTraTentativi);
    }
  }
}
