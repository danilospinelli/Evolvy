import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/MainScreen/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/core/NavigationBarWidget_View/NavigationBarWidget_View.dart';

// Contiene tutti i widget della Homepage
class MainScreen_View extends StatefulWidget {
  const MainScreen_View({super.key});

  @override
  State<MainScreen_View> createState() => _MainScreen_ViewState();
}

class _MainScreen_ViewState extends State<MainScreen_View> {
  final MainScreen_ViewModel _viewModel = MainScreen_ViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${DateTime.now().day}/${DateTime.now().month}'),
      ),
      bottomNavigationBar: NavigationBarWidget_View(
        selectedIndex: _viewModel.getCurrentPageIndex(),
        onPageSelected: (index) {
          setState(() {
            _viewModel.setCurrentPageIndex(index);
          });
        },
      ),
      body: _viewModel.getPageByIndex(_viewModel.getCurrentPageIndex()),
    );
  }
}