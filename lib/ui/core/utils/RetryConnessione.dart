import 'package:flutter/foundation.dart';

/// Esegue [operazione] e, se fallisce (es. nessuna connessione al DB),
/// riprova all'infinito finché non va a buon fine.
///
/// - [timeoutTentativo]: se una singola chiamata resta "appesa" oltre questo
///   tempo, viene considerata fallita e si ritenta. Serve a evitare l'attesa
///   infinita sul singolo tentativo quando la rete non risponde affatto.
/// - [attesaTraTentativi]: pausa tra un tentativo fallito e il successivo.
///
/// Il Future ritorna SOLO quando l'operazione riesce: chi la chiama può quindi
/// tenere la rotella di caricamento accesa finché questo Future non si completa.
///
/// Restituisce il valore prodotto da [operazione]: nelle scritture [T] è `void`
/// e si ignora, nelle letture è il dato appena caricato.
Future<T> eseguiConRetry<T>(
  Future<T> Function() operazione, {
  Duration timeoutTentativo = const Duration(seconds: 5),
  Duration attesaTraTentativi = const Duration(seconds: 2),
}) async {
  while (true) {
    try {
      return await operazione().timeout(timeoutTentativo); // successo: esco dal loop
    } catch (e) {
      debugPrint(
        'Operazione fallita, ritento tra ${attesaTraTentativi.inSeconds}s: $e',
      );
      await Future.delayed(attesaTraTentativi);
    }
  }
}
