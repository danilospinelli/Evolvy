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

//E' l'involucro principale delle 4 pagine primarie dell'app.
//E' Stateless perché la modifica allo stato parte da NavigationBarWidget, e viene delegata al viewModel.
//Non è una gestione di stato

class MainScreen_View extends StatelessWidget {
  const MainScreen_View({super.key});

  @override
  Widget build(BuildContext context) {

    //Metodi per supporto lingua (IT) e formattazione della data corrente con "DateTime.now"

    initializeDateFormatting('it_IT', null);
    final String formattedDate = DateFormat('EEEE dd MMMM', 'it_IT').format(DateTime.now());
    final String capitalizedDate = formattedDate.isNotEmpty 
        ? '${formattedDate[0].toUpperCase()}${formattedDate.substring(1)}' 
        : formattedDate;

    // Lista delle pagine per IndexedStack.

    final pages = [
      const Homepage_View(),
      const Progress_View(),
      const Avatar_View(),
      const GlobalRanking_View(),
    ];

    // Colore scelto sincronizzato con l'avatar. Tramite context watch appena l'utente cambia il parametro del colore 
    //della fiammella la main screen si ridisegna.

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
        //il colore scelto prima
        backgroundColor: avatarColors[chosenColor],
        elevation: 2,
        centerTitle: true,
      ),
      bottomNavigationBar: const NavigationBarWidget(), 
      //Consumer ci permette di ricostruire solo il Body se dei parametri dovessero cambiare
      //e non tutto lo Scaffold.
      body: Consumer<MainScreen_ViewModel>(
        // IndexedStack mantiene vive le 4 pagine principali, le gestisce tramite uno stack in memoria e
        //visualizziamo solo quella dell'indice corrente. 
        builder: (context, vm, child) => IndexedStack(
          index: vm.currentPageIndex, 
          children: pages,
        )
      ),
    );
  }
}