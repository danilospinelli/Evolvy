import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/ProgressBar.dart';

/// Blocco in alto a sinistra/destra: nome, barra XP, monete, streak.
class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final UserProfile user;

  @override
  State<ProfileHeader> createState() => _ProfileHeader_ViewState();
}

class _ProfileHeader_ViewState extends State<ProfileHeader> {

  bool _not_editing = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome + barra XP (occupa lo spazio rimanente)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  TextField(
                    readOnly: _not_editing, // Se true, blocca la modifica
                    onTap: () {
                      setState(() {
                        _not_editing = false; // Al click, sblocca il campo
                      });
                    },
                    onSubmitted: (nuovoTesto) {
                      setState(() {
                        _not_editing = true; // Quando premi "Invio" sulla tastiera, salva e blocca
                        // TODO: SALVA LA MODIFICA IN DB
                      });
                    },
                    decoration: InputDecoration(
                      // Rimuove la linea sotto se è in modalità sola lettura
                      border: _not_editing ? InputBorder.none : const UnderlineInputBorder(),
                      suffixIcon: _not_editing 
                      ? const Icon(Icons.edit, size: 16) // Mostra una matitina di aiuto
                      : null,
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ProgressBar(
                current: widget.user.currentXp, 
                goal: widget.user.level * 10, 
                label: 'Esperienza', 
                abbr: 'exp', 
              )
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Monete e streak
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Text(
                  '${widget.user.coins}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.monetization_on, color: Colors.amber),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Streak:', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.local_fire_department,
                    color: Colors.deepOrange, size: 18),
                Text('${widget.user.streakDays}gg',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
