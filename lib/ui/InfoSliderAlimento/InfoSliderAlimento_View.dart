import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/InfoSliderAlimento_ViewModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/SelettoreQuantita.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/TastoConferma.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/domain/models/MealType_Enum.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/InputQuantita.dart';
import 'Widgets/RiquadroNutrizionale.dart';
import 'Widgets/RigaNutriente.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:provider/provider.dart';

class InfoSliderAlimento_View extends StatefulWidget {
  final Food ciboSelezionato;
  final MealType_Enum mealType;
  final LoggedFood? ciboGiaLoggato;

  const InfoSliderAlimento_View({
    super.key,
    required this.ciboSelezionato,
    required this.mealType,
    this.ciboGiaLoggato,
  });

  @override
  State<InfoSliderAlimento_View> createState() => _InfoSliderAlimentoViewState();
}

class _InfoSliderAlimentoViewState extends State<InfoSliderAlimento_View> {
  late final InfoSliderAlimento_ViewModel _viewModel;
  late final TextEditingController _textController;

  //PROBABILMENTE è POSSIBILE FARE CIO CON UNA FUNZIONE SQL PIU SEMPLICE!!!
  @override
  void initState() {
    super.initState();
    _viewModel = InfoSliderAlimento_ViewModel(alimento: widget.ciboSelezionato);
    if (widget.ciboGiaLoggato != null) {
      final vecchiaQuantita = widget.ciboGiaLoggato!.quantita;

      _textController = TextEditingController(text: vecchiaQuantita.toString());
      _viewModel.aggiornaQuantita(vecchiaQuantita.toString());
    } else {
      _textController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const FrecciaIndietro(coloreIcona: Colors.blue),
          ),

          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // TITOLO ALIMENTO
                  Text(
                    widget.ciboSelezionato.nome ?? 'Alimento',
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
                          controller: _textController,
                          onChanged: _viewModel.aggiornaQuantita,
                        ),
                      ),
                      const SizedBox(width: 12),
                      SelettoreQuantita(
                        valoreAttuale: _viewModel.unita,
                        opzioni: _viewModel.unitaDisponibili,
                        onChanged: _viewModel.cambiaUnita,
                      ),
                      const SizedBox(width: 12),
                      TastoConferma(
                        onPressed: () async {
                          final homepageVM = context.read<Homepage_ViewModel>();
                          // Se c'è un cibo già loggato, lo rimuoviamo prima di aggiungere quello nuovo
                          if (widget.ciboGiaLoggato != null) {
                            await homepageVM.removeFood(
                              mealType: widget.mealType, 
                              food: widget.ciboGiaLoggato!,
                            );
                          }
                          // Cibo da aggiungere
                          final insertingFood = _viewModel.generaCiboLoggato();
                          await homepageVM.addFood(
                            widget.mealType,
                            insertingFood,
                          );
                          if (!context.mounted) return;
                          // Cambia schermata e torna alla Homepage
                          // TODO: ATTENZIONE: Homepage deve rimanere alla base dello stack
                          Navigator.popUntil(context, (route) => route.isFirst);
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

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: RiquadroNutrizonale(
                          nutrienti: [
                            RigaNutriente(
                              etichetta: "Calorie",
                              valore:
                                  "${_viewModel.kcalCalcolate.toStringAsFixed(1)} kcal",
                            ),
                            RigaNutriente(
                              etichetta: "Carboidrati",
                              valore:
                                  "${_viewModel.carbCalcolate.toStringAsFixed(1)} g",
                            ),
                            RigaNutriente(
                              etichetta: "Proteine",
                              valore:
                                  "${_viewModel.protCalcolate.toStringAsFixed(1)} g",
                            ),
                            RigaNutriente(
                              etichetta: "Grassi",
                              valore:
                                  "${_viewModel.grasCalcolati.toStringAsFixed(1)} g",
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        flex: 4,
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.topCenter,
                              child: AvatarCondiviso(
                                messaggio: "Guarda come cambiano i valori!",
                                onTap: () {
                                  // TODO: AGGIUNGERE PIU AVANTI TOCCO Mascotte
                                  print("Mascotte toccata nella pagina Info");
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
