import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/MealType_Enum.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/MealBox.dart';
import 'package:flutter_application_1/ui/Homepage/Widgets/DailyRecap.dart';
import 'package:flutter_application_1/ui/core/AvatarCondiviso/AvatarCondiviso.dart';
import 'package:flutter_application_1/ui/QuizPage/View/QuizPage_View.dart';

//Widget generale della Homepage, contiene praticamente lo Scaffold quindi la pagina generale e
//le chiamate a tutti gli altri widget che abbiamo definito come DailyRecap.
class Homepage_View extends StatelessWidget {
  const Homepage_View({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //SingleChildScrollView per rendere la pagina scrollabile ed evitare che i
      //Mealbox espandendosi all'infinito creino problemi.
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Parte superiore con i 3 box Suggerimenti, calorie e Macro.
            DailyRecap(),
            ...MealType_Enum.values.map(
              (meal) => MealBox(mealType: meal),
            ),

            const SizedBox(height: 12),

            //Mascotte che invita al quiz: al tocco apre la QuizPage!
            //(non è più una tab della navigation bar).
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
