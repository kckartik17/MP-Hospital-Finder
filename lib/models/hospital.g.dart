// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hospital _$HospitalFromJson(Map<String, dynamic> json) {
  return Hospital()
    ..index = json['index'] as num
    ..coord = json['coord'] as String
    ..address = json['address'] as String
    ..name = json['name'] as String
    ..state = json['state'] as String
    ..district = json['district'] as String
    ..pincode = json['pincode'] as String
    ..telephone = json['telephone'] as String
    ..mobile = json['mobile'] as String
    ..emergencyNum = json['emergencyNum'] as String
    ..ambulancePhone = json['ambulancePhone'] as String
    ..bloodbankPhone = json['bloodbankPhone'] as String
    ..tollfreePhone = json['tollfreePhone'] as String
    ..helpline = json['Helpline'] as String
    ..email = json['email'] as String
    ..website = json['website'] as String
    ..specialties = json['specialties'] as String
    ..facilities = json['facilities'] as String
    ..latitude = json['latitude'] as String
    ..longitude = json['longitude'] as String;
}

Map<String, dynamic> _$HospitalToJson(Hospital instance) => <String, dynamic>{
      'index': instance.index,
      'coord': instance.coord,
      'address': instance.address,
      'name': instance.name,
      'state': instance.state,
      'district': instance.district,
      'pincode': instance.pincode,
      'telephone': instance.telephone,
      'mobile': instance.mobile,
      'emergencyNum': instance.emergencyNum,
      'ambulancePhone': instance.ambulancePhone,
      'bloodbankPhone': instance.bloodbankPhone,
      'tollfreePhone': instance.tollfreePhone,
      'Helpline': instance.helpline,
      'email': instance.email,
      'website': instance.website,
      'specialties': instance.specialties,
      'facilities': instance.facilities,
      'latitude': instance.latitude,
      'longitude': instance.longitude
    };
