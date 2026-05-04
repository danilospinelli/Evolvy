import 'package:flutter/material.dart';

class NavigationBarWidget_View extends StatefulWidget {
  const NavigationBarWidget_View({super.key, required this.onPageSelected});

  final Function(int) onPageSelected;

  @override
  State<NavigationBarWidget_View> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarWidget_View> {
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