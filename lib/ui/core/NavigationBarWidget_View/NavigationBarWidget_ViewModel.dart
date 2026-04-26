class NavigationBarWidget_ViewModel {
  int _currentPageIndex = 0;

  int getCurrentPageIndex() {
    return _currentPageIndex;
  }

  void setCurrentPageIndex(int index) {
    _currentPageIndex = index;
  }
}