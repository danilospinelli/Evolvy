import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ObiettiviSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/AvatarSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ProfileHeader.dart';

class Avatar_View extends StatelessWidget {
  const Avatar_View({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<Avatar_ViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Caricamento fallito o dati assenti: mostra il motivo invece di crashare
    if (vm.user == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              vm.error ?? 'Impossibile caricare i dati del profilo.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    final user = vm.user!;
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // --- Blocco in alto: profilo
          ProfileHeader(
            user: user,
          ),
          const SizedBox(height: 24),
          // --- Blocco in mezzo: avatar
          AvatarSection(
            user: user,
          ),
          const SizedBox(height: 32),
          // --- Blocco in basso: sfide giornaliere ---
          ObiettiviSection(
            challenges: user.obiettivi,
          ),
        ],
      ),
    );
  }
}