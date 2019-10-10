import 'package:flutter/material.dart';

import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
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
    SizeConfig().init(context);
    return HFscaffold(
      title: "Dashboard",
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
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
                      Text("Gurugram, Haryana"),
                      SizedBox(
                        width: SizeConfig.blockSizeHorizontal * 2,
                      ),
                      Icon(
                        Icons.edit,
                        size: SizeConfig.safeBlockHorizontal * 4,
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
                ],
              ),
            ),
            SafeArea(
              child: Container(
                height: SizeConfig.blockSizeVertical * 25,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.blockSizeHorizontal * 5),
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
                            onPressed: () {},
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

class SearchCard extends StatelessWidget {
  final Function onTap;
  final String text;
  // final Icon icon;
  final Color color;

  const SearchCard({Key key, this.onTap, this.text, this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Ink(
        height: SizeConfig.blockSizeVertical * 15,
        width: SizeConfig.blockSizeHorizontal * 42,
        decoration: BoxDecoration(
          color: configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: !configBloc.darkOn
              ? [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 10,
                    spreadRadius: 5,
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.search,
              color: color,
            ),
            SizedBox(
              height: 10,
            ),
            Text(text)
          ],
        ),
      ),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Function onTap;
  final String text;
  final double distance;

  const HospitalCard({Key key, this.onTap, this.text, this.distance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: Ink(
              height: SizeConfig.blockSizeVertical * 40,
              width: SizeConfig.blockSizeHorizontal * 40,
              decoration: BoxDecoration(
                color: configBloc.darkOn
                    ? Tools.hexToColor("#1f2124")
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: !configBloc.darkOn
                    ? [
                        BoxShadow(
                          color: Colors.grey[200],
                          blurRadius: 10,
                          spreadRadius: 5,
                        )
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 3,
                  ),
                  Icon(
                    Icons.local_hospital,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(text)
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: SizeConfig.blockSizeVertical * 40 / 100,
          left: SizeConfig.blockSizeHorizontal * 40 / 2.8,
          child: Chip(
            label: Text(
              "$distance km",
              style: TextStyle(fontSize: SizeConfig.safeBlockHorizontal * 3),
            ),
            backgroundColor: configBloc.darkOn ? Colors.red : Colors.blue[100],
            elevation: 8,
          ),
        ),
      ],
    );
  }
}
