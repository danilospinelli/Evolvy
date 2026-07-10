import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

/// Blocco centrale: avatar + icona shop, e riga di selezione colore mascotte.
class AvatarSection extends StatelessWidget {
  const AvatarSection({
    super.key,
    required this.user,
  });

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Avatar + shop affiancato, shop leggermente in alto a destra
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AvatarCondiviso(
              messaggio: 'Qui puoi personalizzarmi e visualizzare le sfide giornaliere!', 
            ),
            Positioned(
              top: -10,
              right: -10,
              child: const Icon(Icons.storefront, size: 22), 
            ),
          ],
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Colore mascotte:',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
        const SizedBox(height: 6),
        _ColorPickerRow(
          selectedColor: user.selectedMascotColor,
        ),
      ],
    );
  }
}

class _ColorPickerRow extends StatelessWidget {
  _ColorPickerRow({
    required this.selectedColor,
  });

  final Color selectedColor;
  final List<Color> colors = [Colors.orange, Colors.green, Colors.blue, Colors.purple];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ...colors.map(
            (color) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () => , // TODO: AGGIORNARE COLORE E SPRITE MASCOTTE
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == color
                          ? Colors.black
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
