// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:aura_health/main.dart';

void main() {
  testWidgets('Login to dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AuraHealthApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome to AuraHealth'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('AI Doctor Chat'), findsOneWidget);
    expect(find.text('Vitals Detail'), findsOneWidget);
  });
}
