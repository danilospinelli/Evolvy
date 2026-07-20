import 'package:flutter/material.dart';

//widget solo estetico rappresentante un barcode.

class BarCode extends StatelessWidget {
  final VoidCallback onPressed;

  const BarCode({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: IconButton(
        icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }
}
