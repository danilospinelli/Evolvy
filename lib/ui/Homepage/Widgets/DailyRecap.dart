import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/ProgressBar.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MacroBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/TipsBox.dart';

//Widget che fa da ponte tra l'homepage e tutti i box che rappresentano
//la giornata dell'utente in termini di obiettivi nutrizionali.

class DailyRecap extends StatelessWidget {
  const DailyRecap({super.key});

  @override
  Widget build(BuildContext context) {
    //Ci servr sapere ogni volta l'aggiornamento dei cibi per aggiornare i numeri.
    final vm = context.watch<Homepage_ViewModel>();

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        //I figli utilizzano tutto lo spazio fino a toccare i bordi con .stretch.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          //MACRONUTRIENTI + SUGGERIMENTI.
          //IntrinsicHeight che rende simmetrici i figli. Qui i box avranno tutti la stessa altezza
          //e saranno visivamente a coppia.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  //Flex indica la porzione di spazio che possono prendere in relazione agli altri.
                  flex: 3,
                  //Inseriamo la scatola macronutrienti
                  child: MacroBox(vm: vm), 
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 2,
                  //Inseriamo la scatola suggerimenti
                  child: TipsBox(vm: vm), 
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          //SEZIONE CALORIE
          //Logica per la visualizzazione della rotellina.
          if (vm.isLoading || vm.isUpdatingFood)
            const CaricamentoCircolare()
          else
          //la nostra ProgressBar estesa con valueOnside false.
            ProgressBar(
              current: vm.obtainedMacros(MacroType_Enum.Calorie, vm.allFoods).toDouble(),
              goal: vm.dailyMacroGoal(MacroType_Enum.Calorie).toDouble(),
              label: 'Calorie',
              abbr: 'kcal',
              showBackground: true,
              valueOnSide: false,
            ),
        ],
      ),
    );
  }
}