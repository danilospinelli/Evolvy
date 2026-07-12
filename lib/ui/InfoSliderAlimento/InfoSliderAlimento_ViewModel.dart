import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';

class InfoSliderAlimento_ViewModel extends ChangeNotifier {
  final Food alimento;

  // Quantità massima inseribile, espressa in grammi/millilitri
  static const double _maxQuantitaGrammi = 9999;

  var _quantitaInserita = 0.0;
  var _unitaMisura = "g";
  final List<String> unitaDisponibili = ['g', 'ml', 'kg', 'l'];

  InfoSliderAlimento_ViewModel({required this.alimento});

  double get quantita => _quantitaInserita;
  String get unita => _unitaMisura;

  // Massimo inseribile nell'unità di misura attualmente selezionata
  // (per kg/l va diviso per 1000 perché _quantitaBaseNormalizzata moltiplica per 1000)
  double get maxQuantita => (_unitaMisura == 'kg' || _unitaMisura == 'l')
      ? _maxQuantitaGrammi / 1000
      : _maxQuantitaGrammi;

  double get _quantitaBaseNormalizzata {
    if (_unitaMisura == 'kg' || _unitaMisura == 'l') {
      return _quantitaInserita * 1000;
    }
    return _quantitaInserita;
  }

  int get kcalCalcolate {
    final base = alimento.kcalper100 ?? 0.0;
    return ((base / 100) * _quantitaBaseNormalizzata).round();
  }

  double get protCalcolate {
    final base = alimento.protper100 ?? 0.0;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  double get carbCalcolate {
    final base = alimento.carbper100 ?? 0.0;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  double get grasCalcolati {
    final base = alimento.grasper100 ?? 0.0;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  double get sodCalcolati {
    final base = alimento.sodper100 ?? 0.0;
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

  LoggedFood generaCiboLoggato() {
    return LoggedFood(
      nome: alimento.nome ?? 'alimento sconosciuto',
      quantita: _quantitaBaseNormalizzata,
      calorie: kcalCalcolate.toDouble(),
      carboidrati: carbCalcolate,
      proteine: protCalcolate,
      grassi: grasCalcolati,
    );
  }
}
