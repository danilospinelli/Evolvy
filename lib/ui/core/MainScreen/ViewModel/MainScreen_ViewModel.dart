import 'package:flutter/material.dart';

class MainScreen_ViewModel extends ChangeNotifier {
  int _currentPageIndex = 0; // Stato: indice della pagina attualmente visualizzata

  int get currentPageIndex => _currentPageIndex;

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }
}
