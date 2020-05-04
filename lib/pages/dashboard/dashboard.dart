import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hospital_finder/clippers/dashboardClipper.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/dashboard/hospital_card.dart';
import 'package:hospital_finder/pages/doctors/doctors_list.dart';
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
    GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

    LocationBloc locationBloc = Provider.of<LocationBloc>(context);
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        showCupertinoModalPopup(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            context: context,
            builder: (_) => AlertDialog(
                  backgroundColor:
                      configBloc.darkOn ? Color(0xff1f2124) : Colors.white,
                  title: Text("Do you want to exit the app ?"),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => SystemChannels.platform
                          .invokeMethod('SystemNavigator.pop'),
                      child: Text(
                        "Yes",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop('dialog'),
                      child: Text(
                        "No",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ));
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipPath(
                  clipper: DashboardClipper(),
                  child: Container(
                    height: 330,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: configBloc.darkOn ? Color(0xff1f2124) : null,
                      gradient: !configBloc.darkOn
                          ? LinearGradient(
                              colors: [Color(0xFF3750B2), Colors.blue[200]],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)
                          : null,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SafeArea(
                        child: Opacity(
                            opacity: 0.4,
                            child:
                                Image.asset("assets/images/doctor_icon.png")),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 280,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      _currentUser != null
                          ? showCupertinoModalPopup(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              context: context,
                              builder: (context) {
                                return CupertinoActionSheet(
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text("Cancel",
                                        style: TextStyle(color: Colors.blue)),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                  title: Text(
                                    "Sign Out",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  message: Text("Do you want to sign out ?"),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text(
                                        "Sign Out",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        _handleSignOut();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              })
                          : _handleSignIn();
                    },
                    icon: _currentUser == null
                        ? Icon(
                            FontAwesomeIcons.user,
                            color: Color(0xff73a1b2),
                          )
                        : CircleAvatar(
                            radius: 15,
                            backgroundImage:
                                NetworkImage("${_currentUser.photoUrl}"),
                          ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState.openDrawer(),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: SvgPicture.asset("assets/images/menu.svg"),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.my_location,
                              color: Colors.white,
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
                              child: Text(
                                locationBloc.location,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: SizeConfig.safeBlockHorizontal * 4,
                              ),
                              onPressed: () {
                                locationBloc.getLocation();
                                setState(() {});
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          _currentUser == null ? "Welcome" : "Welcome,",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              letterSpacing: 1),
                        ),
                        _currentUser != null
                            ? Text(
                                "${_currentUser.displayName}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    letterSpacing: 1),
                              )
                            : Text(""),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: configBloc.darkOn
                                ? Colors.black.withOpacity(0.4)
                                : Colors.white30,
                          ),
                          margin: EdgeInsets.zero,
                          padding: EdgeInsets.zero,
                          width: size.width * 0.68,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Search all hospitals...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          letterSpacing: 2),
                                    ),
                                    Icon(Icons.search, color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
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
                    ),
                    Container(
                      height: 250,
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
                              h.distance =
                                  double.parse(dis.toStringAsPrecision(3));
                            });
                            hospitals.sort(
                                (a, b) => a.distance.compareTo(b.distance));
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
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Find doctors in top specialities",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeHorizontal * 4),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 160,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/dentist.svg",
                            name: "Dentist",
                          ),
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/gynae.svg",
                            name: "Gynaecologist",
                          ),
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/orthopedic.svg",
                            name: "Orthopedist",
                          ),
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/physio.svg",
                            name: "Physiotherapist",
                          ),
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/dermatology.svg",
                            name: "Dermatologist",
                          ),
                          SpecialitiesCard(
                            configBloc: configBloc,
                            svgPath: "assets/images/pedia.svg",
                            name: "Pediatrician",
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Made with ",
                          style: GoogleFonts.mcLaren(
                            textStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          child: SvgPicture.asset("assets/images/heart.svg"),
                        ),
                        Text(
                          " by Kartik & Kushal",
                          style: GoogleFonts.mcLaren(
                            textStyle: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            )
          ],
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
                  onTap: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpecialitiesCard extends StatelessWidget {
  const SpecialitiesCard(
      {Key key,
      @required this.configBloc,
      @required this.svgPath,
      @required this.name})
      : super(key: key);

  final ConfigBloc configBloc;
  final String svgPath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => DoctorsList())),
          child: Ink(
            width: SizeConfig.blockSizeHorizontal * 40,
            decoration: BoxDecoration(
              color: configBloc.darkOn
                  ? Tools.hexToColor("#1f2124")
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: !configBloc.darkOn
                  ? [
                      BoxShadow(
                        color: Color(0xFFE6E6E6),
                        blurRadius: 17,
                        offset: Offset(0, 17),
                        spreadRadius: 0,
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      color:
                          configBloc.darkOn ? Colors.black : Colors.blue[200],
                      shape: BoxShape.circle),
                  child: SvgPicture.asset(svgPath),
                ),
                Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: AutoSizeText(
                    name,
                    maxLines: 2,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
