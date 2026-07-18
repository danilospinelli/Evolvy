import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/AnswerButton.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizPage_ViewModel>();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            vm.question,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          ...vm.answers.asMap().entries.map(
                (entry) => AnswerButton(index: entry.key, text: entry.value.text),
              ),
          // Invio in corso: rotella SOTTO le risposte, che restano visibili.
          // Non le sostituisco per non smontare l'AnswerButton (romperebbe la sua snackbar).
          if (vm.isSubmitting)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(child: CaricamentoCircolare()),
            ),
        ],
      ),
    );
  }
}
