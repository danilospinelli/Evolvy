import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Per inizializzare le date locali
import 'package:intl/intl.dart';           // Per formattare la data
import 'package:flutter_application_1/ui/core/MainScreen/ViewModel/MainScreen_ViewModel.dart';
import 'package:flutter_application_1/ui/core/MainScreen/Widgets/NavigationBarWidget.dart';
import 'package:flutter_application_1/ui/Homepage/View/Homepage_View.dart';
import 'package:flutter_application_1/ui/Avatar/View/Avatar_View.dart';
import 'package:flutter_application_1/ui/Avatar/ViewModel/Avatar_ViewModel.dart';
import 'package:flutter_application_1/ui/Progress/View/Progress_View.dart';
import 'package:flutter_application_1/ui/GlobalRanking/View/GlobalRanking_View.dart';
import 'package:flutter_application_1/ui/core/utils/AvatarColors.dart';

// E' il wrap delle 4 pagine principali
// E' Stateless perché la modifica allo stato parte da NavigationBarWidget, non è uno stato locale
class MainScreen_View extends StatelessWidget {
  const MainScreen_View({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('it_IT', null);
    
    final String formattedDate = DateFormat('EEEE dd MMMM', 'it_IT').format(DateTime.now());
    final String capitalizedDate = formattedDate.isNotEmpty 
        ? '${formattedDate[0].toUpperCase()}${formattedDate.substring(1)}' 
        : formattedDate;

    // Lista delle pagine per IndexedStack
    final pages = [
      const Homepage_View(),
      const Progress_View(),
      const Avatar_View(),
      const GlobalRanking_View(),
    ];

    // Colore scelto
    final chosenColor = context.watch<Avatar_ViewModel>().user?.chosenColor ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          capitalizedDate,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: avatarColors[chosenColor],
        elevation: 2,
        centerTitle: true,
      ),
      bottomNavigationBar: const NavigationBarWidget(), 
      // Ricostruisci solo il body, il title e la NavigationBar rimangono
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