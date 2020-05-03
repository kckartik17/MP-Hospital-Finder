import 'package:flutter/material.dart';
import 'package:hospital_finder/clippers/dashboardClipper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';
import 'package:hospital_finder/utils/tools.dart';
import 'package:provider/provider.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: DashboardClipper(),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SafeArea(
                      child: Opacity(
                          opacity: 0.4,
                          child: Image.asset("assets/images/doctor_icon.png")),
                    ),
                  ),
                ),
              ),
              Positioned(
                child: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue[200]),
                        child: SvgPicture.asset("assets/images/menu.svg"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            letterSpacing: 1),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: configBloc.darkOn
                              ? Tools.hexToColor("#1f2124")
                              : Colors.white30,
                        ),
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        width: size.width * 0.70,
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
                                  Icon(Icons.search)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
              )
            ],
          ),
          SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  title: Text("HElloo"),
                ),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
                Text("Hello"),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
