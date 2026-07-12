import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuizProgressBar.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuestionCard.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/NextQuestionButton.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';

class QuizPage_View extends StatelessWidget {
  const QuizPage_View({super.key});

  @override
  Widget build(BuildContext context) {
    QuizPage_ViewModel vm = context.watch<QuizPage_ViewModel>();

    Widget body;

    if (vm.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (vm.totalQuestions == 0) {
            body = const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Hai già completato il quiz di oggi, torna domani per uno nuovo! 🔥',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            );
          } else if (vm.finished) {
            body = const Center(
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
          } else {
            body = SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const QuizProgressBar(),
                const QuestionCard(),
                if (vm.answered)
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                    child: AvatarCondiviso(
                      titolo: 'SPIEGAZIONE',
                      messaggio: vm.spiegazione,
                      dimensioneAvatar: 90,
                      larghezzaMassimaMessaggio: double.infinity,
                      onTap: () {} // TODO: TOCCO MASCOTTE
                    ),
                  ),
                if (vm.answered) const NextQuestionButton(),
              ],
            ),
          );

          }

    return Scaffold(
      appBar: AppBar(
        title: const Text('QUIZ'),
        centerTitle: true,
        leading: const FrecciaIndietro(),
      ),
      body: body
    );
  }
}
