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
    return Scaffold(
      body: vm.isLoading ?
              const Center(child: CircularProgressIndicator()) :

              ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // --- Blocco in alto: profilo
                  ProfileHeader(
                    user: vm.user!,
                  ),
                  const SizedBox(height: 24),
                  // --- Blocco in mezzo: avatar
                  AvatarSection(
                    user: vm.user!,
                  ),
                  const SizedBox(height: 32),
                  // --- Blocco in basso: sfide giornaliere ---
                  ObiettiviSection(
                    challenges: (vm.user!).obiettivi,
                  ),
                ],
              )
    );
  }
}