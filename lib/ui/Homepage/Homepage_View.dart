import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/ui/RicercaCibi/RicercaCibi_View.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';

class Homepage_View extends StatelessWidget {
  const Homepage_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            MealBox_View(mealType: MealTypes_Enum.Colazione),
            MealBox_View(mealType: MealTypes_Enum.Pranzo),
            MealBox_View(mealType: MealTypes_Enum.Cena),
            MealBox_View(mealType: MealTypes_Enum.Altro),
          ],
        ),
      ),
    );
  }
}

class MealBox_View extends StatefulWidget {
  const MealBox_View({super.key, required this.mealType});

  final MealTypes_Enum mealType;

  @override
  State<MealBox_View> createState() => _MealBox_ViewState();
}

class _MealBox_ViewState extends State<MealBox_View> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Mealbox_ViewModel viewmodel = Mealbox_ViewModel();
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          // BOX PRINCIPALE
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          viewmodel.getMealTypeIcon(widget.mealType),
                          size: 30,
                        ),

                        const SizedBox(width: 10),

                        Text(
                          widget.mealType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RicercaView(mealType: widget.mealType),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SEZIONE ESPANDIBILE
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            firstChild: const SizedBox(),

            secondChild: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, color: Colors.black12),
                ],
              ),

              // Gestione di dati di tipo Future
              child: FutureBuilder<List<LoggedFood>>(
                future: viewmodel.getFoodsByMeal(widget.mealType),

                builder: (context, snapshot) {
                  // Mostra un indicatore di caricamento mentre i dati vengono recuperati
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // Se non ci sono dati o la lista è vuota, mostra un messaggio
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("Nessun cibo caricato");
                  }

                  final foods = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: foods.map((f) {
                      return InsertedFood(
                        food: f,
                        mealtype: widget.mealType,
                        onDeleted: () {
                          setState(() {});
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InsertedFood extends StatelessWidget {
  const InsertedFood({
    super.key,
    required this.food,
    required this.mealtype,
    required this.onDeleted,
  });

  final LoggedFood food;
  final MealTypes_Enum mealtype;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) {
    final InsertedFood_ViewModel viewmodel = InsertedFood_ViewModel();
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
                builder: (_) => InfoSliderAlimentoView(
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
                    // Elimina il cibo dal pasto, AGGIORNA LO SHEET CON NOTIFY???????
                    await viewmodel.removeFoodFromMeal(
                      mealtype: mealtype,
                      food: food,
                    );
                    onDeleted();
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
