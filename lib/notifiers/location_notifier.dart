import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationBloc with ChangeNotifier {
  var _loc = Location();
  String location = "Unknown Location";
  double latitude = 28.9885;
  double longitude = 76.9960;
  String district;

  LocationBloc() {
    getLocation();
  }

  void getLocation() async {
    try {
      _loc.requestPermission().then((granted) async {
        if (granted) {
          try {
            var userLocation = await _loc.getLocation();
            final coordinates =
                new Coordinates(userLocation.latitude, userLocation.longitude);
            var addresses =
                await Geocoder.local.findAddressesFromCoordinates(coordinates);
            location = addresses.first.addressLine;
            latitude = userLocation.latitude;
            longitude = userLocation.longitude;
            district = addresses.first.locality;
            notifyListeners();
          } on Exception catch (e) {
            print('Could not get location: ${e.toString()}');
            Fluttertoast.showToast(
                msg: "Unable to access the location",
                gravity: ToastGravity.BOTTOM,
                toastLength: Toast.LENGTH_LONG);
          }
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
