import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/call.dart';
import 'package:hospital_finder/utils/navigation.dart';
import 'package:provider/provider.dart';

class HospitalListCard extends StatefulWidget {
  final String name;
  final String district;
  final String mobile;
  final String latitude;
  final String longitude;
  const HospitalListCard(
      {Key key,
      this.name,
      this.district,
      this.mobile,
      this.latitude,
      this.longitude})
      : super(key: key);
  @override
  _HospitalListCardState createState() =>
      _HospitalListCardState(name, district, mobile, latitude, longitude);
}

class _HospitalListCardState extends State<HospitalListCard> {
  final String name;
  final String district;
  final String mobile;
  final String latitude;
  final String longitude;

  _HospitalListCardState(
      this.name, this.district, this.mobile, this.latitude, this.longitude);
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 2),
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 10),
            height: SizeConfig.blockSizeVertical * 18,
            width: SizeConfig.blockSizeHorizontal * 80,
            decoration: BoxDecoration(
              color: configBloc.darkOn ? Colors.black : Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: new Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 15,
                  right: SizeConfig.blockSizeHorizontal * 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  AutoSizeText(
                    name,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.directions_car,
                            size: SizeConfig.blockSizeHorizontal * 3,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          AutoSizeText(
                            "2.1 km",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: SizeConfig.blockSizeHorizontal * 3,
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          AutoSizeText(
                            district,
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3),
                            maxLines: 1,
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          call(mobile);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.call,
                              size: SizeConfig.blockSizeHorizontal * 5,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            AutoSizeText(
                              "Call",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  color: Colors.green),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          navigate(latitude, longitude);
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.directions,
                              size: SizeConfig.blockSizeHorizontal * 5,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            AutoSizeText(
                              "Get Directions",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 3,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: SizeConfig.blockSizeVertical * 4,
            ),
            height: SizeConfig.blockSizeVertical * 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          )
        ],
      ),
    );
  }
}
