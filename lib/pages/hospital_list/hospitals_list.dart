import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hospital_finder/config/size_config.dart';
import 'package:hospital_finder/models/hospitalfirestore.dart';
import 'package:hospital_finder/notifiers/index.dart';
import 'package:hospital_finder/pages/description_page/Description.dart';
import 'package:hospital_finder/pages/maps/maps.dart';
import 'package:provider/provider.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:hospital_finder/utils/searchHospitals.dart';

class HospitalList extends StatefulWidget {
  final String district;
  static const String routeName = "/hospitalList";

  const HospitalList({Key key, this.district}) : super(key: key);
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  bool sortbutton = false;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List<HospitalFirestore> hospitals;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    LocationBloc locationBloc = Provider.of<LocationBloc>(context);

    Future<List<HospitalFirestore>> load() async {
      QuerySnapshot qs = await Firestore.instance
          .collection("district")
          .document(widget.district)
          .collection("hospitals")
          .getDocuments();
      List<HospitalFirestore> hos = qs.documents
          .map((doc) => HospitalFirestore.fromFirestore(doc))
          .toList();

      hos.forEach((h) {
        double dis = calculateDistance(
            locationBloc.latitude,
            locationBloc.longitude,
            double.parse(h.latitude),
            double.parse(h.longitude));
        h.distance = double.parse(dis.toStringAsPrecision(3));
      });

      return hos;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Search in ${widget.district}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => showSearch(
                context: context, delegate: HospitalsDelegate(widget.district)),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(color: Colors.white),
        curve: Curves.bounceIn,
        backgroundColor: configBloc.darkOn ? Colors.black : Color(0xFF3750B2),
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.directions),
            backgroundColor: configBloc.darkOn ? Colors.white : Colors.red,
            labelStyle: TextStyle(color: Colors.black),
            label: 'Sort by distance',
            onTap: () {
              setState(() {
                sortbutton = true;
              });
            },
          ),
          SpeedDialChild(
            child: Icon(FontAwesomeIcons.map),
            backgroundColor: configBloc.darkOn ? Colors.white : Colors.purple,
            labelStyle: TextStyle(color: Colors.black),
            label: 'View in Maps',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HospitalListMap(
                          district: widget.district,
                        ))),
          )
        ],
      ),
      body: FutureBuilder(
        future: load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError || snapshot.data.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<HospitalFirestore> list = snapshot.data;
            hospitals = list;
            if (sortbutton) {
              list.sort((a, b) => a.distance.compareTo(b.distance));
            } else {
              list.sort((a, b) => a.name.compareTo(b.name));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: configBloc.darkOn
                            ? Color(0xFF1f2124)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: configBloc.darkOn
                            ? null
                            : [
                                BoxShadow(
                                    color: Color(0xFFE6E6E6),
                                    offset: Offset(0, 17),
                                    blurRadius: 17,
                                    spreadRadius: 0),
                              ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Description(
                              hospital: list[index],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Hero(
                            tag: "${list[index].name}",
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/images/hospital.jpg"),
                            ),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          title: Text("${list[index].name}"),
                          subtitle: Text(
                            "${list[index].address}",
                            style: TextStyle(fontSize: 12),
                          ),
                          trailing: sortbutton == true
                              ? Text("${list[index].distance} kms")
                              : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: list.length,
            );
          }
        },
      ),
    );
  }
}
