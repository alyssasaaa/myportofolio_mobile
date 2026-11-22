import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportofolio_mobile/main.dart';

void main() {
  for (final width in [320.0, 390.0, 430.0]) {
    testWidgets('Home actions fit a ${width}px screen', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = Size(width, 568);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const MyApp());
      expect(tester.takeException(), isNull);

      final action = find.text('Add Competitions');
      await tester.ensureVisible(action);
      await tester.pumpAndSettle();
      await tester.tap(action);
      await tester.pumpAndSettle();
      expect(find.text('Add Competition Form'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
