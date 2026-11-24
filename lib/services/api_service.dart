import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/famille_membre.dart';

class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost/api-test/public',
        )).replaceFirst(RegExp(r'/$'), '');

  final http.Client _client;
  final String _baseUrl;

  Future<void> login(String email, String password) async {
    await _request('POST', '/accounts/login', {
      'email': email,
      'password': password,
    });
  }

  Future<void> register(String email, String password) async {
    await _request('POST', '/accounts/register', {
      'email': email,
      'password': password,
    });
  }

  Future<List<FamilleMembre>> getMembres() async {
    final data = await _request('GET', '/famille-membres');
    if (data is! List) {
      throw const ApiException('Format de liste des membres invalide.');
    }
    try {
      return data.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Format de membre invalide.');
        }
        return FamilleMembre.fromJson(item);
      }).toList();
    } on FormatException catch (error) {
      throw ApiException(error.message);
    }
  }

  Future<void> createMembre(Map<String, String> fields) async {
    await _request('POST', '/famille-membres', fields);
  }

  Future<void> updateMembre(int id, Map<String, String> fields) async {
    await _request('PUT', '/famille-membres/$id', fields);
  }

  Future<void> deleteMembre(int id) async {
    await _request('DELETE', '/famille-membres/$id');
  }

  Future<dynamic> _request(
    String method,
    String path, [
    Map<String, String>? body,
  ]) async {
    final request = http.Request(method, Uri.parse('$_baseUrl$path'));
    if (body != null) {
      request.headers['Content-Type'] = 'application/json';
      request.body = jsonEncode(body);
    }

    late http.StreamedResponse streamedResponse;
    try {
      streamedResponse = await _client.send(request);
    } on http.ClientException {
      throw const ApiException(
        'Impossible de joindre l’API. Vérifiez son adresse et sa disponibilité.',
      );
    }

    final responseBody = await streamedResponse.stream.bytesToString();
    Map<String, dynamic> response;
    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException();
      }
      response = decoded;
    } on FormatException {
      throw ApiException(
        'Réponse API invalide (HTTP ${streamedResponse.statusCode}).',
      );
    }

    if (streamedResponse.statusCode < 200 ||
        streamedResponse.statusCode >= 300 ||
        response['success'] != true) {
      final message = response['message'];
      throw ApiException(
        message is String ? message : 'Erreur API ${streamedResponse.statusCode}.',
      );
    }

    return response['data'];
  }
}
