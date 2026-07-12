import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/MainScreen/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_ViewModel.dart';
import 'package:provider/provider.dart';

// Indice della tab Avatar nella lista 'pages' di MainScreen_View
const int _avatarTabIndex = 2;

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Quiz'),
        NavigationDestination(icon: Icon(Icons.fireplace), label: 'Avatar'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Global Ranking'),
      ],
      selectedIndex: context.watch<MainScreen_ViewModel>().currentPageIndex,
      onDestinationSelected: (int index) {
        // Aggiorna l'indice della pagina selezionata nel ViewModel
        context.read<MainScreen_ViewModel>().setCurrentPageIndex(index);
        // L'IndexedStack tiene le pagine vive: ricarica i dati dell'avatar
        // ogni volta che si apre la tab, altrimenti resterebbero quelli
        // caricati all'avvio dell'app (es. exp non aggiornata dopo un quiz)
        if (index == _avatarTabIndex) {
          context.read<Avatar_ViewModel>().initialize();
        }
      },
    );
  }
}