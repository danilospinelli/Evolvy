import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//Widget generale della pagina di infosliderAlimento. La pagina dove seleziono le quantità e aggiungo il cibo
//é strettamente connesso alla homepage.

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
    //Se stiamo modificando un cibo già nel log allora mostriamo le sue quantità
    //alteimenti di base 100g.
    final String testoIniziale = ciboGiaLoggato != null 
        ? ciboGiaLoggato!.quantita.round().toString() 
        : "100";

    //Usiamo un provider specifico per questa pagina dato che ci si arriva tramite sequenze di azioni.
    //non è nella navigationBar.
    return ChangeNotifierProvider(
      create: (_) => InfoSliderAlimento_ViewModel()..init(ciboGiaLoggato),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<InfoSliderAlimento_ViewModel>();
          final homepageVM = context.watch<Homepage_ViewModel>();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const FrecciaIndietro(coloreIcona: Colors.blue),
            ),
            //SafeArea per disegnare i widget escludendo interfacce visive dedicate ad altro nei telefoni per esempio.
            body: SafeArea(
              //SingleChildScrollView come sempre per scrollare senza che ci siano problemi di overflow.
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
                            //La barra di input delle quantità che occupa un tot di spazio tramite flex ed Expanded
                            child: InputQuantita(
                              valoreIniziale: testoIniziale,
                              onChanged: viewModel.aggiornaQuantita,
                            ),
                          ),
                          const SizedBox(width: 12),
                          //Tasto per cambiare l'unità di misura. Altro Widget.
                          SelettoreQuantita(
                            valoreAttuale: viewModel.unita,
                            opzioni: viewModel.unitaDisponibili,
                            onChanged: viewModel.cambiaUnita,
                          ),
                          const SizedBox(width: 12),
                          if (homepageVM.isUpdatingFood)
                            //Salvataggio in corso: rotella al posto del tasto OK.
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: CaricamentoCircolare(),
                            )
                          else
                          //Aggiunta di un cibo, o la sua modifica, al diario.
                          TastoConferma(
                            onPressed: () async {
                              final insertingFood = viewModel.generaCiboLoggato(ciboSelezionato);

                              if (ciboGiaLoggato != null) {

                                await homepageVM.updateFood(
                                  mealType,
                                  ciboGiaLoggato!,
                                  insertingFood,
                                );

                                if (!context.mounted) return;
                                SnackBarInfo.foodAction(context, 'update', insertingFood.nome);
                                Navigator.pop(context); // 1 solo passo indietro

                              } else {

                                await homepageVM.addFood(mealType, insertingFood);

                                if (!context.mounted) return;
                                SnackBarInfo.foodAction(context, 'add', insertingFood.nome);

                                int count = 0;
                                Navigator.popUntil(context, (route) => count++ == 2); // 2 passi indietro
                              }
                            },
                          ),
                        ], 
                      ), 

                      const SizedBox(height: 32),
                      const Align(
                        //Testo allineato in centro sinistra.
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
                      

                      //TODO!!: Nel prossimo sprint rendere questo comportamento uguale a MacroBox e MacroTile. In questo caso è Hardcodato con parametri definiti.
                      //Widget esterno RiquadroNutrizionale che gestisce la visualizzazione di tutti i valori nutrizionali
                      //Dell'elemento selezionato. Grazie al Watch sul viewModel cambiano e si ridisegnano al cambiamento delle quantità.
                      RiquadroNutrizonale(
                        nutrienti: [
                          //Il riquadro nutrizionale è un Box che al suo interno ha dei widget separati per le righe.
                          //Gestionie molto simile a MacroBox e MacroTile.
                          //Con toStringAsFixed(1) mostiamo una singola cifra decimale.
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