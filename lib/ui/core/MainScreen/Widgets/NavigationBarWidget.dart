import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/ui/core/MainScreen/ViewModel/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/core/utils/AvatarColors.dart';

//Widget che rappresenta la barra di navigazione in basso
//é stateless per gli stessi motivi di prima, reagisce a cambiamenti di parametri delegati al ViewModel.

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {

    // Colore scelto, esattamente come nella View ridisegnamo con watch appena cambia.
    final chosenColor = context.watch<Avatar_ViewModel>().user?.chosenColor ?? 0;

    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: avatarColors[chosenColor], 
        indicatorColor: Colors.white.withOpacity(0.25),
        //WidgetStateProprety gestisce automaticamente i vari microstati dei bottoncini della barra sotto
        //Ci evita di rendere tutta la pagina stateful. Per esempio se passiamo sopra all'icona restituisce al volo quel microstato.
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 12,
            );
          }
          return TextStyle(
            color: Colors.white.withOpacity(0.7), 
            fontSize: 12,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Colors.white);
          }
          return IconThemeData(color: Colors.white.withOpacity(0.7));
        }),
      ),

      //Le 4 icone della NavigationBar
      child: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.trending_up), label: 'Progressi'),
          NavigationDestination(icon: Icon(Icons.local_fire_department), label: 'Avatar'),
          NavigationDestination(icon: Icon(Icons.emoji_events), label: 'Global Ranking'),
        ],
        //l'indice che prendiamo dal ViewModel.
        selectedIndex: context.watch<MainScreen_ViewModel>().currentPageIndex,
        onDestinationSelected: (int index) {
          //Aggiorna l'indice della pagina selezionata nel ViewModel
          context.read<MainScreen_ViewModel>().setCurrentPageIndex(index);
        },
      ),
    );
  }
}