import 'package:flutter/material.dart';

//Widget che rappresenta il singolo macronutriente che andrà inserito nel
//Wisget papà MacroBox.

class MacroTile extends StatelessWidget {
  final String label;
  final String value;
  final String goal;
  final Color color;

  const MacroTile({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          //Il pallino colorato
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              //Colore passato dal papa Macrobox direttamente da MacroColors.
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          
          //L'etichetta col nome del macro (con il fix FittedBox per non tagliarlo)
          Expanded(
            child: FittedBox(
              //ScaldeDown di FittedBox rimpisciolisce il testo se è troppo grande per entrare nella riga.
              fit: BoxFit.scaleDown,
              //Mettiamo tutto il testo sulla sinistra della row.
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          
          //I valori in grammi
          Text(
            '${value}g / ${goal}g',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}