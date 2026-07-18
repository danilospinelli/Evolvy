import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

class SnackBarInfo extends SnackBar {
  final String message;
  final IconData icon;
  final Color color;

  // Costruttore privato, così si deve perforza passare per show
  SnackBarInfo._({
    required this.message,
    required this.icon,
    required this.color,
  }) : super(
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );

  // Metodo da richiamare per creare la SnackBar
  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
    // accumula = True -> puoi accumulare più SnackBar
    // accumula = False -> ripulisce le SnackBar e mostra solo l'ultima
    required bool accumula,
  }) {
    // Svuota la coda delle SnackBar (evita accumulo)
    if(!accumula){
      ScaffoldMessenger.of(context).clearSnackBars();
    }

    // Mostra la SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarInfo._(
        message: message,
        icon: icon,
        color: color,
      ),
    );
  }

  static void xpGain(BuildContext context, int xpGuadagnata, int nLivelli) {
    // SnackBar Exp
    SnackBarInfo.show(
      context,
      message: 'Punti esperienza guadagnati: +$xpGuadagnata EXP',
      icon: Icons.star_rounded,
      color: Colors.blue,
      accumula: true,
    );

    if (nLivelli > 0) {
      // SnackBar livello
      SnackBarInfo.show(
        context,
        message: nLivelli == 1 ? 'Sei aumentato di Livello!' : 'Sei aumentato di $nLivelli Livelli!',
        icon: Icons.upgrade,
        color: const Color.fromARGB(255, 34, 153, 38),
        accumula: true,
      );
      // SnackBar monete
      int nMonete = Avatar_ViewModel.monetePerLevelUp * nLivelli;
      SnackBarInfo.show(
        context,
        message: 'Hai guadagnato $nMonete monete',
        icon: Icons.monetization_on_rounded,
        color: Colors.yellow,
        accumula: true,
      );
    }
  }
}