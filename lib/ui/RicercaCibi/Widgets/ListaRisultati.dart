import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/View/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/ui/RicercaCibi/ViewModel/RicercaCibi_ViewModel.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/RigaAlimento.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//Lista dei risultati. Come solito, è un grande box che al suo interno avrà le varie righe alimento,
//fatte dal widget RigaAlimento.

class ListaRisultati extends StatelessWidget {
  final RicercaCibi_ViewModel viewModel;

  final MealType_Enum mealType;

  const ListaRisultati({
    super.key,
    required this.viewModel,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      //ClipRRect è un widget che crea un contenitore esterno arrotondato uniformemente.
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        //ListenableBuilder per ridisegnare solo questa parte di interfaccia quando viene aggiornata!
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {

            //Caricamento circolare come sempre.
            if (viewModel.isLoading) {
              return const Center(child: CaricamentoCircolare());
            }

            final risultati = viewModel.risultati;

            if (risultati == null || risultati.isEmpty) {
              return Center(
                child: Text(
                  risultati == null
                      ? 'Nessun alimento cercato.'
                      : 'Nessun risultato trovato.',
                  style: const TextStyle(color: Colors.grey),
                ),
              );
            }

            //ListView widget che ti permette di scrollare la lista dentro il box.
            //Separated tramite Divider crea piccole righe separatrici. Diverso rispetto a Riquadro nutrizionale perchè qui non so quanti alimenti ho.
            return ListView.separated(
              itemCount: risultati.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
                indent: 16,
                endIndent: 16,
              ),
              //ItemBuilder ci costruisce solo gli ogetti restituiti che entrano in un determinato spazio.
              //Se si scorre li aggiorna.
              itemBuilder: (context, index) {
                final cibo = risultati[index];
                //Chamiamo il nostro widget Riga alimento.
                return RigaAlimento(
                  alimento: cibo,
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        //CLicchiamo un cibo e andiamo nella pagina infoslider.
                        builder: (_) => InfoSliderAlimento_View(
                          ciboSelezionato: cibo,
                          mealType: mealType,),
                      ),
                     );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
