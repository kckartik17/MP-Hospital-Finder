import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_finder/models/district.dart';
import 'package:hospital_finder/notifiers/config_notifier.dart';
import 'package:hospital_finder/pages/hospital_list/hospitals_list.dart';
import 'package:hospital_finder/utils/searchHospitals.dart';
import 'package:provider/provider.dart';

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
    ConfigBloc configBloc = Provider.of<ConfigBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search by Districts"),
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HospitalList(
                                  district: list[i].name,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor: configBloc.darkOn
                                  ? Colors.black
                                  : Colors.grey[100],
                              child: Text(list[i].name.substring(0, 1)),
                            ),
                            title: Text(list[i].name),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
