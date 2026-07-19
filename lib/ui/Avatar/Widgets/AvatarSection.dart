import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/models/AvatarModel.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Shop/View/Shop_View.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';
import 'package:flutter_application_1/ui/Avatar/Widgets/ColorPicker.dart';


//Widget che rappresenta la sezione centrale della pagina avatar. Da qui viene visualizzata
//fiammella e la scelta dei colori.

class AvatarSection extends StatelessWidget {
  const AvatarSection({
    super.key,
    required this.user,
  });

  final AvatarModel user;

  @override
  Widget build(BuildContext context) {
    //Watch ci serve per i cambi colori della mascotte.
    final vm = context.watch<Avatar_ViewModel>();

    return Column(
      children: [
        // Mascotte, con l'icona shop in alto a destra
        //Lo stack come widget ci permette di ordinare gli elementi in profondità, sovrapponendoli
        //al contrario della Row o della Column
        Stack(
          //Clip none permette ai figli di uscire dai confini fisici di Stack senza essere tagliati.
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 240,
              height: 240,
              //Se stiamo caricando qualcosa mostriamo CaricamentoCircolare, altrimenti la fiamma.
              child: vm.isUpdatingColor ? 
                const Center(child: CaricamentoCircolare()) : 
                const AvatarCondiviso(
                  dimensioneAvatar: 240, 
                ),
            ),
            //Postioned gestisce le coordinate degli elementi nello stack.
            Positioned(
              top: 0,
              right: 24,
              //GestureDetector per permetterci di rilevare tocchi dell'utente.
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
        //Align allinea gli elementi, in questo caso al centrosinistra.
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Colore mascotte:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 6),
        //Chiamata al widget ColorPicker.
        ColorPicker(
          chosen_color: user.chosenColor,
        ),
      ],
    );
  }
}
