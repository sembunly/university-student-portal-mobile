class LocationOption {
  const LocationOption({
    required this.id,
    required this.code,
    required this.name,
    this.nameOther,
  });

  factory LocationOption.fromJson(Map<String, dynamic> json) {
    return LocationOption(
      id: json['id'] as int,
      code: json['code'] as String,
      name: json['name'] as String,
      nameOther: json['name_other'] as String?,
    );
  }

  final int id;
  final String code;
  final String name;
  final String? nameOther;
}
