import 'package:flutter/material.dart';


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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // Uso il mio controller interno
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