import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ObiettiviSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/AvatarSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ProfileHeader.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

class Avatar_View extends StatelessWidget {
  const Avatar_View({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<Avatar_ViewModel>();

    // Caricamento iniziale a schermo intero (finché non ho i dati, a prescindere da isLoadingProfile)
    if (vm.user == null) {
      return const Scaffold(
        body: Center(
          child: CaricamentoCircolare(),
        ),
      );
    }



    final user = vm.user!;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Blocco in alto: profilo
          if (vm.isLoadingProfile)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CaricamentoCircolare()),
            )
          else 
            ProfileHeader(
              user: user,
            ),
          const SizedBox(height: 24),
          
          // Blocco in mezzo: avatar
          AvatarSection(
            user: user,
          ),
          const SizedBox(height: 32),
          
          // Blocco in basso: sfide giornaliere
          ObiettiviSection(
            challenges: user.obiettivi,
          ),
        ],
      ),
    );
  }
}