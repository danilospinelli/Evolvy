import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/MealFoodSelectionModel.dart';
import '../../Pagina2/view/Pagina2View.dart';
import '../viewmodel/Pagina1ViewModel.dart';

// Questa classe rappresenta la schermata (view) di Pagina 1.
// E StatelessWidget: non salva stato interno, usa quello del ViewModel.
class Pagina1View extends StatelessWidget {
  const Pagina1View({super.key, this.targetMealLabel});

  final String? targetMealLabel;

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider crea e rende disponibile il ViewModel ai widget figli.
    return ChangeNotifierProvider(
      // Creo il ViewModel e avvio subito il caricamento dati con ..loadFoods().
      create: (_) => Pagina1ViewModel()..loadFoods(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            targetMealLabel == null
                ? 'Pagina 1'
                : 'Scegli alimento per $targetMealLabel',
          ),
        ),
        // Consumer ascolta i cambi del ViewModel e ricostruisce questa parte di UI.
        body: Consumer<Pagina1ViewModel>(
          builder: (context, vm, _) {
            // Se la lista e vuota mostro un messaggio semplice.
            if (vm.foods.isEmpty) {
              return const Center(child: Text('Nessun cibo trovato'));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: vm.setQuery,
                    decoration: const InputDecoration(
                      hintText: 'Cerca alimento',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: vm.filteredFoods.isEmpty
                      ? const Center(child: Text('Nessun risultato'))
                      : ListView.builder(
                          itemCount: vm.filteredFoods.length,
                          itemBuilder: (context, index) {
                            final food = vm.filteredFoods[index];
                            // Ogni riga mostra il nome del cibo in posizione index.
                            return ListTile(
                              title: Text(food.name),
                              onTap: () async {
                                final selection =
                                    await Navigator.push<
                                      MealFoodSelectionModel
                                    >(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Pagina2View(food: food),
                                      ),
                                    );

                                if (selection != null && context.mounted) {
                                  if (targetMealLabel != null) {
                                    Navigator.pop<MealFoodSelectionModel>(
                                      context,
                                      selection,
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
