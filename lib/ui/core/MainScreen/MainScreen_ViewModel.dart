import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_View.dart';
import 'package:flutter_application_1/ui/Progress/Progress_View.dart';
import 'package:flutter_application_1/ui/Avatar/Avatar_View.dart';
import 'package:flutter_application_1/ui/GlobalRanking/GlobalRanking_View.dart';

class MainScreen_ViewModel {
  int _currentPageIndex = 0;

  int getCurrentPageIndex() {
    return _currentPageIndex;
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
  }

  Widget getPageByIndex(int index) {
    switch (index) {
      case 0:
        return const Homepage_View();
      case 1:
        return const Progress_View();
      case 2:
        return const Avatar_View();
      case 3:
        return const GlobalRanking_View();
      default:
        return const Homepage_View();
    }
  }
}
