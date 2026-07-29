import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/student_account.dart';

const _defaultBaseUrl = 'http://127.0.0.1:8000/api/v1';
const apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: _defaultBaseUrl,
);

class AuthResult {
  const AuthResult({required this.token, required this.account});

  final String token;
  final StudentAccount account;
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
    return _authenticate('/auth/login', {
      'login': login.trim(),
      'password': password,
      'device_name': 'USP iOS',
    });
  }

  Future<AuthResult> register({
    required String phone,
    required String password,
  }) {
    return _authenticate('/auth/register', {
      'phone': phone.trim(),
      'password': password,
      'password_confirmation': password,
      'device_name': 'USP iOS',
    });
  }

  Future<StudentAccount> me(String token) async {
    final response = await _client
        .get(Uri.parse('$apiBaseUrl/auth/me'), headers: _headers(token: token))
        .timeout(const Duration(seconds: 15));
    final body = _decode(response);

    return StudentAccount.fromJson(body['data'] as Map<String, dynamic>);
  }

  Future<void> logout(String token) async {
    final response = await _client
        .post(
          Uri.parse('$apiBaseUrl/auth/logout'),
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
          Uri.parse('$apiBaseUrl$path'),
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
