import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';

//Widget che rappresenta una singola riga di una intera lista di alimenti cercati con la barra di ricerca.

class RigaAlimento extends StatelessWidget {
  //Necessari alimenti e il comportamento al tocco.
  final FoodModel alimento;
  final VoidCallback onTap;

  const RigaAlimento({super.key, required this.alimento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    //InkWell come sempre è un Widget di interazione con il tocco che permette pià personalizzazione visiva.
    return InkWell(
      onTap: onTap,
      //Padding dentro un InkWell aumenta l'area cliccabile.
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          //SpaceBetween stessa logica di sempre negli altri file.
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                alimento.nome,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                //Se il testo è troppo lungo per la singola riga non lo manda a capo rompendo l'impaginazione ma lo tronca aggiungendo ... rispetto ai
                //limiti gestiti dall'expanded.
                //massimo una riga appunto.
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),

            Text(
              '${alimento.kcalper100} kcal/100g',
              style: const TextStyle(
                fontSize: 15,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
