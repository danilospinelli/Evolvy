import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';

class ObiettiviSection extends StatelessWidget {
  const ObiettiviSection({
    super.key,
    required this.challenges,
  });

  final List<Obiettivo> challenges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I tuoi obiettivi:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        for (final challenge in challenges) ...[
          _ChallengeCard(
            challenge: challenge,
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({required this.challenge});

  final Obiettivo challenge;

  @override
  Widget build(BuildContext context) {
    final completed = challenge.completed;

    return InkWell(
      onTap: completed ? null : () => context.read<Avatar_ViewModel>().completaObiettivo(challenge),
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
                      challenge.title,
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
