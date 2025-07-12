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

  // 여기에 pharmacySignup(), loginUser(), loginPharmacy() 등 추가 가능
}
