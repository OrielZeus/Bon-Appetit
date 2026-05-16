import 'dart:convert';
import 'dart:io';

import 'package:bon_appetit/src/core/config/app_config.dart';

class ApiClient {
  ApiClient({HttpClient? httpClient})
      : _httpClient = httpClient ?? HttpClient();

  final HttpClient _httpClient;

  Future<Map<String, dynamic>> getJson(String path) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final request = await _httpClient.getUrl(uri).timeout(AppConfig.apiTimeout);
    final response = await request.close().timeout(AppConfig.apiTimeout);
    final body = await response.transform(utf8.decoder).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException('GET $path failed with ${response.statusCode}: $body');
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw ApiException('GET $path returned an unexpected response.');
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
