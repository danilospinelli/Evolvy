import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MealBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/DailyRecap.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/QuizPage/View/QuizPage_View.dart';

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

            const SizedBox(height: 12),

            // Mascotte che invita al quiz: al tocco apre la QuizPage
            // (non è più una tab della navigation bar)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: AvatarCondiviso(
                messaggio: 'Ti va di fare un quiz?',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuizPage_View(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
