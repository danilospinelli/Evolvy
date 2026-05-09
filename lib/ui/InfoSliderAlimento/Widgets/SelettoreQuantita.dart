import 'package:flutter/material.dart';

class SelettoreQuantita extends StatelessWidget {
  final String valoreAttuale;
  final List<String> opzioni;
  final ValueChanged<String?> onChanged;

  const SelettoreQuantita({
    super.key,
    required this.valoreAttuale,
    required this.opzioni,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400, width: 1.5),
      ),

      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: valoreAttuale,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.blue),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          items: opzioni.map((String singolaUnita) {
            return DropdownMenuItem<String>(
              value: singolaUnita,
              child: Text(singolaUnita),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }
}
