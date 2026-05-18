import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MealBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/DailyRecap.dart';

class Homepage_View extends StatelessWidget {
  const Homepage_View({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DailyRecap(),

            MealBox(mealType: MealType_Enum.Colazione),
            MealBox(mealType: MealType_Enum.Pranzo),
            MealBox(mealType: MealType_Enum.Cena),
            MealBox(mealType: MealType_Enum.Spuntino),
          ],
        ),
      ),
    );
  }
}
