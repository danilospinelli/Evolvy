import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/QuizPage/ViewModel/QuizPage_ViewModel.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuizProgressBar.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/QuestionCard.dart';
import 'package:flutter_application_1/ui/QuizPage/Widgets/NextQuestionButton.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//Widget per la pagina dei quiz. Restituisce lo Scaffold generale della pagina e chiama ovviamente tutti gli altri
//nostri widget come answerButton o NextQuestionButton.

class QuizPage_View extends StatelessWidget {
  const QuizPage_View({super.key});

  @override
  Widget build(BuildContext context) {
    QuizPage_ViewModel vm = context.watch<QuizPage_ViewModel>();

    //body del widget creato separatamente
    Widget body;

    //Caricamento circolare se si caricano i dati.
    if (vm.isLoading) {
      body = const Center(child: CaricamentoCircolare());
      //Se non ci sono piu domande.
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
            //Se ho finito le domande nella sessione.
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

            //Gestione del Quiz attivo. Gestito da una SingleChildScrollView per scrollare la pagina se necessario.
            body = SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //Creazione di altri 2 widget da mettere al top ovvero la barra di progressione
                //e le domande.
                const QuizProgressBar(),
                const QuestionCard(),
                //Quando si risponde ad una domanda viene creato un nuovo Box Container con fiammella che fornisce
                //la spiegazione della domanda.
                if (vm.answered)
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                    child: AvatarCondiviso(
                      titolo: 'SPIEGAZIONE',
                      messaggio: vm.spiegazione,
                      dimensioneAvatar: 90,
                      larghezzaMassimaMessaggio: double.infinity,
                    ),
                  ),
                  //Se abbiamo risposto appare il bottone di NextQuestion.
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
