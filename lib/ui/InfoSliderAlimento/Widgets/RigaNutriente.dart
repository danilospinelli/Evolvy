import 'package:flutter/material.dart';

//Widget che rappresenta un micro componente, una singola riga sulla quale verranno mostrati i dati nutrizionali
//di un alimento in particolare. é dentro Riquadro nutrizionale ma gestito dalla View Di infoslider.

class RigaNutriente extends StatelessWidget {
  final String etichetta;
  final String valore;

  const RigaNutriente({
    super.key,
    required this.etichetta,
    required this.valore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      //Spazio verticale da tenere conto per più righe con EdgeInsest vertical.
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        //SpaceBetween per etichetta a sinistra e valore a destra.
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                etichetta,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            valore,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
