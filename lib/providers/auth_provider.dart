import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  static const String _usersKey = 'registered_users';

  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token {
    return _token;
  }

  bool get isLoading {
    return _isLoading;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  bool get isLoggedIn {
    return _token != null && _token!.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final rawData = prefs.getString(_usersKey);

    if (rawData == null || rawData.isEmpty) {
      return [];
    }

    final decodedData = jsonDecode(rawData);

    if (decodedData is List) {
      return decodedData.map((item) {
        return Map<String, dynamic>.from(item);
      }).toList();
    }

    return [];
  }

  Future<void> _saveUsers(List<Map<String, dynamic>> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  Future<bool> register({
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanUsername = username.trim();
    final cleanPassword = password.trim();
    final cleanConfirmPassword = confirmPassword.trim();

    if (cleanUsername.isEmpty ||
        cleanPassword.isEmpty ||
        cleanConfirmPassword.isEmpty) {
      _errorMessage = 'กรุณากรอกข้อมูลให้ครบถ้วน';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (cleanPassword.length < 6) {
      _errorMessage = 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (cleanPassword != cleanConfirmPassword) {
      _errorMessage = 'รหัสผ่านและยืนยันรหัสผ่านไม่ตรงกัน';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final users = await _loadUsers();

    final isDuplicate = users.any((user) {
      return user['username'] == cleanUsername;
    });

    if (isDuplicate) {
      _errorMessage = 'Username นี้ถูกสมัครใช้งานแล้ว';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    users.add({'username': cleanUsername, 'password': cleanPassword});

    await _saveUsers(users);

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final cleanUsername = username.trim();
    final cleanPassword = password.trim();

    if (cleanUsername.isEmpty || cleanPassword.isEmpty) {
      _errorMessage = 'กรุณากรอก Username และ Password';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    final users = await _loadUsers();

    final isFound = users.any((user) {
      return user['username'] == cleanUsername &&
          user['password'] == cleanPassword;
    });

    if (isFound) {
      _token = 'local_token_${DateTime.now().millisecondsSinceEpoch}';
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _errorMessage = 'ไม่พบบัญชีผู้ใช้ กรุณาสมัครสมาชิกก่อนเข้าสู่ระบบ';
    _isLoading = false;
    notifyListeners();
    return false;
  }

  void logout() {
    _token = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
