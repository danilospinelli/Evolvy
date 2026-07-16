import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 1. Diventa Stateful per gestire la propria memoria RAM
class InputQuantita extends StatefulWidget {
  final String valoreIniziale; // Riceve il valore di partenza, non il controller
  final ValueChanged<String> onChanged;

  const InputQuantita({
    super.key,
    required this.valoreIniziale,
    required this.onChanged,
  });

  @override
  State<InputQuantita> createState() => _InputQuantitaState();
}

class _InputQuantitaState extends State<InputQuantita> {
  // 2. Il controller è privato e protetto qui dentro
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 3. Si accende usando il valore passato dal genitore (es. "100" o la quantità vecchia)
    _controller = TextEditingController(text: widget.valoreIniziale);
  }

  @override
  void dispose() {
    // 4. Salva la memoria del telefono spegnendosi
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      // Abilita esplicitamente la punteggiatura sulla tastiera del telefono
      keyboardType: const TextInputType.numberWithOptions(decimal: true), 
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
        hintText: '100', // Modificato: rimosso il "g" visto che l'unità è di fianco
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.3)),
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
      onChanged: widget.onChanged,
    );
  }
}