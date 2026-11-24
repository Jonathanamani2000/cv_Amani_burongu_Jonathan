import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:cv_flutter_jonathan/services/api_service.dart';

void main() {
  test('login envoie les identifiants à l’API', () async {
    final client = MockClient((request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/public/accounts/login');
      expect(jsonDecode(request.body), {
        'email': 'test@example.com',
        'password': 'secret123',
      });
      return http.Response(
        jsonEncode({
          'success': true,
          'data': {'id': 1}
        }),
        200,
      );
    });

    await ApiService(
      client: client,
      baseUrl: 'http://localhost/public/',
    ).login('test@example.com', 'secret123');
  });

  test('les erreurs de connexion retournées par l’API sont propagées',
      () async {
    final service = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'success': false,
            'message': 'Email ou mot de passe incorrect',
          }),
          401,
        ),
      ),
      baseUrl: 'http://localhost/public',
    );

    await expectLater(
      service.login('test@example.com', 'wrong'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.message,
          'message',
          'Email ou mot de passe incorrect',
        ),
      ),
    );
  });

  test('la liste des membres est décodée depuis la réponse API', () async {
    final service = ApiService(
      client: MockClient(
        (_) async => http.Response.bytes(
          utf8.encode(
            jsonEncode({
              'success': true,
              'data': [
                {
                  'id': 5,
                  'nom': 'Baraka',
                  'postnom': 'Bigega',
                  'prenom': 'Papa',
                  'lieu_naissance': 'Goma',
                  'date_naissance': '1970-05-12',
                  'parente': 'Père',
                  'image_url': null,
                },
              ],
            }),
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      ),
      baseUrl: 'http://localhost/public',
    );

    final membres = await service.getMembres();

    expect(membres, hasLength(1));
    expect(membres.single.id, 5);
    expect(membres.single.prenom, 'Papa');
    expect(membres.single.imageUrl, isNull);
  });

  test('create, update et delete utilisent les méthodes et chemins API',
      () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(jsonEncode({'success': true, 'data': {}}), 200);
    });
    final service = ApiService(
      client: client,
      baseUrl: 'http://localhost/public',
    );
    const fields = {
      'nom': 'Baraka',
      'postnom': 'Bigega',
      'prenom': 'Papa',
      'lieu_naissance': 'Goma',
      'date_naissance': '1970-05-12',
      'parente': 'Père',
    };

    await service.createMembre(fields);
    await service.updateMembre(5, fields);
    await service.deleteMembre(5);

    expect(
      requests.map((request) => '${request.method} ${request.url.path}'),
      [
        'POST /public/famille-membres',
        'PUT /public/famille-membres/5',
        'DELETE /public/famille-membres/5',
      ],
    );
    expect(jsonDecode(requests.first.body), fields);
  });
}
