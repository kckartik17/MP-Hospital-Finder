import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/models/hospitalfirestore.dart';
import 'package:hospital_finder/utils/HFscaffold.dart';
import 'dart:math' show cos, sqrt, sin, asin, pi, atan2;
import 'package:vector_math/vector_math.dart';

class HospitalListFirestore extends StatefulWidget {
  final String district;

  const HospitalListFirestore({Key key, this.district}) : super(key: key);
  @override
  _HospitalListFirestoreState createState() => _HospitalListFirestoreState();
}

class _HospitalListFirestoreState extends State<HospitalListFirestore> {
  bool sortbutton = false;
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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
      double dis = calculateDistance(28.9885, 76.9960, double.parse(h.latitude),
          double.parse(h.longitude));
      // print(dis / 1000);
      h.distance = double.parse(dis.toStringAsPrecision(3));
    });
    return hos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.district}"),
      ),
      body: FutureBuilder(
        future: load(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<HospitalFirestore> list = snapshot.data;
            if (sortbutton) {
              list.sort((a, b) => a.distance.compareTo(b.distance));
            } else {
              list.sort((a, b) => a.name.compareTo(b.name));
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${list[index].name}"),
                  subtitle: Text("${list[index].address}"),
                  trailing: Text("${list[index].distance} kms"),
                );
              },
              itemCount: list.length,
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            sortbutton = true;
          });
        },
        child: Text("Sort"),
      ),
    );
  }
}
