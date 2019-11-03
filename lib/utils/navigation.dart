import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void navigate(latitude, longitude) async {
  String add = "google.navigation:q=$latitude,$longitude";
  if (await canLaunch(add)) {
    await launch(add);
  } else {
    Fluttertoast.showToast(
        msg: "Can't open in Google Maps",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }
}
