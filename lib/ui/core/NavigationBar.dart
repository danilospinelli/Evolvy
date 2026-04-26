import 'package:flutter/material.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key, required this.onPageSelected});

  final Function(int) onPageSelected;

  @override
  State<NavigationBarWidget> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarWidget> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.auto_graph), label: 'Progressi'),
        NavigationDestination(icon: Icon(Icons.fireplace), label: 'Avatar'),
        NavigationDestination(icon: Icon(Icons.settings), label: 'Global Ranking'),
      ],
      selectedIndex: currentPageIndex,
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          widget.onPageSelected(index);
        });
      },
    );
  }
}