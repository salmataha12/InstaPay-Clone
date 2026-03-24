import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage_service.dart';

class ApiClient {
  static const String baseUrl = 'https://api.instapay-clone.com'; // Must be HTTPS
  static final http.Client _client = http.Client();

  /// Enforces HTTPS strictly internally
  static void _enforceHttps(String endpoint) {
    if (!baseUrl.startsWith('https://')) {
      throw Exception('Insecure connection attempt! Only HTTPS (TLS 1.3) is permitted.');
    }
  }

  /// Builds standardized headers including dynamic secure JWT tokens
  static Future<Map<String, String>> _buildHeaders() async {
    final token = await SecureStorageService.getToken();
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token'; // JWT Interceptor
    }

    return headers;
  }

  /// Secure GET request
  static Future<http.Response> get(String endpoint) async {
    _enforceHttps(endpoint);
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await _client.get(uri, headers: headers);
  }

  /// Secure POST request
  static Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    _enforceHttps(endpoint);
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  /// Secure PUT request
  static Future<http.Response> put(String endpoint, {Map<String, dynamic>? body}) async {
    _enforceHttps(endpoint);
    final headers = await _buildHeaders();
    final uri = Uri.parse('$baseUrl$endpoint');

    return await _client.put(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
