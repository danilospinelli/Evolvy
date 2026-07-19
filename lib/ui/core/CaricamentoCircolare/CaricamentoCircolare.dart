import 'package:flutter/material.dart';

//Questo Widget rappresenta la barra circolare di caricamento.
//Lo chiamiamo qunado si devono aspettare dei caricamenti di dati ad esempio.

class CaricamentoCircolare extends StatelessWidget {
  const CaricamentoCircolare({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}