import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'package:flutter_application_1/ui/RicercaCibi/ViewModel/RicercaCibi_ViewModel.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarCode.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarraDiRicerca.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/ListaRisultati.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

class RicercaView extends StatelessWidget {
  final MealType_Enum mealType;

  const RicercaView({
    super.key, 
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider per rendere disponibile il ViewModel a tutti i widget ed inizializzarlo
    return ChangeNotifierProvider(
      create: (_) => RicercaCibi_ViewModel(),
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
                        child: BarraDiRicerca(
                          controller: viewModel.searchController,
                          onSearch: (testo) {
                            viewModel.cercaCibi(testo);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      BarCode(
                        // TODO: inserire funzionalità scansione QR code
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Expanded(
                    child: ListaRisultati(
                      viewModel: viewModel,
                      mealType: mealType,
                    ),
                  ),

                  const SizedBox(height: 12),

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