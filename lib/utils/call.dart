import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

void call(number) async {
  number = "tel:" + number;
  if (await canLaunch(number)) {
    await launch(number);
  } else {
    Fluttertoast.showToast(
        msg: "Invalid Number",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT);
  }
}
