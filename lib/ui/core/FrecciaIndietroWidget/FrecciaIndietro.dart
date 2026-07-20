import 'package:flutter/material.dart';

//Questo Widget è la freccia indietro in alto a sinistra nelle pagine, condivisa da praricamente tutti.

class FrecciaIndietro extends StatelessWidget {
  final Color coloreIcona;
  const FrecciaIndietro({super.key, this.coloreIcona = Colors.black});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: coloreIcona),
      onPressed: () {
        Navigator.maybePop(context);
      },
    );
  }
}