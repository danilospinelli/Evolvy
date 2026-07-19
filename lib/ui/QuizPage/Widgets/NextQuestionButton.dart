import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';

//Widget che rappresenta il bottone per passare alla prossima domanda.

class NextQuestionButton extends StatelessWidget {
  const NextQuestionButton({super.key});

  @override
  Widget build(BuildContext context) {
    //Usiamo watch perchè il bottone deve ridisegnarsi diversamente in base a parametri del VM
    //in questo caso Avanti o Fine.
    final vm = context.watch<QuizPage_ViewModel>();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: ElevatedButton(
        onPressed: () => context.read<QuizPage_ViewModel>().nextQuestion(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          //Testo cambia dinamicamente come detto prima.
          vm.isLastQuestion ? 'FINE' : 'AVANTI',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
