import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_endpoint.dart';
import '../models/profile_update_request.dart';
import '../models/student_account.dart';
import '../models/student_profile.dart';

class AuthResult {
  const AuthResult({required this.token, required this.account});

  final String token;
  final StudentAccount account;
}

class ProfileResult {
  const ProfileResult({required this.account, this.profile});

  final StudentAccount account;
  final StudentProfile? profile;
}

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<AuthResult> login({required String login, required String password}) {
    return _authenticate(ApiConfig.loginPath, {
      'login': login.trim(),
      'password': password,
      'device_name': 'Pixel 9',
    });
  }

  Future<AuthResult> register({
    required String phone,
    required String password,
  }) {
    return _authenticate(ApiConfig.registerPath, {
      'phone': phone.trim(),
      'password': password,
      'password_confirmation': password,
      'device_name': 'USP iOS',
    });
  }

  Future<StudentAccount> me(String token) async {
    final response = await _client
        .get(ApiConfig.uri(ApiConfig.mePath), headers: _headers(token: token))
        .timeout(const Duration(seconds: 15));
    final body = _decode(response);

    return StudentAccount.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<ProfileResult> profile(String token) async {
    final response = await _client
        .get(
          ApiConfig.uri(ApiConfig.profilePath),
          headers: _headers(token: token),
        )
        .timeout(const Duration(seconds: 15));
    final body = _decode(response);
    final data = body['data'] as Map<String, dynamic>;
    final profile = data['profile'];

    return ProfileResult(
      account: StudentAccount.fromJson(
        data['account'] as Map<String, dynamic>,
      ),
      profile: profile is Map<String, dynamic>
          ? StudentProfile.fromJson(profile)
          : null,
    );
  }

  Future<ProfileResult> updateProfile(
    String token,
    ProfileUpdateRequest request,
  ) async {
    final response = await _client
        .post(
          ApiConfig.uri(ApiConfig.profilePath),
          headers: _headers(token: token),
          body: jsonEncode(request.toJson()),
        )
        .timeout(const Duration(seconds: 15));
    _decode(response);

    return profile(token);
  }

  Future<void> logout(String token) async {
    final response = await _client
        .post(
          ApiConfig.uri(ApiConfig.logoutPath),
          headers: _headers(token: token),
        )
        .timeout(const Duration(seconds: 15));
    _decode(response);
  }

  Future<AuthResult> _authenticate(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client
        .post(
          ApiConfig.uri(path),
          headers: _headers(),
          body: jsonEncode(payload),
        )
        .timeout(const Duration(seconds: 15));
    final body = _decode(response);
    final data = body['data'] as Map<String, dynamic>;

    return AuthResult(
      token: data['token'] as String,
      account: StudentAccount.fromJson(data['account'] as Map<String, dynamic>),
    );
  }

  Map<String, String> _headers({String? token}) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _decode(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException {
      throw ApiException(
        'The server returned an unexpected response.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    final errors = body['errors'];
    String? firstError;
    if (errors is Map && errors.isNotEmpty) {
      final value = errors.values.first;
      if (value is List && value.isNotEmpty) {
        firstError = value.first.toString();
      }
    }

    throw ApiException(
      firstError ?? body['message']?.toString() ?? 'Something went wrong.',
      statusCode: response.statusCode,
    );
  }
}
