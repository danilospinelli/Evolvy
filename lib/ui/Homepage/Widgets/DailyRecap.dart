import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart'; 
import 'package:flutter_application_1/domain/MacroColors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/ProgressBar.dart';

class DailyRecap extends StatelessWidget {
  const DailyRecap({super.key});

  @override
  Widget build(BuildContext context) {
    // Usiamo il .watch perché ad ogni cambiamento, tutti i widget devono modificarsi (rebuild totale)
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

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SEZIONE MACRONUTRIENTI -------------------------------------------------------------------
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          label: meal.toString().split('.').last,
                          value: vm.obtainedMacros(meal, vm.allFoods).toString(),
                          goal: vm.dailyMacroGoal(meal, vm.allFoods).toString(),
                          color: macroColor(meal),
                        ),
                        const SizedBox(height: 14),
                      ], 
                    )
                  )
                ],
              ),
            ),
          ),

          const SizedBox(width: 18),

          // SEZIONE CALORIE ---------------------------------------------------------------------------
          Expanded(
            flex: 3,
            child: ProgressBar(
              current: vm.obtainedMacros(MacroType_Enum.Calorie, vm.allFoods),
              goal: vm.dailyMacroGoal(MacroType_Enum.Calorie, vm.allFoods),
            ),
          ),

          const SizedBox(width: 18),

          // SEZIONE TIPS -----------------------------------------------------------------------------
          Expanded(
            flex: 2,
            child: Container(
              height: 252,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(18),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                          child: Text(
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
            ),
          ),
        ],
      ),
    );
  }

  // Metodo che restituisce un widget con un certo macronutriente e i grammi assunti/obiettivo
  // Si è scelto di non fare una nuova classe extends StatelessWidget perché è un widget molto semplice e utilizzato solo qui, quindi una funzione è più che sufficiente
  Widget _macroTile({
    required String label,
    required String value,
    required String goal,
    required Color color,
  }) {
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