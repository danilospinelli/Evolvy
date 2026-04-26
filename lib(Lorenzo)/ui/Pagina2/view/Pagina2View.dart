import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../domain/models/FoodModel.dart';
import '../../../domain/models/MealFoodSelectionModel.dart';
import '../viewmodel/Pagina2ViewModel.dart';

class Pagina2View extends StatefulWidget {
  const Pagina2View({required this.food, super.key});

  final FoodModel food;

  @override
  State<Pagina2View> createState() => _Pagina2ViewState();
}

class _Pagina2ViewState extends State<Pagina2View> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: '100');
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _syncQuantityText(int value) {
    final normalizedText = value.toString();
    if (_quantityController.text == normalizedText) return;

    _quantityController.value = TextEditingValue(
      text: normalizedText,
      selection: TextSelection.collapsed(offset: normalizedText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Pagina2ViewModel(food: widget.food),
      child: Scaffold(
        appBar: AppBar(title: Text(widget.food.name)),
        body: Consumer<Pagina2ViewModel>(
          builder: (context, vm, _) {
            _syncQuantityText(vm.quantityGrams);

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${vm.food.name}'),
                  const SizedBox(height: 8),
                  const Text('Valori nutrizionali (base 100g)'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Quantita (g)',
                      helperText:
                          'Inserisci un numero tra ${vm.minQuantity} e ${vm.maxQuantity}',
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final parsed = int.tryParse(value);
                      if (parsed == null) return;
                      vm.setQuantity(parsed);
                    },
                  ),
                  const SizedBox(height: 8),
                  Text('Kcal: ${vm.kcal}'),
                  const SizedBox(height: 8),
                  Text('Proteine: ${vm.proteins.toStringAsFixed(1)} g'),
                  const SizedBox(height: 8),
                  Text('Carboidrati: ${vm.carbs.toStringAsFixed(1)} g'),
                  const SizedBox(height: 8),
                  Text('Grassi: ${vm.fats.toStringAsFixed(1)} g'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final selection = vm.buildSelection();
                        Navigator.pop<MealFoodSelectionModel>(
                          context,
                          selection,
                        );
                      },
                      child: const Text('Salva alimento'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
