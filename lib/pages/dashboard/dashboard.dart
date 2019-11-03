import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/dashboard/hospital_card.dart';
import 'package:hospital_finder/pages/dashboard/search_card.dart';
import 'package:hospital_finder/pages/hospital_list/hospitals_list.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:hospital_finder/utils/loadHospitals.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';
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
      drawerIcon: true,
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
                        onPressed: () => showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => AssetGiffyDialog(
                            image: Image(
                              image: AssetImage('assets/images/background.jpg'),
                              fit: BoxFit.fill,
                            ),
                            title: Text(
                              "How to get location ?",
                              style: TextStyle(
                                  fontSize: SizeConfig.safeBlockHorizontal * 5),
                            ),
                            buttonOkText: Text("Enter manually"),
                            buttonCancelText: Text("Using GPS"),
                            onOkButtonPressed: () => print("Enter it manually"),
                            onCancelButtonPressed: () {
                              locationBloc.getLocation();
                              Navigator.of(context).pop();
                            },
                            entryAnimation: EntryAnimation.TOP_BOTTOM,
                            buttonCancelColor: Colors.red[200],
                            buttonRadius: 30.0,
                            cornerRadius: 50.0,
                          ),
                        ),
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
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: SearchHospitalsDelegate());
                          },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Best Hospitals nearby you",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                      ),
                      InkWell(
                        onTap: () => Navigator.pushNamed(
                            context, HospitalList.routeName),
                        child: Text(
                          "See More",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 3),
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
                height: SizeConfig.blockSizeVertical * 35,
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
                              name: hospitals[i].name,
                              onTap: () {},
                              distance: hospitals[i].index,
                              district: hospitals[i].district,
                              state: hospitals[i].state);
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
    );
  }
}
