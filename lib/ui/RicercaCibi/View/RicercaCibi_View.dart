import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/ui/RicercaCibi/ViewModel/RicercaCibi_ViewModel.dart';
import 'package:flutter_application_1/data/repositories/FoodRepository.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarCode.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarraDiRicerca.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/ListaRisultati.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

//Widget generale della pagina di ricerca dell'applicazione. Costruisce lo Scaffold generale e
//chiama altri widget esterni come Barra di Ricerca o Lista risultati.

class RicercaView extends StatelessWidget {
  final MealType_Enum mealType;

  const RicercaView({
    super.key, 
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider. qui e non multiprov. Creiamo questa pagina solo quando è raggiunta dalla homepage.
    return ChangeNotifierProvider(
      create: (_) => RicercaCibi_ViewModel(FoodRepository()),
      child: Builder(
        builder: (context) {
          final viewModel = context.watch<RicercaCibi_ViewModel>();

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            appBar: AppBar(
              title: const Text('Ricerca Alimenti'),
              leading: const FrecciaIndietro(coloreIcona: Colors.blue),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        //Chiamiamo la barra di ricerca per effettuarla. Expanded sulla row ci permette di utilizzare tutto
                        //lo spazio rimanente.
                        child: BarraDiRicerca(
                          onSearch: (testo) {
                            viewModel.cercaCibi(testo);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      BarCode(
                        //TODO
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    //Widget nostro esterno che viene generato dalla ricerca. Expanded lo confina nello spazio rimanente in verticale.
                    child: ListaRisultati(
                      viewModel: viewModel,
                      mealType: mealType,
                    ),
                  ),

                  const SizedBox(height: 12),
                  
                  //Avatar in basso.
                  const AvatarCondiviso(
                    messaggio: "Ciao!, cerchiamo qualcosa da mangiare!",
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}