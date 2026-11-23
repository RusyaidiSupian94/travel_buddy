import 'dart:convert';

import 'package:http/http.dart' as http;

import '../features/guide/travel_service.dart';
import 'app_session.dart';
import 'auth_request.dart';
import 'api_config.dart';

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<List<TravelService>> getServices() async {
    final response = await _client
        .get(
          Uri.parse('${ApiConfig.baseUrl}/api/services'),
          headers: const {
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        'API returned status ${response.statusCode}.',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const ApiException('Unexpected service response.');
    }

    return decoded
        .map(
          (item) => TravelService.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }

  Future<AppSession> login(AuthRequest request) {
    return _postAuth(
      path: '/api/auth/login',
      body: {
        'email': request.email,
        'password': request.password,
      },
    );
  }

  Future<AppSession> register(AuthRequest request) {
    return _postAuth(
      path: '/api/auth/register',
      body: {
        'displayName': request.displayName,
        'email': request.email,
        'password': request.password,
        'confirmPassword': request.confirmPassword,
        'role': request.role.name,
      },
    );
  }

  Future<AppSession> _postAuth({
    required String path,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}$path'),
          headers: const {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 10));

    final decoded = response.body.isEmpty ? null : jsonDecode(response.body);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message'] as String?
          : null;
      throw ApiException(message ?? 'Authentication request failed.');
    }

    if (decoded is! Map) {
      throw const ApiException('Unexpected authentication response.');
    }

    return AppSession.fromJson(
      Map<String, dynamic>.from(decoded),
    );
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}
