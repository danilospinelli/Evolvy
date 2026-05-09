import 'package:flutter/material.dart';
import 'RigaNutriente.dart';

class RiquadroNutrizonale extends StatelessWidget {
  final List<RigaNutriente> nutrienti;

  const RiquadroNutrizonale({super.key, required this.nutrienti});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  "Valori Nutrizionali",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: Scrollbar(
              child: ListView(
                shrinkWrap: true, 
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: nutrienti,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
