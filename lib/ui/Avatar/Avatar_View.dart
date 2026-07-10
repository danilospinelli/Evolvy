import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ChallengesSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/AvatarSection.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ProfileHeader.dart';

class Avatar_View extends StatelessWidget {
  const Avatar_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Avatar_ViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) { 
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // --- Blocco in alto: profilo + avatar ---
                  ProfileHeader(
                    user: vm.user!,
                  ),
                  const SizedBox(height: 24),
                  AvatarSection(
                    user: vm.user!,
                  ),
                  const SizedBox(height: 32),

                  // --- Blocco in basso: sfide giornaliere ---
                  ChallengesSection(
                    challenges: vm.challenges,
                  ),
                ],
              );
          },
      ),
    );
  }
}