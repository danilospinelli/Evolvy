import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/RicercaCibi/RicercaCibi_View.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/InsertedFood.dart';
import 'package:provider/provider.dart';

class MealBox extends StatefulWidget {
  const MealBox({super.key, required this.mealType});

  final MealType_Enum mealType;

  @override
  State<MealBox> createState() => _MealBox_ViewState();
}

class _MealBox_ViewState extends State<MealBox> {
  // Usiamo uno StatefulWidget perché è uno stato interno, che determina il comportamento del widget
  bool isExpanded = false; // Stato di MealBox

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          // BOX PRINCIPALE
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          context.read<Homepage_ViewModel>().mealTypeIcon(widget.mealType),
                          size: 30,
                        ),

                        const SizedBox(width: 10),

                        Text(
                          widget.mealType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RicercaView(mealType: widget.mealType),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // SEZIONE ESPANDIBILE ------------------------------------------------------------------------
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            firstChild: const SizedBox(),

            secondChild: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(blurRadius: 4, color: Colors.black12),
                ],
              ),
              // Consumer per aggiornare la lista dei cibi inseriti in tempo reale, non devi rebuildare tutto
              child: Consumer<Homepage_ViewModel>(
                builder: (context, vm, child) { 
                  final foods = vm.foodsByMeal(widget.mealType);

                  return vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : foods.isEmpty
                          ? const Text('Nessun cibo caricato')
                          : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: foods.map((f) {
                            return InsertedFood(
                              food: f,
                              mealtype: widget.mealType,
                            );
                          }).toList(),
                        );
                }
              )
            ),
          ),
        ],
      ),
    );
  }
}