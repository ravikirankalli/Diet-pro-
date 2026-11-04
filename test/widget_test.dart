import 'package:flutter/material.dart';
import 'dart:io';

import 'package:diet_pro/models/dashboard_data.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:diet_pro/main.dart';
import 'package:diet_pro/screens/login_screen.dart';

void main() {
  _assetTests();
  _greetingTests();
  testWidgets('splash shows the attribution and moves on to the login screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DietProApp());

    expect(find.text('Andhra Educational Trust'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('sign in requires both fields', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your Dietitian ID'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });
}

void _greetingTests() {
  test('greeting follows the time of day', () {
    expect(greetingForHour(0), 'GOOD MORNING');
    expect(greetingForHour(11), 'GOOD MORNING');
    expect(greetingForHour(12), 'GOOD AFTERNOON');
    expect(greetingForHour(16), 'GOOD AFTERNOON');
    expect(greetingForHour(17), 'GOOD EVENING');
    expect(greetingForHour(23), 'GOOD EVENING');
  });

  test("today's total matches the sample orders", () {
    expect(kTotalOrders, 76);
  });
}

void _assetTests() {
  test('every dashboard asset exists on disk', () {
    final referenced = <String>[
      ...kCategories.map((c) => c.icon),
      ...kOrders.map((o) => o.image),
      'assets/icons/menu.png',
      'assets/icons/wallet.svg',
      'assets/icons/orders_cloche.png',
    ];
    final missing = referenced.where((p) => !File(p).existsSync()).toList();
    expect(missing, isEmpty, reason: 'missing assets: $missing');
  });
}
