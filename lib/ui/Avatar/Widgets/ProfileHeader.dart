import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/ProgressBar.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';

/// Blocco in alto a sinistra/destra: nome, barra XP, monete, streak.
class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final AvatarModel user;

  @override
  State<ProfileHeader> createState() => _ProfileHeader_ViewState();
}

class _ProfileHeader_ViewState extends State<ProfileHeader> {
  // Stato interno
  bool _not_editing_name = true;

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
                  // TODO: TEXT FIELD DEVE MOSTRARE IL NOME
                  TextField(
                    readOnly: _not_editing_name, // Se true, blocca la modifica
                    onTap: () {
                      setState(() {
                        _not_editing_name = false; // Al click, sblocca il campo
                      });
                    },
                    onSubmitted: (nuovoTesto) {
                      setState(() {
                        _not_editing_name = true; // Quando premi "Invio" sulla tastiera, salva e blocca
                        context.read<Avatar_ViewModel>().editName(nuovoTesto);
                      });
                    },
                    decoration: InputDecoration(
                      // Rimuove la linea sotto se è in modalità sola lettura
                      border: _not_editing_name ? InputBorder.none : const UnderlineInputBorder(),
                      suffixIcon: _not_editing_name 
                      ? const Icon(Icons.edit, size: 16) // Mostra una matitina di aiuto
                      : null,
                    ),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ProgressBar(
                current: (context.watch<Avatar_ViewModel>().user!).exp as double, 
                goal: (context.watch<Avatar_ViewModel>().user!).livello * 10, 
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
                  '${(context.watch<Avatar_ViewModel>().user!).monete}',
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
                Text('${(context.watch<Avatar_ViewModel>().user!).streak}gg',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
