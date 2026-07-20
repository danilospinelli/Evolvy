import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/models/FoodModel.dart';
import 'package:flutter_application_1/domain/models/LogMealModel.dart';

//ViewModel per la gestione della pagina InfoSLiderAlimento, ovvero quella pagina in cui hai le info per
//una certa grammatura di prodotto e il selezionatore per modificarne le quantità.

class InfoSliderAlimento_ViewModel extends ChangeNotifier {
  //Double per correttezza. Valore base visualizzato prima dell'aggiunta = 100g. Unità predefinita g.
  var _quantitaInserita = 100.0;
  var _unitaMisura = "g";
  final List<String> unitaDisponibili = ['g', 'ml', 'kg', 'l'];

  //Prende in considerazione le vecchie quantità per l'update.
  void init(LoggedFood? ciboGiaLoggato) {
    if (ciboGiaLoggato != null) {
      final vecchiaQuantita = ciboGiaLoggato.quantita.round().toString();

      aggiornaQuantita(vecchiaQuantita);
    }
  }

  double get quantita => _quantitaInserita;
  String get unita => _unitaMisura;

  //Funzione che permette di fare calcoli ignorando l'unità di misura scelta, la normalizziamo prima.
  double get _quantitaBaseNormalizzata {
    if (_unitaMisura == 'kg' || _unitaMisura == 'l') {
      return _quantitaInserita * 1000;
    }
    return _quantitaInserita;
  }

  //calcola le calorie per quella quantita di alimento.
  double calcolaKcal(FoodModel alimento) {
    final base = alimento.kcalper100;
    return ((base / 100) * _quantitaBaseNormalizzata);
  }

  //calcola le proteine per quella quantita di alimento.
  double calcolaProt(FoodModel alimento) {
    final base = alimento.protper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  //calcola i carboidrati per quella quantita di alimento.
  double calcolaCarb(FoodModel alimento) {
    final base = alimento.carbper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  //calcola i grassi per quella quantita di alimento.
  double calcolaGras(FoodModel alimento) {
    final base = alimento.grasper100;
    return (base / 100) * _quantitaBaseNormalizzata;
  }

  // Aggiorna la quantità inserita. Prova il parsing della stringa a Double.
  void aggiornaQuantita(String testo) {
    _quantitaInserita = double.tryParse(testo) ?? 0.0;
    notifyListeners();
  }

  // Cambia l'unità di misura selezionata. Aggiorniamo la ui solo se è effettivamente cambiata l'unità.
  void cambiaUnita(String? nuovaUnita) {
    if (nuovaUnita != null && nuovaUnita != _unitaMisura) {
      _unitaMisura = nuovaUnita;
      notifyListeners();
    }
  }

  //Trasforma un foodmodel in un loggedfood per permettere poi il funzionamento di tutti i metodi della HP in base
  //alle nostre quantità selezionate.
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
