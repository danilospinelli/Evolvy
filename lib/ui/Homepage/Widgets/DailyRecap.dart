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
                  child: _MacroBox(vm: vm),
                ),
                const SizedBox(width: 18),
                Expanded(
                  flex: 2,
                  child: _TipsBox(vm: vm),
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
}


// Sezione macro
class _MacroBox extends StatelessWidget {
  final Homepage_ViewModel vm;

  const _MacroBox({
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

          if(vm.isLoading)
            CaricamentoCircolare()
          else
            ...MacroType_Enum.values
              .where((meal) => meal != MacroType_Enum.Calorie)
              .map(
                (meal) => Column(
                  children: [
                    _MacroTile(
                      vm: vm,
                      label: meal.toString().split('.').last,
                      value: vm.obtainedMacros(meal, vm.allFoods).toString(),
                      goal: vm.dailyMacroGoal(meal).toString(),
                      color: macroColor(meal), // Assicurati che questo metodo sia accessibile globalmente o passalo
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


// Sezione suggerimenti
class _TipsBox extends StatelessWidget {
  final Homepage_ViewModel vm;

  const _TipsBox({
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
                  child: vm.isLoading
                      ? const CaricamentoCircolare()
                      : Text(
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


// Singolo blocchetto per le macro
class _MacroTile extends StatelessWidget {
  final Homepage_ViewModel vm;
  final String label;
  final String value;
  final String goal;
  final Color color;

  const _MacroTile({
    super.key,
    required this.vm,
    required this.label,
    required this.value,
    required this.goal,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
