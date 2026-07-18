import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/ProgressBar.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MacroBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/TipsBox.dart';


class DailyRecap extends StatelessWidget {
  const DailyRecap({super.key});

  @override
  Widget build(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          // MACRONUTRIENTI + SUGGERIMENTI
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  // Inseriamo la scatola macronutrienti
                  child: MacroBox(vm: vm), 
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 2,
                  // Inseriamo la scatola suggerimenti
                  child: TipsBox(vm: vm), 
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // SEZIONE CALORIE
          if (vm.isLoading || vm.isUpdatingFood)
            const CaricamentoCircolare()
          else
            ProgressBar(
              // FIX: .toDouble() per sicurezza matematica
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