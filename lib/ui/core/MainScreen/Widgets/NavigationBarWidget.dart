import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/MainScreen/MainScreen_ViewModel.dart';
import 'package:provider/provider.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Progressi'),
        NavigationDestination(icon: Icon(Icons.fireplace), label: 'Avatar'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Global Ranking'),
      ],
      selectedIndex: context.watch<MainScreen_ViewModel>().currentPageIndex,
      onDestinationSelected: (int index) {
        // Aggiorna l'indice della pagina selezionata nel ViewModel
        context.read<MainScreen_ViewModel>().setCurrentPageIndex(index);
      },
    );
  }
}