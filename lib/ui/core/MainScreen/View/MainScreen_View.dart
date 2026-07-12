import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/core/MainScreen/ViewModel/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/core/MainScreen/Widgets/NavigationBarWidget.dart';
import 'package:flutter_application_1/ui/Homepage/View/Homepage_View.dart';
import 'package:flutter_application_1/ui/Avatar/View/Avatar_View.dart';
import 'package:flutter_application_1/ui/Progress/View/Progress_View.dart';
import 'package:flutter_application_1/ui/GlobalRanking/View/GlobalRanking_View.dart';
import 'package:provider/provider.dart';

// E' il wrap delle 4 pagine principali
// E' Stateless perché la modifica allo stato parte da NavigationBarWidget, non è uno stato locale
class MainScreen_View extends StatelessWidget {
  const MainScreen_View({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista delle pagine per IndexedStack
    // La QuizPage non è più una tab: ci si arriva dalla mascotte in Homepage
    final pages = [
      const Homepage_View(),
      const Progress_View(),
      const Avatar_View(),
      const GlobalRanking_View(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('${DateTime.now().day}/${DateTime.now().month}'),
      ),
      bottomNavigationBar: NavigationBarWidget(), 
      body: Consumer<MainScreen_ViewModel>(
        // IndexedStack mantiene vive le 4 pagine principali, evita di ricrearle da zero ogni volta
        builder: (context, vm, child) => IndexedStack(
          index: vm.currentPageIndex, 
          children: pages,
        )
      ),
    );
  }
}
