import 'dart:convert';
import 'package:awlad_khedr/constant.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String apiUrl = APIConstant.LOGIN_USER;

  Future<String?> login(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'username': userName, 'password': password}),

      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['token'];
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
