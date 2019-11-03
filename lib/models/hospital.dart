import 'package:json_annotation/json_annotation.dart';

part 'hospital.g.dart';

@JsonSerializable()
class Hospital {
    Hospital();

    num index;
    String coord;
    String address;
    String name;
    String state;
    String district;
    String pincode;
    String telephone;
    String mobile;
    String emergencyNum;
    String ambulancePhone;
    String bloodbankPhone;
    String tollfreePhone;
    String Helpline;
    String email;
    String website;
    String specialties;
    String facilities;
    String latitude;
    String longitude;
    
    factory Hospital.fromJson(Map<String,dynamic> json) => _$HospitalFromJson(json);
    Map<String, dynamic> toJson() => _$HospitalToJson(this);
}
