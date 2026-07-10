import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';

/// Blocco centrale: avatar + icona shop, e riga di selezione colore mascotte.
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
              // TODO: CAMBIO SCHERMATA TASTO PER LO SHOP (CLAUDE FAI CHE PREMENDO SULL'ICONA CAMBIA SCHERMATA MA è VUOTA)
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
        _ColorPicker(
          chosen_color: user.chosen_color,
        ),
      ],
    );
  }
}

class _ColorPicker extends StatelessWidget {
  _ColorPicker({
    required this.chosen_color,
  });

  final int chosen_color;
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
                onTap: () => context.read<Avatar_ViewModel>().aggiornaColore(colors.indexOf(color)),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colors[chosen_color] == color
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
