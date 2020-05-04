import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:math';
import 'package:hospital_finder/models/hospitalfirestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Description extends StatefulWidget {
  final HospitalFirestore hospital;

  const Description({Key key, this.hospital}) : super(key: key);
  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  Random random = Random();
  TextEditingController reviewController;
  FocusNode focusNode;
  double myrating = 0;
  double avgrating = 0;
  SharedPreferences prefs;
  String id;

  Future<void> getID() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id') ?? "";
    });
    print(" ID : ${prefs.getString('id')}");
  }

  Future<void> getRating() async {
    int rating = (await FirebaseDatabase.instance
            .reference()
            .child("Hospitals/${widget.hospital.index}/$id/rating")
            .once())
        .value;
    if (rating != null) {
      setState(() {
        myrating = rating.toDouble();
      });
    }
    print("Rating : $myrating");
  }

  Future<void> getReview() async {
    String review = (await FirebaseDatabase.instance
            .reference()
            .child("Hospitals/${widget.hospital.index}/$id/review")
            .once())
        .value;
    if (review != null) {
      reviewController = TextEditingController(text: review);
    } else {
      reviewController = TextEditingController();
    }

    print("Review : $review");
  }

  @override
  void initState() {
    super.initState();
    getID();

    focusNode = FocusNode();
    avgrating = random.nextDouble() * (5.0 - 1.0) + 1.0;
    avgrating = double.parse(avgrating.toStringAsPrecision(2));
    Future.delayed(Duration(milliseconds: 500), () {
      getReview();
      getRating();
    });
  }

  @override
  void dispose() {
    super.dispose();
    reviewController.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HospitalFirestore hospital = widget.hospital;
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    final screenWidth = MediaQuery.of(context).size.width;

    List<Marker> markers = [];
    markers.add(
      Marker(
        markerId: MarkerId(hospital.name),
        draggable: false,
        infoWindow: InfoWindow(title: hospital.name, snippet: hospital.address),
        position: LatLng(
          double.parse(hospital.latitude),
          double.parse(hospital.longitude),
        ),
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text(hospital.name),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Hero(
                        tag: "${hospital.name}",
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          child: Container(
                            height: ScreenUtil().setHeight(300),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/hospital.jpg'),
                                  fit: BoxFit.cover),
                            ),
                            width: screenWidth,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    hospital.name,
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(42,
                                            allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                      color: (() {
                                        if (avgrating < 2.0) {
                                          return Colors.red[500];
                                        } else if (avgrating >= 2.0 &&
                                            avgrating < 3.6) {
                                          return Colors.yellow[800];
                                        } else {
                                          return Colors.green[500];
                                        }
                                      }()),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "$avgrating",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(35,
                                              allowFontScalingSelf: true),
                                        ),
                                      ),
                                      Text(
                                        "rating",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                    child: Text(
                                        "${hospital.district}, ${hospital.state}"))
                              ],
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Address",
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(35, allowFontScalingSelf: true),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                "${hospital.address}, ${hospital.district}, ${hospital.state}",
                                style: TextStyle(
                                  fontSize: ScreenUtil()
                                      .setSp(30, allowFontScalingSelf: true),
                                ),
                              ),
                              width: screenWidth,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              child: Container(
                                height: 180,
                                width: screenWidth,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  compassEnabled: false,
                                  zoomGesturesEnabled: false,
                                  markers: Set.from(markers),
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                          double.parse(hospital.latitude),
                                          double.parse(hospital.longitude)),
                                      zoom: 14.0),
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    // _controller = controller;
                                    print("created");

                                    // changeMapMode();
                                    // setState(() {
                                    //   isMapCreated = true;
                                    // });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.call,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Contact",
                                  style: TextStyle(
                                    fontSize: ScreenUtil()
                                        .setSp(35, allowFontScalingSelf: true),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: Text(
                                "${hospital.mobile}",
                                style: TextStyle(
                                  letterSpacing: 1,
                                  fontSize: ScreenUtil()
                                      .setSp(30, allowFontScalingSelf: true),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            TextField(
                              focusNode: focusNode,
                              controller: reviewController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: configBloc.darkOn
                                            ? Colors.white
                                            : Colors.black)),
                                labelText: "Write a Review",
                                labelStyle: TextStyle(
                                    color: configBloc.darkOn
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                            SizedBox(height: 10),
                            Align(
                              alignment: Alignment.center,
                              child: FlatButton(
                                  onPressed: () {
                                    String review =
                                        reviewController.text.toString().trim();
                                    if (review != "" && id != "") {
                                      FirebaseDatabase.instance
                                          .reference()
                                          .child("Hospitals")
                                          .child("${hospital.index}")
                                          .child("$id")
                                          .update({"review": review});
                                      Fluttertoast.showToast(
                                          msg: "Review submitted",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "Review field can't be blank or Please Login",
                                          gravity: ToastGravity.BOTTOM,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.blue[300]),
                                  )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            !focusNode.hasFocus
                ? Positioned(
                    bottom: 18,
                    left: 15,
                    right: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          height: 80,
                          width: screenWidth,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.3),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    call(hospital.mobile);
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.white60,
                                        child: Icon(
                                          Icons.call,
                                          color: configBloc.darkOn
                                              ? Colors.black
                                              : Colors.green,
                                        ),
                                      ),
                                      Text("Call")
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => navigate(
                                      hospital.latitude, hospital.longitude),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.white60,
                                        child: Icon(
                                          Icons.directions,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text("Get Directions")
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        title: Column(
                                          children: <Widget>[
                                            Text(
                                              "Rate ${hospital.name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            SizedBox(height: 15),
                                            RatingBar(
                                                initialRating: myrating,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: false,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                onRatingUpdate: (newRating) {
                                                  setState(() {
                                                    myrating = newRating;
                                                  });
                                                }),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                if (id != "") {
                                                  FirebaseDatabase.instance
                                                      .reference()
                                                      .child("Hospitals")
                                                      .child(
                                                          "${hospital.index}")
                                                      .child("$id")
                                                      .update(
                                                          {"rating": myrating});
                                                  Navigator.pop(context);
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg: "Please login !",
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      toastLength:
                                                          Toast.LENGTH_LONG);
                                                }
                                              },
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundColor: Colors.white60,
                                        child: Icon(
                                          Icons.star_half,
                                          color: configBloc.darkOn
                                              ? Colors.black
                                              : Colors.blue,
                                        ),
                                      ),
                                      Text("Add review")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : null
          ].where((child) => child != null).toList(),
        ));
  }
}
