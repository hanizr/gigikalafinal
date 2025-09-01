// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class ApiService {
  String? token;

  final _timeout = const Duration(seconds: 12);

  Future<dynamic> get(String path, [Map<String, String>? params]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: params);
    final res = await http.get(uri, headers: _headers());
    _ensureOk(res);
    return json.decode(res.body); // ممکنه List یا Map باشه
  }

  Future<Map<String, dynamic>> post(String path, Map body) async {
    final res = await http
        .post(Uri.parse('$baseUrl$path'), headers: _headers(), body: json.encode(body))
        .timeout(_timeout);
    _ensureOk(res);
    return json.decode(res.body);
  }

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  void _ensureOk(http.Response r) {
    if (r.statusCode < 200 || r.statusCode >= 300) throw Exception(r.body);
  }
}