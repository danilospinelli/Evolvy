import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'RicercaCibi_ViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarCode.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarraDiRicerca.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/ListaRisultati.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';

class RicercaView extends StatefulWidget {
  const RicercaView({super.key});

  @override
  State<RicercaView> createState() => _RicercaViewState();
}

class _RicercaViewState extends State<RicercaView> {
  final RicercaViewModel _viewModel = RicercaViewModel();
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Ricerca Alimenti'),
        leading: const FrecciaIndietro(coloreIcona: Colors.black),
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
                    controller: _controller,
                    onSearch: (testo) {
                      _viewModel.cercaCibi(testo);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                BarCode(
                  onPressed: () {
                    print("Scansione QR code");
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(flex: 3, child: ListaRisultati(viewModel: _viewModel)),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: AvatarCondiviso(
                  messaggio: "ciccione",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
