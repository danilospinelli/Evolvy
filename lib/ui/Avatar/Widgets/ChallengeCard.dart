import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/SnackBarInfo/SnackBarInfo.dart';
import 'package:flutter_application_1/domain/models/ObiettivoModel.dart';

// Widget che rappresenta una singola riga obiettivo.

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({super.key, required this.challenge});

  final Obiettivo challenge;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<Avatar_ViewModel>();

    //Estraiamo lo stato della challenge.
    final completed = challenge.completed;

    //InkWell è molto simile a Gesture ma genera una piccola animazione al tocco.
    return InkWell(
      onTap: (completed || vm.isUpdatingObjective)
          ? null
          : () async {
              int nLivelli = await vm.completaObiettivo(challenge);
              //Context.mounted ci stampa la snackbar solo se siamo ancora in quel contesto e la chiamata asincrona è ok.
              if (context.mounted) {
                SnackBarInfo.xpGain(context, challenge.xpReward, nLivelli);
              }
            },
      borderRadius: BorderRadius.circular(30),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(30),
                //Feedback cromatico istantaneo basato sullo stato 'completed'.
                color: completed ? Colors.green.shade50 : Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      challenge.testo,
                      style: TextStyle(
                        fontSize: 15,
                        //Barratura dinamica del testo per indicare la risoluzione del task.
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                  if (completed)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
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
