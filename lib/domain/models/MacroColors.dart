import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/MacroType_Enum.dart';

// Restituisce il colore associato a un macronutriente
Color macroColor(MacroType_Enum type) {
  switch (type) {
    case MacroType_Enum.Proteine:
      return Colors.orange;

    case MacroType_Enum.Carboidrati:
      return Colors.blue;

    case MacroType_Enum.Grassi:
      return Colors.redAccent;

    case MacroType_Enum.Calorie:
      return Colors.green;
  }
}