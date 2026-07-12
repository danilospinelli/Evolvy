import 'package:flutter/material.dart';

class SnackBarInfo extends SnackBar {
  final String message;
  final IconData icon;
  final Color color;

  // Costruttore privato, così si deve perforza passare per show
  SnackBarInfo._({
    required this.message,
    required this.icon,
    required this.color,
  }) : super(
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
          content: Row(
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );

  // Metodo da richiamare per creare la SnackBar
  static void show(
    BuildContext context, {
    required String message,
    required IconData icon,
    required Color color,
  }) {
    // 1. Svuota la coda delle SnackBar (evita accumulo)
    ScaffoldMessenger.of(context).clearSnackBars();

    // 2. Mostra la SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBarInfo._(
        message: message,
        icon: icon,
        color: color,
      ),
    );
  }
}