import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  String id;
  String latitude;
  String longitude;
  String location;
  String name;
  String district;
  String state;
  String pincode;
  String telephone;
  String mobile;
  String emergencyNumber;
  String ambulancePhone;
  String bloodbankPhone;
  String tollfreePhone;
  String email;
  String website;
  String specialities;
  LatLng locationCoords;

  Hospital(
      {this.id,
      this.latitude,
      this.longitude,
      this.location,
      this.name,
      this.district,
      this.state,
      this.pincode,
      this.telephone,
      this.mobile,
      this.emergencyNumber,
      this.ambulancePhone,
      this.bloodbankPhone,
      this.tollfreePhone,
      this.email,
      this.website,
      this.specialities,
      this.locationCoords});
}

List<Hospital> hospitals = [
  Hospital(
    id: "1",
    latitude: "11.6357989",
    longitude: "92.7120575",
    location: "Near Dollygunj Junction",
    name: "Chakraborty Multi Speciality Hospital",
    district: "South Andaman",
    state: "Andaman and Nicobar Islands",
    pincode: "744101",
    mobile: null,
    emergencyNumber: null,
    ambulancePhone: null,
    bloodbankPhone: null,
    tollfreePhone: null,
    email: null,
    website: null,
    specialities: null,
    locationCoords: LatLng(11.6357989, 92.7120575),
  ),
  Hospital(
    id: "2",
    latitude: "11.6357989",
    longitude: "92.7120575",
    location: "Near Dollygunj Junction",
    name: "Chakraborty Multi Speciality Hospital",
    district: "South Andaman",
    state: "Andaman and Nicobar Islands",
    pincode: "744101",
    mobile: null,
    emergencyNumber: null,
    ambulancePhone: null,
    bloodbankPhone: null,
    tollfreePhone: null,
    email: null,
    website: null,
    specialities: null,
    locationCoords: LatLng(11.8311681, 92.6586401),
  ),
  Hospital(
    id: "3",
    latitude: "11.6357989",
    longitude: "92.7120575",
    location: "Near Dollygunj Junction",
    name: "Chakraborty Multi Speciality Hospital",
    district: "South Andaman",
    state: "Andaman and Nicobar Islands",
    pincode: "744101",
    mobile: null,
    emergencyNumber: null,
    ambulancePhone: null,
    bloodbankPhone: null,
    tollfreePhone: null,
    email: null,
    website: null,
    specialities: null,
    locationCoords: LatLng(11.8311681, 92.6586401),
  ),
  Hospital(
    id: "4",
    latitude: "11.6357989",
    longitude: "92.7120575",
    location: "Near Dollygunj Junction",
    name: "Chakraborty Multi Speciality Hospital",
    district: "South Andaman",
    state: "Andaman and Nicobar Islands",
    pincode: "744101",
    mobile: null,
    emergencyNumber: null,
    ambulancePhone: null,
    bloodbankPhone: null,
    tollfreePhone: null,
    email: null,
    website: null,
    specialities: null,
    locationCoords: LatLng(11.6498468, 92.7294624),
  ),
];
