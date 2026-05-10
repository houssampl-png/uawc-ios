import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiService {
  String? token;

  Map<String, String> get headers => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    if (token != null && token!.isNotEmpty) 'Authorization': 'Bearer $token',
  };

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/login/user'),
      headers: headers,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> getHome() async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/home'), headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> getConstants() async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/constant'), headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> getPersons() async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/get/person'), headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> createPerson(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/create/person'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> getAidManage() async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/get/aid/manage'), headers: headers);
    return _decode(response);
  }

  Future<Map<String, dynamic>> confirmReceive(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/set/aid/manage/receive'),
      headers: headers,
      body: jsonEncode(data),
    );
    return _decode(response);
  }

  Future<Map<String, dynamic>> getBlocks() async {
    final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/get/blocks'), headers: headers);
    return _decode(response);
  }

  Map<String, dynamic> _decode(http.Response response) {
    final body = response.body.trim().isEmpty ? '{}' : response.body;
    final decoded = jsonDecode(body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('خطأ من السيرفر ${response.statusCode}: $decoded');
    }
    return decoded is Map<String, dynamic> ? decoded : {'data': decoded};
  }
}
