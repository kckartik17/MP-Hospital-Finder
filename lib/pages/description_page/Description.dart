import 'package:flutter/material.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:hospital_finder/utils/tools.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Description extends StatelessWidget {
  final String name = "Description Page";
  final String latitude;
  final String longitude;
  final String mobile;
  static const String routeName = "/description";
  final hname, state;

  const Description(
      {Key key,
      this.hname,
      this.state,
      this.latitude,
      this.longitude,
      this.mobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return HFscaffold(
        title: name,
        drawerIcon: false,
        body: Stack(
          children: <Widget>[
            Container(
              height: screenHeight,
              width: screenWidth,
              color: configBloc.darkOn
                  ? Tools.hexToColor("#1f2124")
                  : Colors.white,
            ),
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/hospital.jpg'),
                      fit: BoxFit.cover)),
            ),
            Positioned(
                top: 150.0,
                child: Container(
                  height: screenHeight - 150.0,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          topRight: Radius.circular(50.0))),
                  child: ListView(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 35.0,
                                bottom: 5.0,
                                right: 25.0,
                                top: 25.0),
                            child: Text(
                              'Bharat Hosptial',
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 35.0, bottom: 25.0, right: 25.0),
                        child: Text(
                          'Sector:14 Sonepat',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9E9E9E)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 35.0, bottom: 25.0, right: 25.0),
                        child: Text(
                          'Description ',
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 35.0, bottom: 25.0, right: 25.0),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              call(mobile);
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.directions,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              navigate(latitude, longitude);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 125.0, bottom: 12.0, right: 25.0),
                        child: Text(
                          'Have you visited yet!',
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 135.0, bottom: 12.0, right: 25.0),
                        child: Text(
                          'Share your Experience ',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9E9E9E)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 125.0,
                            bottom: 12.0,
                            right: 25.0,
                          ),
                          child: RatingBar(
                            initialRating: 0,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              switch (index) {
                                case 0:
                                  return Icon(
                                    Icons.sentiment_very_dissatisfied,
                                    color: Colors.red,
                                  );
                                case 1:
                                  return Icon(
                                    Icons.sentiment_dissatisfied,
                                    color: Colors.redAccent,
                                  );
                                case 2:
                                  return Icon(
                                    Icons.sentiment_neutral,
                                    color: Colors.amber,
                                  );
                                case 3:
                                  return Icon(
                                    Icons.sentiment_satisfied,
                                    color: Colors.lightGreen,
                                  );
                                case 4:
                                  return Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                              }
                            },
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          )),
                    ],
                  ),
                ))
          ],
        ));
  }
}
