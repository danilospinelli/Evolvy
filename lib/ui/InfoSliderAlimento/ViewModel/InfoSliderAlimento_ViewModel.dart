import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';

class InfoSliderAlimento_ViewModel extends ChangeNotifier {
  // Gestione del controller nel ViewModel
  
  var _quantitaInserita = 100.0;
  var _unitaMisura = "g";
  final List<String> unitaDisponibili = ['g', 'ml', 'kg', 'l'];

  // Inizializzazione del controller
  void init(LoggedFood? ciboGiaLoggato) {
    if (ciboGiaLoggato != null) {
      final vecchiaQuantita = ciboGiaLoggato.quantita.round().toString();
      
      aggiornaQuantita(vecchiaQuantita);
    }
  }


  double get quantita => _quantitaInserita;
  String get unita => _unitaMisura;

  //gestisce le varie unita di misura
  double get _quantitaBaseNormalizzata {
    if (_unitaMisura == 'kg' || _unitaMisura == 'l') {
      return _quantitaInserita * 1000;
    }
    return _quantitaInserita;
  }

  //calcola le calorie per quella quantita di alimento
  double calcolaKcal(FoodModel alimento) {
    final base = alimento.kcalper100;
    return ((base / 100) * _quantitaBaseNormalizzata);
  }

  //calcola le proteine per quella quantita di alimento
  double calcolaProt(FoodModel alimento) {
    final base = alimento.protper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  //calcola i carboidrati per quella quantita di alimento
  double calcolaCarb(FoodModel alimento) {
    final base = alimento.carbper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  //calcola i grassi per quella quantita di alimento
  double calcolaGras(FoodModel alimento) {
    final base = alimento.grasper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  void aggiornaQuantita(String testo) {
    if (testo.trim().isEmpty) {
      _quantitaInserita = 0.0;
    } else {
      _quantitaInserita = double.tryParse(testo.replaceAll(',', '.')) ?? 0.0;
    }
    notifyListeners();
  }

  void cambiaUnita(String? nuovaUnita) {
    if (nuovaUnita != null && nuovaUnita != _unitaMisura) {
      _unitaMisura = nuovaUnita;
      notifyListeners();
    }
  }

  
  LoggedFood generaCiboLoggato(FoodModel alimento) {
    return LoggedFood(
      nome: alimento.nome,
      quantita: _quantitaBaseNormalizzata,
      calorie: calcolaKcal(alimento),
      carboidrati: calcolaCarb(alimento),
      proteine: calcolaProt(alimento),
      grassi: calcolaGras(alimento),
    );
  }
}