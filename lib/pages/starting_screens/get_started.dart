import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/pages/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetStarted extends StatefulWidget {
  @override
  _GetStartedState createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  SharedPreferences prefs;
  bool isFirst;

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFF3750b2),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              top: size.height * 0.3,
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: Image.asset("assets/images/doctors_banner.png"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Find your hospital !",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "Now it's so easy to find a hospital in an emergency",
                      maxLines: 2,
                      style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          color: Colors.white24),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            Positioned(
              left: size.width * 0.32,
              bottom: 25,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  color: Colors.blue[800],
                  onPressed: () {
                    Navigator.pushNamed(context, Dashboard.routeName);
                  },
                  shape: StadiumBorder(),
                  child: Text(
                    "Get Started",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
