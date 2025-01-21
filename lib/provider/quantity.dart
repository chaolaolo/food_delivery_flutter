import 'package:flutter/material.dart';

class QuantityProvider extends ChangeNotifier {
  int _currentNumber = 1;
  List<double> _baseIngredientAmounts = [];

  int get currentNumber => _currentNumber;

  //set init ingredient amount
  void setBaseIngredientAmounts(List<double> amounts) {
    _baseIngredientAmounts = amounts;
    notifyListeners();
  }

  //update ingredient amounts based on the quantity
  List<String> get updateIngredientAmounts {
    return _baseIngredientAmounts.map<String>((amount) => (amount * _currentNumber).toStringAsFixed(1)).toList();
  }

  //increment quantity
  void incrementQuantity() {
    _currentNumber++;
    notifyListeners();
  }

  //decreases quantity
  void decrementQuantity() {
   if(_currentNumber>1){
     _currentNumber--;
     notifyListeners();
   }
  }
}
