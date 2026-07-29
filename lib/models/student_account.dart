class StudentAccount {
  const StudentAccount({
    required this.id,
    required this.phone,
    required this.profileCompleted,
    this.studentId,
  });

  factory StudentAccount.fromJson(Map<String, dynamic> json) {
    return StudentAccount(
      id: json['id'] as int,
      phone: json['phone'] as String,
      studentId: json['student_id'] as String?,
      profileCompleted: json['profile_completed'] as bool? ?? false,
    );
  }

  final int id;
  final String phone;
  final String? studentId;
  final bool profileCompleted;
}
