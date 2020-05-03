import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/dashboard/hospital_card.dart';
import 'package:hospital_finder/pages/hospital_list/cities.dart';
import 'package:hospital_finder/utils/day_night_switch.dart';
import 'package:hospital_finder/utils/loadData.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';
import 'package:hospital_finder/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/models/hospitalfirestore.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "/dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class _DashboardState extends State<Dashboard> {
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  GoogleSignInAccount _currentUser;
  FirebaseUser firebaseUser;
  SharedPreferences prefs;

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    _googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount account) async {
      setState(() {
        _currentUser = account;
      });
    });

    _googleSignIn.signInSilently(suppressErrors: false).then((account) {
      _signIn(account);
    }).catchError((dynamic onError) {
      print(onError.toString());
    });
  }

  Future<void> _signIn(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    prefs.setString('id', user.uid);

    setState(() {
      firebaseUser = user;
    });
  }

  Future<void> _handleSignIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      _signIn(googleUser);
    } catch (error) {
      print("Cancelled");
    }
  }

  Future<void> _handleSignOut() async {
    await _auth.signOut();
    _googleSignIn.disconnect();
    prefs.remove('id');
    setState(() {
      firebaseUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = Provider.of<LocationBloc>(context);
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  context: context,
                  builder: (context) {
                    if (_currentUser != null) {
                      return CupertinoActionSheet(
                        cancelButton: CupertinoActionSheetAction(
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.blue)),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        title: Text(
                          "Sign Out",
                          style: TextStyle(fontSize: 20),
                        ),
                        message: Text("Do you want to sign out ?"),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: Text("Sign Out"),
                            onPressed: () {
                              _handleSignOut();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    }

                    return CupertinoActionSheet(
                      title: Text(
                        "Sign in",
                        style: TextStyle(fontSize: 20),
                      ),
                      message:
                          Text("Please select any method from options below"),
                      cancelButton: CupertinoActionSheetAction(
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text("Google"),
                          onPressed: () {
                            _handleSignIn();
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text(
                            "Phone",
                            style: TextStyle(color: Colors.green),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            },
            icon: _currentUser == null
                ? Icon(FontAwesomeIcons.user)
                : CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage("${_currentUser.photoUrl}"),
                  ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.my_location,
                        size: SizeConfig.safeBlockHorizontal * 4,
                      ),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      InkWell(
                        onTap: () => Fluttertoast.showToast(
                            msg: locationBloc.location,
                            gravity: ToastGravity.BOTTOM,
                            toastLength: Toast.LENGTH_LONG),
                        child: locationBloc.location.length > 40
                            ? Text(locationBloc.location
                                    .toString()
                                    .substring(0, 40) +
                                " ....")
                            : Text(locationBloc.location),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: SizeConfig.safeBlockHorizontal * 4,
                        ),
                        onPressed: () {
                          locationBloc.getLocation();
                          setState(() {});
                        },
                      )
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: configBloc.darkOn
                            ? Tools.hexToColor("#1f2124")
                            : Colors.white,
                        boxShadow: !configBloc.darkOn
                            ? [
                                BoxShadow(
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    color: Color(0xFFE6E6E6),
                                    spreadRadius: 0)
                              ]
                            : null),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          showSearch(
                              context: context,
                              delegate: SearchHospitalsDelegate());
                        },
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Search all hospitals...",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                    letterSpacing: 2),
                              ),
                              Icon(Icons.search)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Best Hospitals nearby you",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeHorizontal * 4),
                      ),
                      FlatButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Citieslist())),
                          child: Text("See more"))
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                height: SizeConfig.blockSizeHorizontal * 65,
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2,
                  bottom: SizeConfig.blockSizeHorizontal * 3,
                ),
                child: FutureBuilder(
                  future: load(locationBloc.district != null
                      ? "${locationBloc.district}"
                      : "Sonipat"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<HospitalFirestore> hospitals = snapshot.data;
                      hospitals.forEach((h) {
                        double dis = calculateDistance(
                            locationBloc.latitude,
                            locationBloc.longitude,
                            double.parse(h.latitude),
                            double.parse(h.longitude));
                        h.distance = double.parse(dis.toStringAsPrecision(3));
                      });
                      hospitals
                          .sort((a, b) => a.distance.compareTo(b.distance));
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, i) {
                          return HospitalCard(
                            hospital: hospitals[i],
                          );
                        },
                        itemCount: snapshot.data.length,
                      );
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
        ),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  _currentUser == null
                      ? "Guest user"
                      : _currentUser.displayName,
                  style: TextStyle(color: Colors.white),
                ),
                accountEmail: _currentUser != null
                    ? Text(
                        _currentUser.email,
                        style: TextStyle(color: Colors.white),
                      )
                    : null,
                currentAccountPicture: _currentUser == null
                    ? CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: Icon(FontAwesomeIcons.user),
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(_currentUser.photoUrl),
                      ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF3750B2), Colors.blue[200]],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
              ),
              ListTile(
                title: Text("Day Mode"),
                trailing: DayNightSwitch(
                  height: 40,
                  width: 60,
                  value: configBloc.darkOn,
                  onSelection: (newValue) {
                    setState(() {
                      configBloc.reverseDarkMode();
                    });
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.reply),
                title: Text("Exit"),
                onTap: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
