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
                          text: "Search Doctors",
                          onTap: () {},
                          color: Colors.blue,
                        ),
                        SearchCard(
                          text: "Search Blood Banks",
                          onTap: () {},
                          color: Colors.teal,
                        ),
                        SearchCard(
                          text: "Search Specialization",
                          onTap: () {},
                          color: Colors.purple[600],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 2,
                  ),
                  Text(
                    "Find doctors in top specialities",
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
            Container(
              height: SizeConfig.blockSizeVertical * 25,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                  SpecialityCard(
                    onTap: () {},
                    text: "Dentist",
                  ),
                ],
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

class SpecialityCard extends StatelessWidget {
  final Function onTap;
  final String text;

  const SpecialityCard({Key key, this.onTap, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Ink(
          height: SizeConfig.blockSizeVertical * 30,
          width: SizeConfig.blockSizeHorizontal * 30,
          decoration: BoxDecoration(
            color:
                configBloc.darkOn ? Tools.hexToColor("#1f2124") : Colors.white,
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
                Icons.account_circle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
