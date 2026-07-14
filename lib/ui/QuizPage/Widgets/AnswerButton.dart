import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({
    super.key,
    required this.index,
    required this.text,
  });

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizPage_ViewModel>();

    final bool isSelected = vm.selectedIndex == index;
    final bool showResult = vm.answered; //&& (isSelected || vm.isCorrect(index));

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    if (showResult) {
      if (vm.isCorrect(index)) {
        backgroundColor = Colors.green.shade50;
        borderColor = Colors.green.shade400;
      } else if (isSelected) {
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red.shade400;
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: vm.answered
              ? null
              : () {
                final vm = context.read<QuizPage_ViewModel>();
                vm.completaQuiz(index, context.read<Avatar_ViewModel>());
                if(vm.isCorrect(index)){
                  // Mostra SnackBar per Exp
                  SnackBarInfo.xpGain(context, QuizPage_ViewModel.expPerCorrectAnswer);
                }
              },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
