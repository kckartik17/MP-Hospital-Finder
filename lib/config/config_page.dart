import 'package:flutter/material.dart';
import 'package:hospital_finder/pages/dashboard/dashboard.dart';
import 'package:hospital_finder/pages/hospital_list/hospitals_list.dart';
import 'package:hospital_finder/pages/maps/maps.dart';
import 'package:hospital_finder/utils/hf.dart';
import 'package:provider/provider.dart';
import 'package:hospital_finder/notifiers/index.dart';

class ConfigPage extends StatefulWidget {
  static const String routeName = "/";
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return MaterialApp(
      title: "Hospital Finder",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: HF.google_sans,
        primarySwatch: Colors.blue,
        primaryColor: configBloc.darkOn ? Colors.black : Colors.white,
        disabledColor: Colors.grey,
        cardColor: configBloc.darkOn ? Colors.black : Colors.white,
        canvasColor: configBloc.darkOn ? Colors.black : Color(0xFFF8F8F8),
        brightness: configBloc.darkOn ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              colorScheme:
                  configBloc.darkOn ? ColorScheme.dark() : ColorScheme.light(),
            ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: configBloc.darkOn ? Colors.black : Color(0xFFF8F8F8),
        ),
      ),
      home: Dashboard(),
      routes: {
        Dashboard.routeName: (context) => Dashboard(),
        HospitalList.routeName: (context) => HospitalList(),
        HospitalListMap.routeName: (context) => HospitalListMap(),
      },
    );
  }
}
