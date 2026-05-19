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

            ...MealType_Enum.values.map(
              (meal) => MealBox(mealType: meal),
            ),
          ],
        ),
      ),
    );
  }
}
