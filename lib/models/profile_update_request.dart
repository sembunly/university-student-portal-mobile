class ProfileUpdateRequest {
  const ProfileUpdateRequest({
    required this.emergencyPhone,
    required this.currentCommuneId,
    required this.gender,
    required this.currentProvinceId,
    required this.currentDistrictId,
    required this.motherOccupation,
    required this.motherName,
    required this.dateOfBirth,
    required this.currentStreet,
    required this.fatherPhone,
    required this.permanentCommuneId,
    required this.fatherOccupation,
    required this.graduationYear,
    required this.fatherName,
    required this.permanentHouse,
    required this.highSchool,
    required this.motherPhone,
    required this.educationProvinceId,
    required this.currentVillageId,
    required this.permanentStreet,
    required this.nameKm,
    required this.certificate,
    required this.emergencyName,
    required this.permanentProvinceId,
    required this.currentHouse,
    required this.permanentDistrictId,
    required this.nationality,
    required this.email,
    required this.nameEn,
    required this.permanentVillageId,
  });

  final String emergencyPhone;
  final String currentCommuneId;
  final String gender;
  final String currentProvinceId;
  final String currentDistrictId;
  final String motherOccupation;
  final String motherName;
  final String dateOfBirth;
  final String currentStreet;
  final String fatherPhone;
  final String permanentCommuneId;
  final String fatherOccupation;
  final int graduationYear;
  final String fatherName;
  final String permanentHouse;
  final String highSchool;
  final String motherPhone;
  final String educationProvinceId;
  final String currentVillageId;
  final String permanentStreet;
  final String nameKm;
  final String certificate;
  final String emergencyName;
  final String permanentProvinceId;
  final String currentHouse;
  final String permanentDistrictId;
  final String nationality;
  final String email;
  final String nameEn;
  final String permanentVillageId;

  Map<String, dynamic> toJson() => {
    'emergency_phone': _field(emergencyPhone),
    'current_commune_id': _field(currentCommuneId),
    'gender': _field(gender),
    'current_province_id': _field(currentProvinceId),
    'current_district_id': _field(currentDistrictId),
    'mother_occupation': _field(motherOccupation),
    'mother_name': _field(motherName),
    'date_of_birth': _field(dateOfBirth),
    'current_street': _field(currentStreet),
    'father_phone': _field(fatherPhone),
    'permanent_commune_id': _field(permanentCommuneId),
    'father_occupation': _field(fatherOccupation),
    'graduation_year': _field(graduationYear),
    'father_name': _field(fatherName),
    'permanent_house': _field(permanentHouse),
    'high_school': _field(highSchool),
    'mother_phone': _field(motherPhone),
    'education_province_id': _field(educationProvinceId),
    'current_village_id': _field(currentVillageId),
    'permanent_street': _field(permanentStreet),
    'name_km': _field(nameKm),
    'certificate': _field(certificate),
    'emergency_name': _field(emergencyName),
    'permanent_province_id': _field(permanentProvinceId),
    'current_house': _field(currentHouse),
    'permanent_district_id': _field(permanentDistrictId),
    'nationality': _field(nationality),
    'email': _field(email),
    'name_en': _field(nameEn),
    'permanent_village_id': _field(permanentVillageId),
  };

  static Map<String, dynamic> _field(Object value) => {
    'value': value,
    'errors': <String>[],
  };
}
