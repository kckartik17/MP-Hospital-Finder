import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationBloc with ChangeNotifier {
  var _loc = Location();
  String location = "Unknown Location";

  void getLocation() async {
    try {
      _loc.requestPermission().then((granted) async {
        print(granted);
        if (granted) {
          var userLocation = await _loc.getLocation();
          final coordinates =
              new Coordinates(userLocation.latitude, userLocation.longitude);
          var addresses =
              await Geocoder.local.findAddressesFromCoordinates(coordinates);
          location = addresses.first.addressLine;

          notifyListeners();
        } else {
          Fluttertoast.showToast(
              msg: "Unable to access the location",
              gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        }
      });
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
      Fluttertoast.showToast(
          msg: "Unable to access the location",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
