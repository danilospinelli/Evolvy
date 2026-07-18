import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/View/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';
import 'package:provider/provider.dart';

class InsertedFood extends StatelessWidget {
  const InsertedFood({
    super.key,
    required this.food,
    required this.mealtype,
  });

  final LoggedFood food;
  final MealType_Enum mealtype;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 5,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final foodRicostruito = context
                .read<Homepage_ViewModel>()
                .resetValori(food);
            await Navigator.push(
              context,
              MaterialPageRoute(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${food.nome}  ${food.quantita.round()} g  ${food.calorie.round()} kcal',
                  style: const TextStyle(fontSize: 16),
                ),

                IconButton(
                  onPressed: () async {
                    await context
                        .read<Homepage_ViewModel>()
                        .removeFood(mealType: mealtype, food: food);
                    // Snackbar DOPO l'await: compare solo a rimozione realmente avvenuta.
                    if (context.mounted) {
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