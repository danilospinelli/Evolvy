import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/ProgressBar/Progressbar.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//Widget che gestisce tutta la sezione in alto della pagina dell'avatar.
//dalla barra esperienza al cambio nome alla visualizzazione di exp monete e streak.
//é stateful per gestire correttamente lo stato di visualizzazione nome e scrittura nuovo nome.

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

  //Stato interno sulla riga del nome della mascotte.
  bool _not_editing_name = true;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
  }

  //essenziale per disallocare memoria al controller quando non lo si usa piu.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Vediamo con Watch se si sta aggiornando il nome per la gestione dello stato.
    final bool isUpdatingName = context.watch<Avatar_ViewModel>().isUpdatingName;
    //Leggera logica di gamification, ogni livello necessita di 10 punti esperienza in piu.
    final xpGoal = widget.user.livello * 10;
  
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Nome + barra XP
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isUpdatingName)
                    //Cambio nome in corso: rotella al posto solo del nome.
                    //La barra XP qui sotto resta visibile.
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                      child: CaricamentoCircolare(),
                    )
                  else
                    Expanded(
                      child: TextField(
                      controller: _nameController,
                      readOnly: _not_editing_name, //Se true, blocca la modifica
                      onTap: () {
                        setState(() {
                          _not_editing_name = false; //Al click, sblocca il campo
                        });
                      },
                      onSubmitted: (nuovoTesto) {
                        setState(() {
                          _not_editing_name = true; //Quando premi "Invio" sulla tastiera, salva e blocca.
                          //Chiama poi il viewModel per cambiare il nome.
                          context.read<Avatar_ViewModel>().editName(nuovoTesto);
                        });
                      },
                      decoration: InputDecoration(
                        //Rimuove la linea sotto il nome se è in modalità sola lettura
                        border: _not_editing_name ? InputBorder.none : const UnderlineInputBorder(),
                        suffixIcon: _not_editing_name
                        ? const Icon(Icons.edit, size: 16) //Mostra una matitina di aiuto
                        : null,
                      ),
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),

              //Barra compatta
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
                    //Chiamiamo la nostra ProgressBar con valueOnSide True per la versione compatta.
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

        //Monete e streak
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
