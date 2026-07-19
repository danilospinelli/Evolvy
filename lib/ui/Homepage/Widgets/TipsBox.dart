import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//Widget del box dei suggerimenti sulla destra della schermata home in alto.
//Mostra suggerimenti in base agli alimenti consumati. chiamata da DailyRecap.

class TipsBox extends StatelessWidget {
  final Homepage_ViewModel vm;

  const TipsBox({
    super.key,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Suggerimenti',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          //Tramite Expanded e double.ininity forziamo il contenuto interno ad occupare tutta la
          //latghezza disponibile.
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.green.shade100,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  //Carichiamo questa parte con questa logica tramite la rotellina.
                  child: (vm.isLoading || vm.isUpdatingFood)
                      ? const CaricamentoCircolare()
                      : Text(
                        //Prendiamo il DailyTip dal viewmodel.
                          vm.dailyTip,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}