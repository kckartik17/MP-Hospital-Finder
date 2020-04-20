import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hospital_finder/models/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_finder/models/district.dart';
import 'package:hospital_finder/models/hospitalfirestore.dart';

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

Future<List<HospitalFirestore>> load(district) async {
  QuerySnapshot qs = await Firestore.instance
      .collection("district")
      .document(district)
      .collection("hospitals")
      .getDocuments();
  List<HospitalFirestore> hos =
      qs.documents.map((doc) => HospitalFirestore.fromFirestore(doc)).toList();

  hos.sort((a, b) => a.name.compareTo(b.name));

  return hos;
}
