import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/student_account.dart';
import 'api_service.dart';

class AuthStore extends ChangeNotifier {
  AuthStore({ApiService? api, FlutterSecureStorage? storage})
    : _api = api ?? ApiService(),
      _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'student_api_token';

  final ApiService _api;
  final FlutterSecureStorage _storage;

  StudentAccount? account;
  String? _token;
  bool isBusy = false;
  String? errorMessage;

  bool get isAuthenticated => _token != null && account != null;

  Future<void> restoreSession() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) return;

    try {
      account = await _api.me(token);
      _token = token;
    } catch (_) {
      await _storage.delete(key: _tokenKey);
    }
  }

  Future<bool> login({required String login, required String password}) {
    return _perform(() => _api.login(login: login, password: password));
  }

  Future<bool> register({required String phone, required String password}) {
    return _perform(() => _api.register(phone: phone, password: password));
  }

  Future<void> logout() async {
    final token = _token;
    account = null;
    _token = null;
    notifyListeners();
    await _storage.delete(key: _tokenKey);

    if (token != null) {
      try {
        await _api.logout(token);
      } catch (_) {
        // The local session is already cleared.
      }
    }
  }

  Future<bool> _perform(Future<AuthResult> Function() request) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await request();
      _token = result.token;
      account = result.account;
      await _storage.write(key: _tokenKey, value: result.token);
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    } catch (_) {
      errorMessage =
          'We could not reach the server. Check your connection and try again.';
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}
