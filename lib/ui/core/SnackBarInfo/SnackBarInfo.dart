import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

//Widget SnackBar ovvero il "sistemino" di notifiche relative a determinate azioni dell'utente
//come aggiunta cibi o durante i quiz durante le risposte. Estendiamo direttamente dal Widget di Dart SnackBar
//Nel core dato che può essere chiamata per ogni azione.

class SnackBarInfo extends SnackBar {
  final String message;
  final IconData icon;
  final Color color;

  //Costruttore privato, così si deve per forza passare per show e tutti controlli dei parametri,
  //specialmente quelli di accumulo.

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
              //Qui Expanded ci salva permettendo al testo di non eccedere le dimensioni della Row ma adattarsi di conseguenza.
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

  //L'unico metodo accessibile all'esterno per creare la SnackBar.

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

    // Mostra la SnackBar instanziando il costruttore privato
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarInfo._(
        message: message,
        icon: icon,
        color: color,
      ),
    );
  }

  //Metodo di logica che ci permette di definire solamente qui, e non sparpagliato in tutta l'app, la visualizzazione
  //della snackBar relativa a specifici eventi. 

  static void xpGain(BuildContext context, int xpGuadagnata, int nLivelli) async {

    //SnackBar guadagno Exp
    SnackBarInfo.show(
      context,
      message: 'Punti esperienza guadagnati: +$xpGuadagnata EXP',
      icon: Icons.star_rounded,
      color: Colors.blue,
      accumula: true,
    );

    //SnackBar livello
    if (nLivelli > 0) {
      SnackBarInfo.show(
        context,
        message: nLivelli == 1 ? 'Sei aumentato di Livello!' : 'Sei aumentato di $nLivelli Livelli!',
        icon: Icons.upgrade,
        color: const Color.fromARGB(255, 34, 153, 38),
        accumula: true,
      );

      //SnackBar guadagno monete
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
  

  //Stesso discorso di sopra, metodo che permette di gestire in maniera comoda la creazione di Snakcbar personalizzate in base alla
  //rimozione, aggiunta o update di un cibo nel LogMeal.

  static void foodAction(BuildContext context, String actionType, String nomeCibo) {
    String messaggio = '';
    IconData icona = Icons.info;
    Color colore = Colors.grey;

    //Switch per gestire quale azione devo fare. Viene dalle view di HP e InsertFood.
    switch (actionType) {
      case 'add':
        messaggio = '$nomeCibo aggiunto al diario!';
        icona = Icons.check_circle;
        colore = Colors.green.shade600;
        break;
      case 'update':
        messaggio = '$nomeCibo aggiornato con successo!';
        icona = Icons.edit;
        colore = Colors.blue.shade600;
        break;
      case 'remove':
        messaggio = '$nomeCibo rimosso dal diario.';
        icona = Icons.delete_outline;
        colore = Colors.red.shade600;
        break;
    }

    SnackBarInfo.show(
      context,
      message: messaggio,
      icon: icona,
      color: colore,
      accumula: false, // Meglio false, così non si impilano 10 popup se cancella veloce
    );
  }
}