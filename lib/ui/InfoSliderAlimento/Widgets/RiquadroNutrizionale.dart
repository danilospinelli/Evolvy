import 'package:flutter/material.dart';
import 'RigaNutriente.dart';

//Widget che rappresenta un grande Box dove verranno inserite le righe degli alimenti nella pagina.

class RiquadroNutrizonale extends StatelessWidget {
  //Riceve una lista di widget da mettere al suo interno.
  final List<RigaNutriente> nutrienti;

  const RiquadroNutrizonale({super.key, required this.nutrienti});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        //MainAxis min per visualizzare tutto nel minor spazio possibile senza allungarsi all'infinito.
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "Valori Nutrizionali",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          //Diveder crea delle righe sottilissime per separare le righe nutrizionali.
          const Divider(height: 1),
          //ConstrainedBox impone al riquadro di non superare un determinato valore, in questo caso 250.
          //insieme a ListView e ShrinkWrap questo ci permette di avere sia la totale pagina iniziale scorrevole con il Widget SingleChildScroll in InfoSliderView
          //Ma diventerà un box scorrevole a se stante in caso dovessimo aggiungere tot micronutrienti o altri valori.
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true, 
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: nutrienti,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
