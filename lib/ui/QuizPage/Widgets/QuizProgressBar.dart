import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';

//Widget di progressione delle domande dei quiz. Ha una logica leggermente diversa dalla progressBar in core
//Per questo è definita a parte.

class QuizProgressBar extends StatelessWidget {
  const QuizProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    //Deve cosantemente monitorare lo stato del viewmodel per aggiornarsi.
    final vm = context.watch<QuizPage_ViewModel>();
    final total = vm.totalQuestions;
    //in caso sia 0 per il VM non pronto.
    final progress = total == 0 ? 0.0 : vm.currentQuestionNumber / total;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DOMANDA ${vm.currentQuestionNumber} di $total',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          //ClipRRect e LinearProgressIndicator per rappresentare bene una barra di progressione stondeggiata.
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              //AlwaysStoppedAnimation per evitare di restituire un animazione complessa.
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade400),
            ),
          ),
        ],
      ),
    );
  }
}
