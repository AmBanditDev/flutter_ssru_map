import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';

class GenderProvider extends ChangeNotifier {
  bool _isMale = true;

  bool get isMale => _isMale;

  set isMale(bool value) {
    _isMale = value;
    notifyListeners();
  }

  get color => _isMale ? kSecondColor : kPrimaryColor;
  get maleColor => _isMale ? kSecondColor : Colors.grey;
  get femaleColor => _isMale ? Colors.grey : kPrimaryColor;
}
