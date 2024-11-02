import 'package:flutter/material.dart';

// import 'model_test_product_cart.dart';

class CounterProvider extends ChangeNotifier {
  // final List<Item> _cartItems = [];
  double _price = 0.0;
  int _counter = 0;


  double get totalPrice {
    return _price;
  }

  int get counterCount {
    return _counter;
  }

  void incrementCounter() {
    _counter++;
    notifyListeners();
  }

  void decrementCounter() {
    if (_counter > 0) _counter--;
    notifyListeners();
  }
}