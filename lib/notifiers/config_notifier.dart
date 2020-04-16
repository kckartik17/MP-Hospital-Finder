import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigBloc with ChangeNotifier {
  bool _darkOn = false;

  bool get darkOn => _darkOn;

  SharedPreferences prefs;

  ConfigBloc() {
    getDark();
  }

  getDark() async {
    prefs = await SharedPreferences.getInstance();
    bool dark = prefs.getBool('dark') ?? false;
    this._darkOn = dark;
    notifyListeners();
  }

  void reverseDarkMode() {
    _darkOn = !darkOn;
    prefs.setBool('dark', _darkOn);
    notifyListeners();
  }
}
