import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/dashboard/hospital_card.dart';
import 'package:hospital_finder/pages/hospital_list/cities.dart';
import 'package:hospital_finder/utils/loadData.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';
import 'package:hospital_finder/utils/tools.dart';
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
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
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
                  // SizedBox(
                  //   height: SizeConfig.blockSizeVertical * 2,
                  // ),
                  // Text(
                  //   "What are you looking for ?",
                  //   style: TextStyle(
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                  // ),
                  // SizedBox(
                  //   height: SizeConfig.blockSizeVertical * 2,
                  // ),
                  // Center(
                  //   child: Wrap(
                  //     runSpacing: SizeConfig.blockSizeVertical * 2,
                  //     spacing: SizeConfig.blockSizeHorizontal * 5,
                  //     children: <Widget>[
                  //       SearchCard(
                  //         text: "Search Hospitals",
                  //         onTap: () {
                  //           showSearch(
                  //               context: context,
                  //               delegate: SearchHospitalsDelegate());
                  //         },
                  //         color: Colors.red,
                  //       ),
                  //       SearchCard(
                  //         text: "Search Blood Banks",
                  //         onTap: () {},
                  //         color: Colors.teal,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: SizeConfig.blockSizeVertical * 5,
                  // ),

                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: configBloc.darkOn
                            ? Tools.hexToColor("#1f2124")
                            : Colors.white,
                        boxShadow: !configBloc.darkOn
                            ? [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 10.0,
                                    color: Colors.grey[400],
                                    spreadRadius: 3)
                              ]
                            : null),
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    width: double.infinity,
                    child: ListTile(
                      enabled: false,
                      title: GestureDetector(
                          onTap: () => showSearch(
                              context: context,
                              delegate: SearchHospitalsDelegate()),
                          child: Text("Search All Hospitals...")),
                      trailing: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => showSearch(
                            context: context,
                            delegate: SearchHospitalsDelegate()),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: SizeConfig.blockSizeHorizontal * 10,
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
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Citieslist())),
                        child: Text(
                          "See More",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3.5),
                        ),
                      ),
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
                height: SizeConfig.blockSizeHorizontal * 60,
                padding: EdgeInsets.only(
                  left: SizeConfig.blockSizeHorizontal * 2,
                  right: SizeConfig.blockSizeHorizontal * 2,
                  bottom: SizeConfig.blockSizeHorizontal * 3,
                ),
                child: FutureBuilder(
                  future: loadHospitals(),
                  builder: (context, snapshot) {
                    List<Hospital> hospitals = snapshot.data;
                    if (!snapshot.hasData || snapshot.data.isEmpty)
                      return Center(child: CircularProgressIndicator());
                    else
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, i) {
                          return HospitalCard(
                            hospital: hospitals[i],
                          );
                        },
                        itemCount: 5,
                      );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Hospital Finder",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.safeBlockHorizontal * 5,
                    letterSpacing: SizeConfig.safeBlockHorizontal * 0.8),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.purple[600], Colors.purple[200]],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
            ),
            ListTile(
              title: Text("Dark Mode"),
              trailing: CupertinoSwitch(
                value: configBloc.darkOn,
                onChanged: (value) {
                  configBloc.reverseDarkMode();
                },
                activeColor: Colors.purple,
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
    );
  }
}
