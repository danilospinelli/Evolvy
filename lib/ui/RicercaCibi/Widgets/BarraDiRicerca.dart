import 'package:flutter/material.dart';

//Barra di ricerca dell'applicazione! é stateful perche esattamente come la barra di inserimento quantità
//deve gestirsi da sola la logica del controller, senza delegarla al VM per liberare memoria dopo l'uso.

class BarraDiRicerca extends StatefulWidget {
  final Function(String) onSearch;

  const BarraDiRicerca({
    super.key,
    required this.onSearch,
  });

  @override
  State<BarraDiRicerca> createState() => _BarraDiRicercaState();
}

class _BarraDiRicercaState extends State<BarraDiRicerca> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  //Per disabilitare il controller dalla Ram.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //TextField ci permette di creare barre interagibili migliori rispetto al tocco dell'utente. Ad esempio il cursore.
    return TextField(
      controller: _controller,
      //InputDecoration ci offre più possibilità grafiche personalizzabili.
      decoration: InputDecoration(
        hintText: ("Cerca un alimento..."),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: widget.onSearch, 
    );
  }
}