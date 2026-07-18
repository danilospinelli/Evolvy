import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/Progressbar.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

/// Blocco in alto: nome, barra XP, monete, streak.
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
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isUpdatingName = context.watch<Avatar_ViewModel>().isUpdatingName;
    final xpGoal = widget.user.livello * 10;
    //final xpProgress =
    //    xpGoal == 0 ? 0.0 : (widget.user.exp / xpGoal).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nome + barra XP
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isUpdatingName)
                    // Cambio nome in corso: rotella al posto del solo nome.
                    // La barra XP qui sotto resta visibile.
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      child: CaricamentoCircolare(),
                    )
                  else
                    Expanded(
                      child: TextField(
                      controller: _nameController,
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
                    ),
                ],
              ),
              const SizedBox(height: 6),
              // Barra compatta
              Row(
                children: [
                  Text(
                    'LVL ${widget.user.livello}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ProgressBar(
                      current: widget.user.exp.toDouble(),
                      goal: xpGoal.toDouble(), 
                      label: '', 
                      abbr: 'exp', 
                      showBackground: false,
                      valueOnSide: true
                    )
                  ),
                ],
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
                  '${widget.user.monete}',
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
                Text('${widget.user.streak}gg',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const Icon(Icons.local_fire_department,
                  color: Colors.deepOrange, size: 18),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
