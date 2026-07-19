import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ChallengeCard.dart';

//Widget per la sezione in basso della pagina principale. Quella degli obiettivi
//e del loro completamento.

class ObiettiviSection extends StatelessWidget {
  const ObiettiviSection({
    super.key,
    required this.challenges,
  });

  final List<Obiettivo> challenges;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<Avatar_ViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I tuoi obiettivi:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),

        //Le card restano SEMPRE visibili: non le sostituisco con la rotella,
        //altrimenti la ChallengeCard verrebbe smontata e la sua snackbar saltata.
        for (final challenge in challenges) ...[
          ChallengeCard(
            challenge: challenge,
          ),
          const SizedBox(height: 12),
        ],

        //Operazione in corso: rotella SOTTO la lista, come nel quiz.
        if (vm.isUpdatingObjective)
          const Center(child: CaricamentoCircolare()),
      ],
    );
  }
}
