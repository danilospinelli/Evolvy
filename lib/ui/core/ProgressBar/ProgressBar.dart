import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double current;
  final double goal;
  final String label;
  final String abbr;
  // Se false, rimuove il riquadro/sfondo azzurro attorno alla barra
  final bool showBackground;
  // Se true, mostra il valore in piccolo a destra della barra invece che grande sopra
  final bool valueOnSide;

  const ProgressBar({
    super.key,
    required this.current,
    required this.goal,
    required this.label,
    required this.abbr,
    this.showBackground = true,
    this.valueOnSide = false,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (current / goal).clamp(0.0, 1.0);

    final bar = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 24,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Colors.green,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: showBackground
          ? BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(18),
            )
          : null,

      child: valueOnSide
          // valueOnSide = true -> versione compatta
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if(label.isNotEmpty)
                  Text(
                   label,
                    style: const TextStyle(
                      fontSize: 22,
                     fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: bar),
                    const SizedBox(width: 12),
                    Text(
                      '$current / $goal $abbr',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            )
          // valueOnSide = false -> versione estesa
          : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(label.isNotEmpty)
                  Text(
                   label,
                   textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                const SizedBox(height: 28),

                Text(
                  '$current / $goal $abbr',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                bar,

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
