import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Homepage_ViewModel.dart';

// Contiene tutti i widget della Homepage
class Homepage_View extends StatelessWidget {
  const Homepage_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MealBox_View(mealType: MealTypes_Enum.Colazione), 
          MealBox_View(mealType: MealTypes_Enum.Pranzo), 
          MealBox_View(mealType: MealTypes_Enum.Cena), 
          MealBox_View(mealType: MealTypes_Enum.Altro)],
      )
    );
  }
}


// E' il widget di un singolo box per pasto
class MealBox_View extends StatelessWidget {
  MealBox_View({super.key, required this.mealType});

  final MealTypes_Enum mealType;
  final Mealbox_ViewModel viewmodel = Mealbox_ViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 10, 
          children: [Icon(viewmodel.getMealTypeIcon(mealType),
                    size: 30,
                    ),
                    Text(mealType.toString().split('.').last, 
                    style: const TextStyle(fontSize: 18, 
                    fontWeight: FontWeight.bold)),],
                    ),
          
          IconButton(
            onPressed: () {
              viewmodel.addFood();
            }, 
            tooltip: 'Aggiungi alimento a ' + mealType.toString().split('.').last,
            icon: const Icon(Icons.add)
            )
        ],
      ),
    );
  }
}