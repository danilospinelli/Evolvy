import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuizProgressBar.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuestionCard.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/ExplanationBubble.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/NextQuestionButton.dart';

// E' un tab della MainScreen (IndexedStack), non una route pushata: nessuna freccia indietro
class QuizPage_View extends StatelessWidget {
  const QuizPage_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QUIZ'),
        centerTitle: true,
      ),
      body: Consumer<QuizPage_ViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  vm.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          if (vm.totalQuestions == 0) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Hai già completato il quiz di oggi, torna domani per uno nuovo! 🔥',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            );
          }

          if (vm.finished) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Quiz completato! 🎉',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Torna domani per un nuovo quiz! 🔥',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const QuizProgressBar(),
                const QuestionCard(),
                if (vm.submitError != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Text(
                      'Errore nel salvataggio della risposta: ${vm.submitError}',
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                if (vm.answered) const ExplanationBubble(),
                if (vm.answered) const NextQuestionButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
