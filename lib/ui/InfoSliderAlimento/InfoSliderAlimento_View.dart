import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/repositories/LogMealREpository.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_View.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/InfoSliderAlimento_ViewModel.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/SelettoreQuantita.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/TastoConferma.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/Widgets/InputQuantita.dart';
import 'Widgets/RiquadroNutrizionale.dart';
import 'Widgets/RigaNutriente.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

class InfoSliderAlimentoView extends StatefulWidget {
  final Food ciboSelezionato;
  final MealTypes_Enum mealType;
  final LoggedFood? ciboGiaLoggato;

  const InfoSliderAlimentoView({
    super.key,
    required this.ciboSelezionato,
    required this.mealType,
    this.ciboGiaLoggato,
  });

  @override
  State<InfoSliderAlimentoView> createState() => _InfoSliderAlimentoViewState();
}

class _InfoSliderAlimentoViewState extends State<InfoSliderAlimentoView> {
  late final InfoSliderAlimentoViewModel _viewModel;
  late final TextEditingController _textController;

  //PROBABILMENTE è POSSIBILE FARE CIO CON UNA FUNZIONE SQL PIU SEMPLICE!!!
  @override
  void initState() {
    super.initState();
    _viewModel = InfoSliderAlimentoViewModel(alimento: widget.ciboSelezionato);
    if (widget.ciboGiaLoggato != null) {
      final vecchiaQuantita = widget.ciboGiaLoggato!.quantita ?? 0.0;

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

                  // PRIMA ROW: LA ZONA COMANDI (Input, Tendina, Tasto Verde)
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
                          if (widget.ciboGiaLoggato != null) {
                            final logRepo = LogMealRepository();
                            await logRepo.removeCibo(
                              id_utente: 1,
                              data: DateTime.parse('2026-04-28'),
                              meal: widget.mealType
                                  .toString()
                                  .split('.')
                                  .last
                                  .toLowerCase(),
                              nome_cibo: widget.ciboGiaLoggato!.nome ?? '',
                              quantita: widget.ciboGiaLoggato!.quantita ?? 0.0,
                            );
                          }
                          await _viewModel.salvaCiboNelDatabase(
                            widget.mealType,
                          );

                          if (!context.mounted) return;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Homepage_View(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    ],
                  ), // <--- ECCO LA CHIAVE! QUESTA PARENTESI PRIMA MANCAVA QUI. Chiude la zona orizzontale superiore.
                  // ORA TORNIAMO NELLA COLUMN VERTICALE PRINCIPALE
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

                  const SizedBox(
                    height: 16,
                  ), // Un respiro extra prima del riquadro
                  // SECONDA ROW: LA DASHBOARD (Nutrienti a sx, Mascotte a dx)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ZONA SINISTRA
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

                      const SizedBox(width: 12), // Terra di nessuno
                      // ZONA DESTRA
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
                                  //AGGIUNGERE PIU AVANTI TOCCO Mascotte
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
