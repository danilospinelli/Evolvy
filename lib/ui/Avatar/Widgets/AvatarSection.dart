import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/domain/AvatarColors.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Shop/View/Shop_View.dart';

/// Blocco centrale: avatar, icona shop, selezione colore mascotte.
class AvatarSection extends StatelessWidget {
  const AvatarSection({
    super.key,
    required this.user,
  });

  final AvatarModel user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Mascotte, con l'icona shop in alto a destra
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 190,
              height: 190,
              child: AvatarCondiviso(
                messaggio: '', 
                onTap: () {} // TODO: TOCCO MASCOTTE
              ),
            ),
            Positioned(
              top: 0,
              right: 24,
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Shop_View()),
                ),
                child: const Icon(Icons.storefront, size: 26),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Colore mascotte:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 6),
        _ColorPicker(
          chosen_color: user.chosenColor,
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.chosen_color,
  });

  final int chosen_color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final entry in avatarColors.asMap().entries)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => context.read<Avatar_ViewModel>().aggiornaColore(entry.key),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: entry.key == chosen_color
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
