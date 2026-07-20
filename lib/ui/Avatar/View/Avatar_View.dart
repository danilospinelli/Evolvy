import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ObiettiviSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/AvatarSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ProfileHeader.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//View della pagina dell'avatar. Questa view crea praticamente solo lo scaffold e delega la visualizzazione
//ai widget come profileheader avatar section etc.

class Avatar_View extends StatelessWidget {
  const Avatar_View({super.key});

  @override
  //Se qualche parametro nel VM cambia watch farà aggiornare in tempo reale la pagina.
  Widget build(BuildContext context) {
    final vm = context.watch<Avatar_ViewModel>();

    //Caricamento iniziale a schermo intero (finché non ho i dati, a prescindere da isLoadingProfile)
    //Praticamente scaffold fatto ad hoc per mostrare solo il CaricamentoCircolare.
    if (vm.user == null) {
      return const Scaffold(
        body: Center(
          child: CaricamentoCircolare(),
        ),
      );
    }



    final user = vm.user!;
    return Scaffold(
      //ListView per incolonnare tutti i nostri widget in maniera pulita e rendere l'intera pagina scrollabile.
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          //Blocco in alto: profilo.
          //La rotella del cambio nome è dentro ProfileHeader, sul solo nome:
          //la barra XP e il resto dell'header restano sempre visibili.
          ProfileHeader(
            user: user,
          ),
          const SizedBox(height: 24),
          
          //Blocco in mezzo: avatar, fiammella e cambio colore.
          AvatarSection(
            user: user,
          ),
          const SizedBox(height: 32),
          
          //Blocco in basso: sfide giornaliere.
          ObiettiviSection(
            challenges: user.obiettivi,
          ),
        ],
      ),
    );
  }
}