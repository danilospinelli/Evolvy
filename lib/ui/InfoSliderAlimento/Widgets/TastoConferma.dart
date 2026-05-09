import 'package:flutter/material.dart';

class TastoConferma extends StatelessWidget {
  final VoidCallback onPressed;

  const TastoConferma({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 4,
      ),
      onPressed: onPressed,

      child: const Text(
        'OK',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
