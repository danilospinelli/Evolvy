import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';

class RigaAlimento extends StatelessWidget {
  final Food alimento;
  final VoidCallback onTap;

  const RigaAlimento({super.key, required this.alimento, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                alimento.nome ?? 'Alimento senza nome',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),

            Text(
              '${alimento.kcalper100 ?? 0} kcal/100g',
              style: TextStyle(
                fontSize: 15,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
