import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_finder/models/district.dart';

Future<List<Hospital>> loadHospitals() async {
  String content = await rootBundle.loadString('assets/hospitals.json');
  List collection = json.decode(content);
  List<Hospital> _hospitals =
      collection.map((json) => Hospital.fromJson(json)).toList();

  return _hospitals;
}

Future<List<District>> loadDistricts() async {
  QuerySnapshot qs =
      await Firestore.instance.collection("districtnames").getDocuments();
  List<District> dist =
      qs.documents.map((doc) => District.fromFirestore(doc)).toList();

  return dist;
}
