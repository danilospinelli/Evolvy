import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double current;
  final double goal;

  const ProgressBar({
    super.key,
    required this.current,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (current / goal).clamp(0.0, 1.0);

    return Container(
      height: 252,
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const Text(
            'Calorie',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 28),

          Text(
            '$current / $goal kcal',
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 24),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),

            child: LinearProgressIndicator(
              value: progress,
              minHeight: 24,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.green,
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            '${(progress * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}