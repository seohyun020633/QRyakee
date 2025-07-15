import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://3.106.67.244:8000';

  static Future<http.Response> userSignup(Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/signup/user/');
    return await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
  }

  static Future<http.Response> loginUser(String id, String pw) async {
    final url = Uri.parse('$baseUrl/login/user/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': id, 'user_password': pw}),
    );
  }

  static Future<http.Response> checkUserId(String userId) async {
    final uri = Uri.parse('$baseUrl/signup/check_user_id?user_id=$userId');
    return await http.get(uri);
  }

  static Future<http.Response> loginPharmacy(String id, String pw) async {
    final url = Uri.parse('$baseUrl/login/pharmacy/');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pharmacy_id': id, 'pharmacy_password': pw}),
    );
  }

  // 여기에 pharmacySignup(), loginUser(), loginPharmacy() 등 추가 가능
}
