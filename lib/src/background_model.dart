import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackGroundModel extends ChangeNotifier {
  Color color;
  BackGroundModel(this.color);

  void backGroundColor(Color value) {
    this.color = value;

    notifyListeners();
  }
}