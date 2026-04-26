import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealTypes_Enum.dart';
import 'package:flutter_application_1/ui/MealBox/MealBox_View.dart';

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