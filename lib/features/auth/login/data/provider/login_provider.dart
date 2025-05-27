// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/login_service.dart';
//
// class LoginProvider extends ChangeNotifier {
//   String? _token;
//   bool _isLoading = false;
//
//   final LoginService _loginService = LoginService();
//   final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
//
//   String? get token => _token;
//   bool get isLoading => _isLoading;
//
//   /// Login and save token
//   Future<void> login(String userName, String password) async {
//     if (userName.isEmpty || password.isEmpty) {
//       print('Username and password are required.');
//       return;
//     }
//
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final fetchedToken = await _loginService.login(userName, password);
//       if (fetchedToken != null) {
//         _token = fetchedToken;
//         await saveToken(fetchedToken);
//         print('Token: $_token');
//       } else {
//         print('Failed to log in. Token is null.');
//       }
//     } catch (error) {
//       print('Error during login: $error');
//     }
//
//     _isLoading = false;
//     notifyListeners();
//   }
//
//   /// Save token to secure storage
//   Future<void> saveToken(String token) async {
//     await _secureStorage.write(key: 'token', value: token);
//     print('Token securely saved: $token');
//   }
//
//   /// Load token from secure storage
//   Future<void> loadToken() async {
//     _token = await _secureStorage.read(key: 'token');
//     print('Token loaded securely: $_token');
//     notifyListeners();
//   }
//
//   /// Log out the user and clear token
//   Future<void> logout() async {
//     _token = null;
//     await _secureStorage.delete(key: 'token');
//     print('Token securely removed from storage.');
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_service.dart';

class LoginProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;

  final LoginService _loginService = LoginService();

  String? get token => _token;
  bool get isLoading => _isLoading;

  /// Login and save token
  Future<void> login(String userName, String password) async {
    if (userName.isEmpty || password.isEmpty) {
      print('Username and password are required.');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final fetchedToken = await _loginService.login(userName, password);
      if (fetchedToken != null) {
        _token = fetchedToken;
        await saveToken(fetchedToken);
        print('Token: $_token');
      } else {
        print('Failed to log in. Token is null.');
      }
    } catch (error) {
      print('Error during login: $error');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Save token to SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('Token saved using SharedPreferences: $token');
  }

  // Load token from SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    print('Token loaded from SharedPreferences: $_token');
    notifyListeners();
  }

  /// Log out the user and clear token
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    print('Token removed from SharedPreferences.');
    notifyListeners();
  }
}
