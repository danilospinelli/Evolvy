import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/View/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';
import 'package:provider/provider.dart';

//Widget che rappresenta la riga di un cibo già salvato dall'utente.

class InsertedFood extends StatelessWidget {
  const InsertedFood({
    super.key,
    required this.food,
    required this.mealtype,
  });

  //Parametri per capire quale cibo dobbiamo visualizzare e a quale pasto.
  final LoggedFood food;
  final MealType_Enum mealtype;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      //Material ci permette di realizzare un box con uso di ombre e leggere animazioni con InkWell.
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 5,
        //Come prima InkWell ci permette di premere il bottone con leggere funzioni grafice in più.
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final foodRicostruito = context
                .read<Homepage_ViewModel>()
                //usiamo ResetValori per riutilizzare i valori relativi a 100g.
                .resetValori(food);
            await Navigator.push(
              context,
              MaterialPageRoute(
                //Andiamo alla pagina di selezione quantità con il nostro nuovo cibo.
                builder: (_) => InfoSliderAlimento_View(
                  ciboSelezionato: foodRicostruito,
                  mealType: mealtype,
                  ciboGiaLoggato: food,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              //spaceBetween mette il testo a sx e il cestino a dx.
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${food.nome}  ${food.quantita.round()} g  ${food.calorie.round()} kcal',
                  style: const TextStyle(fontSize: 16),
                ),

                //Logica di rimozione del cibo dal pasto.
                IconButton(
                  onPressed: () async {
                    await context
                        .read<Homepage_ViewModel>()
                        .removeFood(mealType: mealtype, food: food);
                    //Snackbar DOPO l'await: compare solo a rimozione realmente avvenuta.
                    if (context.mounted) {
                      //Notifica l'utente della rimozione.
                      SnackBarInfo.foodAction(context, 'remove', food.nome);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}