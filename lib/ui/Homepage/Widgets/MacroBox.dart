import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/domain/MacroType_Enum.dart';
import 'package:flutter_application_1/ui/core/utils/MacroColors.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MacroTile.dart'; 

//Widget che rapppresenta il BOX a sinistra dei macronutrienti raggiunti dall'utente.

class MacroBox extends StatelessWidget {
  final Homepage_ViewModel vm;

  const MacroBox({
    super.key,
    required this.vm,
  });

  @override
  Widget build(BuildContext context) {
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

          //Oscuriamo solo questa parte con questa logica con la rotellina.
          if (vm.isLoading || vm.isUpdatingFood)
            const CaricamentoCircolare()
          else
            ...MacroType_Enum.values
                //Non ci servono le calorie ora.
                .where((macro) => macro != MacroType_Enum.Calorie)
                .map(
                  (meal) => Column(
                    children: [
                      //Per ogni riga usiamo il nostro widget MacroTile.
                      MacroTile(
                        label: meal.toString().split('.').last,
                        value: vm.obtainedMacros(meal, vm.allFoods).round().toString(),
                        goal: vm.dailyMacroGoal(meal).round().toString(),
                        color: macroColor(meal),
                      ),
                      const SizedBox(height: 14),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}