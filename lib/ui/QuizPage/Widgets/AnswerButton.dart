import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';

//Widget che rappresenta la singola risposta relativa ad una domanda di un quiz. Strettamente relegata a QuestionCard 
// dato che è entro di essa. Esattamente lo stesso pattern usato in tutte le altre Box/righe.

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

    //Flag booleani che prendono i valori dal VM relativi ad una certa domanda.
    final bool isSelected = vm.selectedIndex == index;
    final bool showResult = vm.answered; 

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey.shade300;

    //Se ho cliccato devo mostrare il risultato. Se è l'indice della domanda giusta è segnalato in verde
    //altrimenti in rosso la domanda a cui abbiamo risposto.
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
      //Material è un Widget che ci permette di decorare meglio il box
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        //InkWell come sempre gestisce il tocco con feedback visivi migliori.
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: (vm.answered || vm.isSubmitting)
          //disabilitiamo il tocco in questi 2 casi.
              ? null
              : () async {
                //Viene chiamata la funzione di AvatarModel che definisce come completato un quiz nel DB e ci da gli Xp per la domanda.
                  int nLivelli = await vm.completaQuiz(index, context.read<Avatar_ViewModel>());
                  if (vm.isCorrect(index)) {
                    //Mostra SnackBar per Exp se era la risposta corretta.
                    SnackBarInfo.xpGain(context, QuizPage_ViewModel.expPerCorrectAnswer, nLivelli);
                  }
                },
          //Box della domanda vera e propria.
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
