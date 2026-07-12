import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputQuantita extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double maxValue;

  const InputQuantita({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [_MaxValueInputFormatter(maxValue)],
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

// Impedisce di digitare un valore superiore a [max]: se il nuovo testo
// supera la soglia, la modifica viene rifiutata e resta il valore precedente.
class _MaxValueInputFormatter extends TextInputFormatter {
  final double max;

  _MaxValueInputFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final value = double.tryParse(newValue.text.replaceAll(',', '.'));
    if (value != null && value > max) return oldValue;
    return newValue;
  }
}
