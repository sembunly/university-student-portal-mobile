class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.nameKm,
    required this.nameEn,
    required this.gender,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.currentProvinceId,
    required this.currentDistrictId,
    required this.currentCommuneId,
    required this.currentVillageId,
    required this.permanentProvinceId,
    required this.permanentDistrictId,
    required this.permanentCommuneId,
    required this.permanentVillageId,
    this.dateOfBirth,
    this.nationality,
    this.email,
    this.currentHouse,
    this.currentStreet,
    this.permanentHouse,
    this.permanentStreet,
    this.fatherName,
    this.fatherOccupation,
    this.fatherPhone,
    this.motherName,
    this.motherOccupation,
    this.motherPhone,
    this.highSchool,
    this.graduationYear,
    this.educationProvinceId,
  });

  final String nameKm;
  final String nameEn;
  final String gender;
  final String emergencyName;
  final String emergencyPhone;
  final int currentProvinceId;
  final int currentDistrictId;
  final int currentCommuneId;
  final int currentVillageId;
  final int permanentProvinceId;
  final int permanentDistrictId;
  final int permanentCommuneId;
  final int permanentVillageId;
  final String? dateOfBirth;
  final String? nationality;
  final String? email;
  final String? currentHouse;
  final String? currentStreet;
  final String? permanentHouse;
  final String? permanentStreet;
  final String? fatherName;
  final String? fatherOccupation;
  final String? fatherPhone;
  final String? motherName;
  final String? motherOccupation;
  final String? motherPhone;
  final String? highSchool;
  final int? graduationYear;
  final int? educationProvinceId;

  Map<String, dynamic> toJson() => {
    'name_km': nameKm.trim(),
    'name_en': nameEn.trim(),
    'gender': gender,
    'emergency_name': emergencyName.trim(),
    'emergency_phone': emergencyPhone.trim(),
    'current_province_id': currentProvinceId,
    'current_district_id': currentDistrictId,
    'current_commune_id': currentCommuneId,
    'current_village_id': currentVillageId,
    'permanent_province_id': permanentProvinceId,
    'permanent_district_id': permanentDistrictId,
    'permanent_commune_id': permanentCommuneId,
    'permanent_village_id': permanentVillageId,
    'date_of_birth': _text(dateOfBirth),
    'nationality': _text(nationality),
    'email': _text(email),
    'current_house': _text(currentHouse),
    'current_street': _text(currentStreet),
    'permanent_house': _text(permanentHouse),
    'permanent_street': _text(permanentStreet),
    'father_name': _text(fatherName),
    'father_occupation': _text(fatherOccupation),
    'father_phone': _text(fatherPhone),
    'mother_name': _text(motherName),
    'mother_occupation': _text(motherOccupation),
    'mother_phone': _text(motherPhone),
    'high_school': _text(highSchool),
    'graduation_year': graduationYear,
    'education_province_id': educationProvinceId,
  };

  static String? _text(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
