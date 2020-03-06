import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/hospital.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Description extends StatelessWidget {
  final Hospital hospital;

  const Description({Key key, this.hospital}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return HFscaffold(
        title: hospital.name,
        drawerIcon: false,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 100),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: ScreenUtil().setHeight(300),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/hospital.jpg'),
                              fit: BoxFit.cover),
                        ),
                        width: screenWidth,
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
                                        fontSize: ScreenUtil().setSp(45,
                                            allowFontScalingSelf: true),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "3.5",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: ScreenUtil().setSp(35,
                                              allowFontScalingSelf: true),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
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
                        GestureDetector(
                          onTap: () {
                            call(hospital.mobile);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        GestureDetector(
                          onTap: () =>
                              navigate(hospital.latitude, hospital.longitude),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white60,
                                child: Icon(Icons.directions),
                              ),
                              Text("Get Directions")
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaY: 5, sigmaX: 5),
                                      child: AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        title: Column(
                                          children: <Widget>[
                                            Text(
                                              "Rate ${hospital.name}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                            SizedBox(height: 15),
                                            RatingBar(
                                                initialRating: 0,
                                                minRating: 0,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                onRatingUpdate: (rating) {}),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            RaisedButton(
                                              color: Colors.blueAccent,
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
