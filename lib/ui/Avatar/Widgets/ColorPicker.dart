import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/utils/AvatarColors.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';

//Widget che gestisce la scelta dei colori sotto la mascotte per permetterti di modificarle l'aspetto.

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
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
      //SingleChildScrollView rende il widget scorrevole al tocco orizzontalmente
      //prevenendo overflow in caso di aggiunta di nuovi colori.
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            //Gestiamo la lista dei colori con una Mappa con indici e colore.
            for (final entry in avatarColors.asMap().entries)
              Padding(
                padding: const EdgeInsets.only(right: 10),
                //GestureDetector per interagire con il tocco. Read per leggere i nuovi colori e aggiornare l'UI.
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