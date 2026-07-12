import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/InfoSliderAlimento/View/InfoSliderAlimento_View.dart';
import 'package:flutter_application_1/ui/RicercaCibi/ViewModel/RicercaCibi_ViewModel.dart';
import 'RigaAlimento.dart';

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
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

            return ListView.separated(
              itemCount: risultati.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[300],
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final cibo = risultati[index];
                return RigaAlimento(
                  alimento: cibo,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
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
