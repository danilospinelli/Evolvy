import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
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

          //HO MODIFICATO IL METODO PER PERMETTERE DI TORNARE ALL INFOVIEW. POSSIBILE MODIFICA TRAMITE FUNZIONE SQL!!
          //POICHE QUI FACCIO DLETE INSERT
          // In futuro, il Data Layer (Supabase) dovrebbe esporre una funzione RPC dedicata
          // alla modifica (es. 'modifica_log_pasto' tramite SQL UPDATE o UPSERT).
          // Quando quella funzione sarà pronta, si potrà eliminare questo blocco di cancellazione
          // e fare una singola chiamata asincrona per garantire l'atomicità dell'operazione.
          // TODO: metterlo nel ViewModel
          onTap: () async {
            final moltiplicatore = (food.quantita ?? 100) / 100;
            final foodRicostruito = Food(
              nome: food.nome,
              kcalper100: (food.calorie ?? 0) / moltiplicatore,
              carbper100: (food.carboidrati ?? 0) / moltiplicatore,
              protper100: (food.proteine ?? 0) / moltiplicatore,
              grasper100: (food.grassi ?? 0) / moltiplicatore,
            );
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
                Text(food.toString(), style: const TextStyle(fontSize: 16)),

                IconButton(
                  onPressed: () async {
                    await context
                        .read<Homepage_ViewModel>()
                        .removeFood(mealType: mealtype, food: food);
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