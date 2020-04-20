import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalFirestore{
  final num index;
  final String coord;
  final String address;
  final String name;
  final String state;
  final String district;
  final String pincode;
  final String telephone;
  final String mobile;
  final String emergencyNum;
  final String ambulancePhone;
  final String bloodbankPhone;
  final String tollfreePhone;
  final String helpline;
  final String email;
  final String website;
  final String specialties;
  final String facilities;
  final String latitude;
  final String longitude;
  double distance;

  HospitalFirestore({this.index, this.coord, this.address, this.name, this.state, this.district, this.pincode, this.telephone, this.mobile, this.emergencyNum, this.ambulancePhone, this.bloodbankPhone, this.tollfreePhone, this.helpline, this.email, this.website, this.specialties, this.facilities, this.latitude, this.longitude,this.distance});

  factory HospitalFirestore.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return HospitalFirestore(
        index: data["id"],
        coord: data["coord"],
        address: data["address"],
        name: data["name"],
        state: data["state"],
        district: data["district"],
        pincode: data["pincode"],
        telephone: data["telephone"],
        mobile: data["mobile"],
        emergencyNum: data["emergencyNum"],
        ambulancePhone: data["ambulancePhone"],
        bloodbankPhone: data["bloodbankPhone"],
        tollfreePhone: data["tollfreePhone"],
        helpline: data["helpline"],
        email: data["email"],
        website: data["website"],
        specialties: data["specialties"],
        facilities: data["facilities"],
        latitude: data["latitude"],
        longitude: data["longitude"],
        distance: 0.0);
  }

}