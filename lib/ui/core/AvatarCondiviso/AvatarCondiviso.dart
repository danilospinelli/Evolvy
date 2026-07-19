import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/utils/AvatarColors.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';


//Questo stateless Widget rappresenta visivamente la nostra fiammella con la nuvoletta stile
//dialogo al lato. é nel core essendo un widget condiviso da quasi tutti e ampiamente riutilizzato.
//é stateless perchè non gestisce stati interni, si ridisegna solo con cambi di parametri.

class AvatarCondiviso extends StatelessWidget {

//nullable nel caso volessimo disegnarla senza testo.

  final String? messaggio;
  final String? titolo;

//variabili per permetterci di disegnare fiammella in dimensioni personalizzate ad ogni pagina.

  final double dimensioneAvatar;
  final double larghezzaMassimaMessaggio;

//Nullable se vogliamo implementare un tocco sulla fiammella
//Lo facciamo ad esempio per i quiz.

  final VoidCallback? onTap;

  const AvatarCondiviso({
    super.key,
    this.messaggio,
    this.titolo,
    this.dimensioneAvatar = 180,
    this.larghezzaMassimaMessaggio = 220,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    //Il colore cambia in base al contesto quindi ha bisogno di "watch" per notare cambiamenti di parametri.
    
    final chosenColor = context.watch<Avatar_ViewModel>().user?.chosenColor ?? 0;

    //Align allinea qualcosa in una parte di schermo. In questo caso basso a destra.
    return Align(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        //CrossAxisAlignment per avvicinarlo il più possibile alla fiammella.
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if(messaggio != null)
          //Flexible ci permette di far andare il testo del messaggio
          //a capo e rientrare nei limiti della nuvoletta.
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: larghezzaMassimaMessaggio),
                margin: EdgeInsets.only(
                  bottom: dimensioneAvatar * 4 / 9,
                  right: 12.0,
                ),
                padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 16.0,
              ),

              //BoxDecoration è la nostra nuvoletta con i bordi stondati, tranne per il valore in basso a destre
              //per simulare la coda dei fumetti.
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              //Colonna per impilare vericalmente sullo stesso spazio titolo e messaggio
              //rispettando i valori minimi imposti da MainAxisSize per non far espandere troppo.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titolo != null) ...[
                    Text(
                      titolo!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    messaggio!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Widget per catturare i tocchi sullo schermo.
          GestureDetector(
            // Se onTap non è definito non fa niente dato che era nullable.
            onTap: onTap ?? () {},
            child: SizedBox(
              width: dimensioneAvatar,
              height: dimensioneAvatar,
              //immagine della fiammella di diversi colori.
              child: Image.asset(
                avatarSprite(chosenColor),
                //BoxFit per adattarla e non deformarla in caso di restringimenti o differenti dimensioni.
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
