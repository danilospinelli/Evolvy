import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/ViewModel/InfoSliderAlimento_ViewModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/SelettoreQuantita.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/TastoConferma.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/InputQuantita.dart';
import '../Widgets/RiquadroNutrizionale.dart';
import '../Widgets/RigaNutriente.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';

class InfoSliderAlimento_View extends StatelessWidget {
  final FoodModel ciboSelezionato;
  final MealType_Enum mealType;
  final LoggedFood? ciboGiaLoggato;

  const InfoSliderAlimento_View({
    super.key,
    required this.ciboSelezionato,
    required this.mealType,
    this.ciboGiaLoggato,
  });

  @override
  Widget build(BuildContext context) {
    // Calcoliamo qui il valore iniziale da passare al widget grafico protetto
    final String testoIniziale = ciboGiaLoggato != null 
        ? ciboGiaLoggato!.quantita.round().toString() 
        : "100";

    return ChangeNotifierProvider(
      create: (_) => InfoSliderAlimento_ViewModel()..init(ciboGiaLoggato),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<InfoSliderAlimento_ViewModel>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const FrecciaIndietro(coloreIcona: Colors.blue),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ciboSelezionato.nome,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue,
                          letterSpacing: -0.8,
                          height: 2,
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: InputQuantita(
                              // PASSIAMO LA STRINGA, NON IL CONTROLLER
                              valoreIniziale: testoIniziale,
                              onChanged: viewModel.aggiornaQuantita,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SelettoreQuantita(
                            valoreAttuale: viewModel.unita,
                            opzioni: viewModel.unitaDisponibili,
                            onChanged: viewModel.cambiaUnita,
                          ),
                          const SizedBox(width: 12),
                          TastoConferma(
                            onPressed: () async {
                              final homepageVM = context.read<Homepage_ViewModel>();
                              final insertingFood = viewModel.generaCiboLoggato(ciboSelezionato);

                              if (ciboGiaLoggato != null) {
                                await homepageVM.updateFood(
                                  mealType,
                                  ciboGiaLoggato!,
                                  insertingFood,
                                );
                                if (!context.mounted) return;

                                SnackBarInfo.foodAction(context, 'update', insertingFood.nome);

                                // Navigazione sicura: sto modificando, faccio solo 1 passo indietro verso la Home
                                Navigator.pop(context); 
                              } else {
                                await homepageVM.addFood(mealType, insertingFood);
                                if (!context.mounted) return;
                                
                                SnackBarInfo.foodAction(context, 'add', insertingFood.nome);


                                // Navigazione sicura: sto aggiungendo, faccio 2 passi indietro (salto la Ricerca) per tornare alla Home
                                int count = 0;
                                Navigator.popUntil(context, (route) => count++ == 2);
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Valori Nutrizionali:",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      RiquadroNutrizonale(
                        nutrienti: [
                          RigaNutriente(
                            etichetta: "Calorie",
                            valore: "${viewModel.calcolaKcal(ciboSelezionato).toStringAsFixed(1)} kcal",
                          ),
                          RigaNutriente(
                            etichetta: "Carboidrati",
                            valore: "${viewModel.calcolaCarb(ciboSelezionato).toStringAsFixed(1)} g",
                          ),
                          RigaNutriente(
                            etichetta: "Proteine",
                            valore: "${viewModel.calcolaProt(ciboSelezionato).toStringAsFixed(1)} g",
                          ),
                          RigaNutriente(
                            etichetta: "Grassi",
                            valore: "${viewModel.calcolaGras(ciboSelezionato).toStringAsFixed(1)} g",
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const AvatarCondiviso(messaggio: "Guarda come cambiano i valori!"),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}