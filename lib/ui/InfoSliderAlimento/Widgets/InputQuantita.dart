import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Widget della barra di inserimento per la quantità dei cibi da inserire.
//Lo abbiamo reso statefull perche la barra di input deve gestirsi da sola il controller
//Lo inizializza all'inizio e poi fa dispose per toglierlo dalla memoria.

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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    //inizializzato a 100g
    _controller = TextEditingController(text: widget.valoreIniziale);
  }

  //Per rimuovere il controller dalla memoria Ram.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    //Il widget TextField non è un semplice contenitore ma gestisce cursore, copia e incolla e così via
    //perfetto per un box di inserimento.
    return TextField(
      controller: _controller,
      //Dovrebbe mostrare solo il tastierino numerico.
      keyboardType: TextInputType.number,
      inputFormatters: [
        //Impedisce l'immissione di lettere e le limita a 4.
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
      ],
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),

      //Permette di decorare il tasto.
      decoration: InputDecoration(
        hintText: '100', // Modificato: rimosso il "g" visto che l'unità è di fianco. Veramente lieve come se fosse un suggerimento.
        hintStyle: TextStyle(color: Colors.grey.withOpacity(0.3)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        //Disegna un leggero outline alla barra di ricerca
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        //Disegna un leggero outline alla barra di ricerca quando l'utente ci interagisce.
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Colors.deepOrangeAccent,
            width: 2.0,
          ),
        ),
      ),
      //Notifichiamo il widget chiamante, in questo caso la View, che è cambiato stato.
      onChanged: widget.onChanged,
    );
  }
}