import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputQuantita extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const InputQuantita({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      // Solo numeri interi, al massimo 4 cifre: il valore non può superare 9999
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        hintText: '100g',
        hintStyle: 
        TextStyle(color: Colors.grey.withOpacity(0.3)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.deepOrangeAccent,
            width: 2.0,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
