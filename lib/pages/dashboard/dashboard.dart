import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/widgets/hospital_card.dart';
import 'package:hospital_finder/widgets/search_card.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  static const String routeName = "/dashboard";
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    LocationBloc locationBloc = Provider.of<LocationBloc>(context);
    SizeConfig().init(context);
    return HFscaffold(
      title: "Dashboard",
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
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: SizeConfig.safeBlockHorizontal * 4,
                        ),
                        onPressed: () => locationBloc.getLocation(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Text(
                    "What are you looking for ?",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Center(
                    child: Wrap(
                      runSpacing: SizeConfig.blockSizeVertical * 2,
                      spacing: SizeConfig.blockSizeHorizontal * 5,
                      children: <Widget>[
                        SearchCard(
                          text: "Search Hospitals",
                          onTap: () {},
                          color: Colors.red,
                        ),
                        SearchCard(
                          text: "Search Blood Banks",
                          onTap: () {},
                          color: Colors.teal,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 5,
                  ),
                  Text(
                    "Best Hospitals nearby you",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Container(
                height: SizeConfig.blockSizeVertical * 30,
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2,
                  bottom: SizeConfig.blockSizeHorizontal * 3,
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: ClampingScrollPhysics(),
                  children: <Widget>[
                    HospitalCard(
                      onTap: () {},
                      text: "Hospital 1",
                      distance: 1.2,
                    ),
                    HospitalCard(
                      onTap: () {},
                      text: "Hospital 2",
                      distance: 2.1,
                    ),
                    HospitalCard(
                      onTap: () {},
                      text: "Hospital 3",
                      distance: 2.8,
                    ),
                    HospitalCard(
                      onTap: () {},
                      text: "Hospital 4",
                      distance: 4.2,
                    ),
                    HospitalCard(
                      onTap: () {},
                      text: "Hospital 5",
                      distance: 7.6,
                    ),
                    Container(
                      height: SizeConfig.blockSizeVertical * 40,
                      width: SizeConfig.blockSizeHorizontal * 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "See More",
                                  gravity: ToastGravity.BOTTOM,
                                  toastLength: Toast.LENGTH_LONG);
                            },
                          ),
                          Text("See more")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
