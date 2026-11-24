import 'dart:convert';

import 'package:cv_flutter_jonathan/pages/famille_page.dart';
import 'package:cv_flutter_jonathan/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets(
      'ajouter un membre ferme le formulaire sans erreur de cycle de vie',
      (tester) async {
    var membreCree = false;
    final client = MockClient((request) async {
      if (request.method == 'POST') {
        membreCree = true;
        return http.Response(
          jsonEncode({
            'success': true,
            'data': {'id': 1}
          }),
          201,
        );
      }

      final membres = membreCree
          ? [
              {
                'id': 1,
                'nom': 'Test',
                'postnom': 'Famille',
                'prenom': 'Alex',
                'lieu_naissance': 'Goma',
                'date_naissance': '1990-01-01',
                'parente': 'Frere',
                'image_url': null,
              }
            ]
          : <Map<String, dynamic>>[];
      return http.Response(
        jsonEncode({'success': true, 'data': membres}),
        200,
      );
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FamillePage(
            api: ApiService(
              client: client,
              baseUrl: 'http://localhost/public',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Ajouter un membre'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Test');
    await tester.enterText(fields.at(1), 'Famille');
    await tester.enterText(fields.at(2), 'Alex');
    await tester.enterText(fields.at(3), 'Goma');
    await tester.enterText(fields.at(4), '1990-01-01');
    await tester.enterText(fields.at(5), 'Frere');

    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter'));
    await tester.pumpAndSettle();

    expect(find.text('Alex Test Famille'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
