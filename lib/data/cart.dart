import 'package:flutter/material.dart';

class CartData extends ChangeNotifier {
  double totale = 0.0;
  int id;

  CartData({required this.id, required this.totale});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(id: json["id"], totale: json["totalPrice"]);
  }

  double getTotale() {
    return totale;
  }

  int getId() {
    return id;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'totalPrice': totale};
  }
}