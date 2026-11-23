import 'dart:convert';

import 'package:http/http.dart' as http;

import '../features/guide/travel_service.dart';
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
