class Hospital {
  final String id;
  final String latitude;
  final String longitude;
  final String location;
  final String name;
  final String district;
  final String state;
  final String pincode;
  final String telephone;
  final String mobile;
  final String emergencyNumber;
  final String ambulancePhone;
  final String bloodbankPhone;
  final String tollfreePhone;
  final String email;
  final String website;
  final String specialities;

  Hospital(
      this.id,
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
      this.specialities);
}

List<Hospital> hospitals = [];
