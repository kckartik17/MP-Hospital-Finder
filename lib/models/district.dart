import 'package:cloud_firestore/cloud_firestore.dart';

class District {
  final String name;

  District({this.name});

  factory District.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    return District(name: data["name"]);
  }
}
