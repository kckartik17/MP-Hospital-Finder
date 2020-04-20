import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/models/cities.dart';
import 'package:hospital_finder/pages/hospital_list/hospitals_list.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';

class Citieslist extends StatefulWidget {
  @override
  _CitieslistState createState() => _CitieslistState();
}

class _CitieslistState extends State<Citieslist> {
  Future<List<District>> loaddistrict() async {
    QuerySnapshot qs =
        await Firestore.instance.collection("districtnames").getDocuments();
    List<District> dist =
        qs.documents.map((doc) => District.fromFirestore(doc)).toList();

    return dist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cities"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () =>
                  showSearch(context: context, delegate: CitiesDelegate()))
        ],
      ),
      body: FutureBuilder(
          future: loaddistrict(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.hasError ||
                snapshot.data.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<District> list = snapshot.data;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text(list[i].name),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalList(
                                    district: list[i].name,
                                  )));
                    },
                  );
                },
              );
            }
          }),
    );
  }
}
