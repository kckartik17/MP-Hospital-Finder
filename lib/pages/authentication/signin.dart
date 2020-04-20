import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/pages/dashboard/dashboard.dart';
import 'package:hospital_finder/universal_widgets/auth_button.dart';

class SignIn extends StatelessWidget {
  static const String routeName = "/signin";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(title: Text("Sign In")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AuthButton(
              text: "Sign in with Google",
              icon: Icon(
                FontAwesomeIcons.google,
                color: Colors.red,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, Dashboard.routeName),
              color: Colors.red,
            ),
            SizedBox(
              height: 20,
            ),
            AuthButton(
              text: "Sign in with Facebook",
              icon: Icon(
                FontAwesomeIcons.facebook,
                color: Colors.indigo[800],
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, Dashboard.routeName),
              color: Colors.indigo[800],
            )
          ],
        ),
      ),
    );
  }
}
