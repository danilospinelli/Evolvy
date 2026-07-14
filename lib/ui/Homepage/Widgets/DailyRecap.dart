import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart';
import 'package:flutter_application_1/domain/MacroColors.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/ProgressBar.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

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
                  child: _macroBox(context, vm),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 2,
                  child: _tipsBox(vm),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // SEZIONE CALORIE
          if(vm.isLoading)
            CaricamentoCircolare()
          else
            ProgressBar(
              current: vm.obtainedMacros(MacroType_Enum.Calorie, vm.allFoods),
              goal: vm.dailyMacroGoal(MacroType_Enum.Calorie),
              label: 'Calorie',
              abbr: 'kcal',
              showBackground: true,
              valueOnSide: false,
            ),
        ],
      ),
    );
  }

  // BOX MACRONUTRIENTI -------------------------------------------------------------------------
  Widget _macroBox(BuildContext context, Homepage_ViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          const Text(
            'Macronutrienti',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 18),
          // Cicla su tutti i macro e crea un tile per ognuno, tranne per "Calorie"
          ...MacroType_Enum.values
          .where((meal) => meal != MacroType_Enum.Calorie)
          .map(
            (meal) => Column(
              children: [
                _macroTile(
                  context, 
                  label: meal.toString().split('.').last,
                  value: vm.obtainedMacros(meal, vm.allFoods).toString(),
                  goal: vm.dailyMacroGoal(meal).toString(),
                  color: macroColor(meal),
                ),
                const SizedBox(height: 14),
              ],
            )
          )
        ],
      ),
    );
  }

  // BOX SUGGERIMENTI ---------------------------------------------------------------------------
  Widget _tipsBox(Homepage_ViewModel vm) {
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
                  child: vm.isLoading ? 
                    CaricamentoCircolare() :
                    Text(
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

  // Metodo che restituisce un widget con un certo macronutriente e i grammi assunti/obiettivo
  // Si è scelto di non fare una nuova classe extends StatelessWidget perché è un widget molto semplice e utilizzato solo qui, quindi una funzione è più che sufficiente
  Widget _macroTile(
    BuildContext context, {
    required String label,
    required String value,
    required String goal,
    required Color color,
  }) {
    final vm = context.watch<Homepage_ViewModel>();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [

          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if(vm.isLoading)
            CaricamentoCircolare()
          else
            Text(
            '$value g / $goal g',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
