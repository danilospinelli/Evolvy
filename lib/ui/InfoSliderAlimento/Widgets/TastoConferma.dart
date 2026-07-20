import 'package:flutter/material.dart';

//Widget puramente grafico del tasto OK. Non presenta logica ma solo UI, in questo modo
//Potrebbe anche essere riutulizzato in futuro.

class TastoConferma extends StatelessWidget {
  final VoidCallback onPressed;

  const TastoConferma({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    //Widget per un Bottone in sovraimpressione.
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(16),
        elevation: 4,
      ),
      //Delega la logica del "cliccaggio" al genitore.
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
