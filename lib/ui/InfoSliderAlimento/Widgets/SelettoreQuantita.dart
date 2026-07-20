import 'package:flutter/material.dart';

//Widget che rappresenta il selettore dll'unità di misura a destra della barra di inserimento quantità.

class SelettoreQuantita extends StatelessWidget {
  //Parametri che mi servono per aggiornare correttamente l'unità di misura.
  final String valoreAttuale;
  final List<String> opzioni;
  final ValueChanged<String?> onChanged;

  const SelettoreQuantita({
    super.key,
    required this.valoreAttuale,
    required this.opzioni,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),

      //Widget che mi creano il menu a tendina per la selezione delle unità di misura.
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          //mostriamo valoreAttuale per default.
          value: valoreAttuale,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          //Per il menu a tendina servono ogetti di tipo DropDown. con map iteriamo su tutte le nostre
          //unità di misura e le trasformiamo per vederla nel menu a tendina.
          items: opzioni.map((String singolaUnita) {
            return DropdownMenuItem<String>(
              value: singolaUnita,
              child: Text(singolaUnita),
            );
          }).toList(), //Lista finale compatta.

          //Dopo il tap ritorniamo l'aggiornamento.
          onChanged: onChanged,
        ),
      ),
    );
  }
}
