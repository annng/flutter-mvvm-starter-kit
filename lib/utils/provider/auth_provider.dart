import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/models/user/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isAuthenticated = false;

  User? get user => _user;

  bool get isAuthenticated => _isAuthenticated;

  final storage = const FlutterSecureStorage();

  AuthProvider() {
    _loadSession();
  }

  // Load session from shared preferences
  Future<void> _loadSession() async {
    final String? userData = await storage.read(key: "user");

    if (userData != null) {
      _user = User.fromJson(jsonDecode(userData));
      _isAuthenticated = true;
    }
    notifyListeners();
  }

  // Login method: Save user to shared preferences
  Future<void> login(User? user) async {
    // Here, we would typically call an API, but we'll simulate the login.
    await storage.write(key: "user", value: user?.toJson().toString());

    _user = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  // Logout method: Clear session
  Future<void> logout() async {
    storage.delete(key: "user");

    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
