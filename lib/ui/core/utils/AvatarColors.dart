import 'package:flutter/material.dart';

// Colori selezionabili per la mascotte
const List<Color> avatarColors = [
  Colors.orange,
  Colors.green,
  Colors.blue,
  Colors.purple,
];

const List<String> _avatarSprites = [
  'assets/images/fiammella.png',
  'assets/images/fiammella verde.png',
  'assets/images/fiammella blu.png',
  'assets/images/fiammella viola.png',
];

// Restituisce l'immagine della mascotte associato al colore scelto
String avatarSprite(int chosenColor) => _avatarSprites[chosenColor];
