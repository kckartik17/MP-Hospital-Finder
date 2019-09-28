import 'package:flutter/foundation.dart';

class ConfigBloc with ChangeNotifier {
  bool _darkOn = false;

  bool get darkOn => _darkOn;

  void reverseDarkMode() {
    _darkOn = !_darkOn;
    notifyListeners();
  }
}
