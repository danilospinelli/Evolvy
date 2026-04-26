import 'package:flutter/material.dart';

class NavigationBarWidget_View extends StatelessWidget {
  const NavigationBarWidget_View({
    super.key,
    required this.selectedIndex,
    required this.onPageSelected,
  });

  final int selectedIndex;
  final Function(int) onPageSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Progressi'),
        NavigationDestination(icon: Icon(Icons.fireplace), label: 'Avatar'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Global Ranking'),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onPageSelected,
    );
  }
}