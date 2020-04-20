import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/pages/hospital_list/hospitals_list.dart';

class Citieslist extends StatefulWidget {
  @override
  _CitieslistState createState() => _CitieslistState();
}

class _CitieslistState extends State<Citieslist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cities"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("districtnames").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.hasError ||
                snapshot.data.documents.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    title: Text("${snapshot.data.documents[i]["name"]}"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HospitalList(
                                    district: snapshot.data.documents[i]
                                        ["name"],
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
