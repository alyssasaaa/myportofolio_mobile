import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/experience.dart';

class ApiException implements Exception {
  const ApiException(this.status, this.message);
  final int status;
  final String message;
  bool get invalidToken =>
      status == 401 || (status == 403 && message == 'Invalid token.');
  @override
  String toString() => '$message ($status)';
}

class ApiClient {
  ApiClient(this.client);
  final http.Client client;
  Uri _uri(String path) => Uri.parse('$apiBaseUrl/api/v1/$path/');

  Future<List<Experience>> getExperiences() async {
    final response = await client.get(
      _uri('experiences'),
      headers: {'Accept': 'application/json'},
    );
    _check(response);
    return (jsonDecode(utf8.decode(response.bodyBytes)) as List)
        .map((item) => Experience.fromJson(item))
        .toList();
  }

  Future<http.Response> _post(
    String path, {
    Object? body,
    String? token,
  }) async {
    final response = await client.post(
      _uri(path),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        if (token != null) 'Authorization': 'Token $token',
      },
      body: body == null ? null : jsonEncode(body),
    );
    _check(response);
    return response;
  }

  Future<String> obtainToken(String username, String password) async {
    final response = await _post(
      'auth/token',
      body: {'username': username, 'password': password},
    );
    return jsonDecode(response.body)['token'] as String;
  }

  Future<Experience> createExperience(
    Experience experience,
    String token,
  ) async {
    final response = await _post(
      'experiences',
      body: experience.toJson(),
      token: token,
    );
    return Experience.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  }

  Future<void> logout(String token) async =>
      await _post('auth/logout', token: token);

  void _check(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    var message = 'Request failed';
    if (response.headers['content-type']?.contains('application/json') ==
        true) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is Map && data.isNotEmpty) {
        final value = data.values.first;
        if (value is List && value.isNotEmpty) {
          message = '${data.keys.first}: ${value.first}';
        } else if (value is String) {
          message = value;
        }
      }
    }
    throw ApiException(response.statusCode, message);
  }
}
