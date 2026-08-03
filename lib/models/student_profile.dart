class StudentProfile {
  const StudentProfile({
    this.nameKm,
    this.nameEn,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.email,
    this.currentProvinceId,
    this.currentDistrictId,
    this.currentCommuneId,
    this.currentVillageId,
    this.currentHouse,
    this.currentStreet,
    this.permanentProvinceId,
    this.permanentDistrictId,
    this.permanentCommuneId,
    this.permanentVillageId,
    this.permanentHouse,
    this.permanentStreet,
    this.fatherName,
    this.fatherOccupation,
    this.fatherPhone,
    this.motherName,
    this.motherOccupation,
    this.motherPhone,
    this.emergencyName,
    this.emergencyPhone,
    this.highSchool,
    this.graduationYear,
    this.educationProvinceId,
    this.certificate,
  });

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      nameKm: json['name_km'] as String?,
      nameEn: json['name_en'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      nationality: json['nationality'] as String?,
      email: json['email'] as String?,
      currentProvinceId: json['current_province_id'] as int?,
      currentDistrictId: json['current_district_id'] as int?,
      currentCommuneId: json['current_commune_id'] as int?,
      currentVillageId: json['current_village_id'] as int?,
      currentHouse: json['current_house'] as String?,
      currentStreet: json['current_street'] as String?,
      permanentProvinceId: json['permanent_province_id'] as int?,
      permanentDistrictId: json['permanent_district_id'] as int?,
      permanentCommuneId: json['permanent_commune_id'] as int?,
      permanentVillageId: json['permanent_village_id'] as int?,
      permanentHouse: json['permanent_house'] as String?,
      permanentStreet: json['permanent_street'] as String?,
      fatherName: json['father_name'] as String?,
      fatherOccupation: json['father_occupation'] as String?,
      fatherPhone: json['father_phone'] as String?,
      motherName: json['mother_name'] as String?,
      motherOccupation: json['mother_occupation'] as String?,
      motherPhone: json['mother_phone'] as String?,
      emergencyName: json['emergency_name'] as String?,
      emergencyPhone: json['emergency_phone'] as String?,
      highSchool: json['high_school'] as String?,
      graduationYear: json['graduation_year'] as int?,
      educationProvinceId: json['education_province_id'] as int?,
      certificate: json['certificate'] as String?,
    );
  }

  final String? nameKm;
  final String? nameEn;
  final String? dateOfBirth;
  final String? gender;
  final String? nationality;
  final String? email;
  final int? currentProvinceId;
  final int? currentDistrictId;
  final int? currentCommuneId;
  final int? currentVillageId;
  final String? currentHouse;
  final String? currentStreet;
  final int? permanentProvinceId;
  final int? permanentDistrictId;
  final int? permanentCommuneId;
  final int? permanentVillageId;
  final String? permanentHouse;
  final String? permanentStreet;
  final String? fatherName;
  final String? fatherOccupation;
  final String? fatherPhone;
  final String? motherName;
  final String? motherOccupation;
  final String? motherPhone;
  final String? emergencyName;
  final String? emergencyPhone;
  final String? highSchool;
  final int? graduationYear;
  final int? educationProvinceId;
  final String? certificate;
}
