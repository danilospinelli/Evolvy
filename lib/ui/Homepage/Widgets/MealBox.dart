import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/ViewModel/Homepage_ViewModel.dart';
import 'package:flutter_application_1/ui/RicercaCibi/View/RicercaCibi_View.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/InsertedFood.dart';
import 'package:flutter_application_1/ui/core/CaricamentoCircolare/CaricamentoCircolare.dart';

//widget che rappresenta il pasto espandibile dal quale si possono aggiungere anche i cibi con il +.
//é stateful perchè deve gestirsi lo stato di espansione e compressione all'interno della pagina.

class MealBox extends StatefulWidget {
  const MealBox({super.key, required this.mealType});

  final MealType_Enum mealType;

  @override
  State<MealBox> createState() => _MealBox_ViewState();
}

class _MealBox_ViewState extends State<MealBox> {

//Stato di MealBox. False se non è aperto
bool isExpanded = false; 

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          //BOX PRINCIPALE
          //Ancora una volta Material per piccole accortezze grafiche.
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            //InkWell per i tap dell'utente e piccole animazioni al tocco.
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                setState(() {
                  //Cambiamento di stato! Quando l'utente clicca si apre la tendina.
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  //spaceBetween per distanziare gli elementi sulla mealBox
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          //Icona del pasto.
                          context.read<Homepage_ViewModel>().mealTypeIcon(widget.mealType),
                          size: 30,
                        ),

                        const SizedBox(width: 10),

                        Text(
                          //Con lo split prendiamo solo il nome dell'enum. Ad esempio enum.colazione = colazione.
                          widget.mealType.toString().split('.').last,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    //Se vogliamo aggiungere un cibo clicchiamo e andiamo alla schermata di Ricerca!
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
          //AnimatedCrossFade ci permette di far comparire il widget (in questo caso InsertedFood) con una piccola
          //animazione nativa di flutter.
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: isExpanded
                //In Base allo stato mostriamo la versione espansa o no.
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,

            //La scatola chiusa. Non occupa spazio.
            firstChild: const SizedBox(),

            //La scatola aperta quando clicchiamo da chiusa.
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

              //Consumer per aggiornare la lista dei cibi inseriti in tempo reale. Non ricostruisce tutta la pagina
              //ma solo questo pezzetto.
              child: Consumer<Homepage_ViewModel>(
                builder: (context, vm, child) { 
                  //Solo i cibi del pasto specifico.
                  final foods = vm.foodsByMeal(widget.mealType);

                  return vm.isLoading
                      ? const Center(child: CaricamentoCircolare())
                      : foods.isEmpty
                          ? const Text('Nessun cibo caricato')
                          : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: foods.map((f) {
                            //Chiamiamo il nostro Widget Inserted food.
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