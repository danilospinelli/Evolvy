import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_View.dart';
import 'package:flutter_application_1/ui/core/FrecciaIndietroWidget/FrecciaIndietro.dart';
import 'RicercaCibi_ViewModel.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarCode.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/BarraDiRicerca.dart';
import 'package:flutter_application_1/ui/RicercaCibi/Widgets/ListaRisultati.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/domain/models/MealType_Enum.dart';

class RicercaView extends StatefulWidget {
  final MealType_Enum mealType;

  const RicercaView({super.key, required this.mealType});

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
                    controller: _controller,
                    onSearch: (testo) {
                      _viewModel.cercaCibi(testo);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                BarCode(
                  onPressed: () {
                    // TODO: inserire funzionalità scansione QR code
                    print("Scansione QR code");
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            Expanded(
              flex: 3,
              child: ListaRisultati(
                viewModel: _viewModel,
                mealType: widget.mealType,
              ),
            ),

            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: AvatarCondiviso(
                  messaggio: "Ciao!, cerchiamo qualcosa da mangiare!",
                  onTap: () {
                    // TODO: attenzione a stack overflow
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Homepage_View(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
