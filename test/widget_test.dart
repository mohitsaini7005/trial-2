// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lali/firebase_options.dart';
import 'package:lali/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App builds with localization and Firebase',
      (WidgetTester tester) async {
    // Initialize localization and Firebase for tests
    await EasyLocalization.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Pump the app wrapped with EasyLocalization, matching production setup
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale('en', 'IN'), // English (India) default
          Locale('hi', 'IN'), // Hindi (India)
          Locale('bn', 'IN'), // Bengali (India)
          Locale('ta', 'IN'), // Tamil (India)
          Locale('te', 'IN'), // Telugu (India)
          Locale('mr', 'IN'), // Marathi (India)
          Locale('kn', 'IN'), // Kannada (India)
          Locale('en'), // Fallback English
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'IN'),
        startLocale: const Locale('en', 'IN'),
        useOnlyLangCode: false,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify the root GetMaterialApp exists (smoke test)
    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
