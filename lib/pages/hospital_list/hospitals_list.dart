import 'package:flutter/material.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'package:provider/provider.dart';

class HospitalList extends StatefulWidget {
  static const String routeName = "/hospitalList";
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  @override
  Widget build(BuildContext context) {
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return HFscaffold(
      title: "Search Hospitals",
      fab: FloatingActionButton.extended(
        onPressed: () {},
        label: Text("Sort by distance"),
        elevation: 10.0,
        icon: Icon(Icons.directions),
        backgroundColor: configBloc.darkOn ? Colors.grey[700] : Colors.white,
        foregroundColor: configBloc.darkOn ? Colors.white : Colors.black,
      ),
    );
  }
}
