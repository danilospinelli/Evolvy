import 'package:flutter/material.dart';

class BarraDiRicerca extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const BarraDiRicerca({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: ("Cerca un alimento..."),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      onSubmitted: onSearch,
    );
  }
}
