import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  testWidgets('Sign in, create an experience and open its public detail', (
    tester,
  ) async {
    final records = <Map<String, dynamic>>[];
    final api = ApiClient(
      MockClient((request) async {
        switch (request.url.path) {
          case '/api/v1/auth/token/':
            expect(jsonDecode(request.body), {
              'username': 'owner',
              'password': 'secret',
            });
            return http.Response('{"token":"test-token"}', 200);
          case '/api/v1/experiences/':
            if (request.method == 'GET') {
              return http.Response(jsonEncode(records), 200);
            }
            expect(request.headers['Authorization'], 'Token test-token');
            final body = jsonDecode(request.body) as Map<String, dynamic>;
            expect(
              body.keys,
              unorderedEquals([
                'title',
                'description',
                'stage',
                'category',
                'thumbnail',
                'ended_at',
              ]),
            );
            records.add({...body, 'id': 'example-id'});
            return http.Response(jsonEncode(records.single), 201);
          default:
            fail('Unexpected request: ${request.url}');
        }
      }),
    );
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider.value(value: api),
          ChangeNotifierProvider(create: (_) => AuthState(api)),
        ],
        child: MaterialApp(home: MyHomePage()),
      ),
    );
    await tester.tap(find.text('Add Experiences'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'owner');
    await tester.enterText(find.byType(TextFormField).last, 'secret');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Campus research');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'Collected survey data.',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('Experience added successfully!'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Experiences'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Campus research'));
    await tester.pumpAndSettle();
    expect(find.text('Collected survey data.'), findsOneWidget);
    expect(find.text('Ongoing'), findsOneWidget);
  });
}
