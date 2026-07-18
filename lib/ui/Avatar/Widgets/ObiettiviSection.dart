import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

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

        // Le card restano SEMPRE visibili: non le sostituisco con la rotella,
        // altrimenti la _ChallengeCard verrebbe smontata e la sua snackbar saltata.
        for (final challenge in challenges) ...[
          ChallengeCard(
            challenge: challenge,
          ),
          const SizedBox(height: 12),
        ],

        // Operazione in corso: rotella SOTTO la lista, come nel quiz.
        if (vm.isUpdatingObjective)
          const Center(child: CaricamentoCircolare()),
      ],
    );
  }
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({required this.challenge});

  final Obiettivo challenge;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<Avatar_ViewModel>();
    final completed = challenge.completed;

    return InkWell(
      onTap: (completed || vm.isUpdatingObjective) ? null : () async {
        int nLivelli = await vm.completaObiettivo(challenge);
        if (context.mounted) {
          SnackBarInfo.xpGain(context, challenge.xpReward, nLivelli);
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(30),
                color: completed ? Colors.green.shade50 : Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      challenge.testo,
                      style: TextStyle(
                        fontSize: 15,
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  if (completed)
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '+${challenge.xpReward} XP',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}