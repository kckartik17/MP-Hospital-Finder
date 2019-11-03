import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hospital_finder/models/index.dart';

Future<List<Hospital>> loadHospitals() async {
  String content = await rootBundle.loadString('assets/hospitals.json');
  List collection = json.decode(content);
  List<Hospital> _hospitals =
      collection.map((json) => Hospital.fromJson(json)).toList();

  return _hospitals;
}
