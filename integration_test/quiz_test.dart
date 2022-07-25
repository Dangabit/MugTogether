import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mug_together/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // THIS TEST REQUIRES THE TEST MAIL TO BE VERIFIED
  group("Quiz feature test", () {
    testWidgets("quiz attempt", (tester) async {
      final String resp =
          await rootBundle.loadString("integration_test/credentials.json");
      final credentials = jsonDecode(resp);

      app.main();
      await tester.pumpAndSettle();

      // At login page, logging in with approved credentials
      Finder emailField = find.byKey(const Key("emailFormField"));
      Finder passwordField = find.byKey(const Key("passwordFormField"));
      Finder loginButton = find.byKey(const Key("loginButton"));

      await tester.enterText(emailField, credentials["email"]);
      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, credentials["password"]);
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      // Move to Quiz page
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      Finder qnab = find.byKey(const Key('Quiz'));
      await tester.tap(qnab);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text("Quiz"), findsOneWidget);

      // Start a quiz
      Finder md = find.byKey(const Key("moduleDropdown"));
      Finder sq = find.byKey(const Key("startQuizButton"));
      await tester.tap(md);
      await tester.pumpAndSettle();
      Finder mod = find.text("AC5001");
      await tester.tap(mod);
      await tester.pumpAndSettle();
      await tester.tap(sq);
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text("Quiz Attempt (AC5001)"), findsOneWidget);

      // Enter incomplete quiz (require at least 1 question in AC5001)
      Finder fqb = find.byKey(const Key("finishQuizButton"));
      await tester.tap(fqb);
      await tester.pumpAndSettle();
      expect(find.text("Quiz is incomplete"), findsOneWidget);

      // Enter a complete quiz
      Finder qtff = find.text('Input your answer (Multiline)');
      await tester.enterText(qtff, "Testing...");
      await tester.ensureVisible(fqb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text("Quiz"), findsOneWidget);

      // Check past records
      Finder pqb = find.byKey(const Key("pastquizButton"));
      await tester.tap(pqb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text("Past Attempts"), findsOneWidget);
      expect(find.text("Attempt 1"), findsOneWidget);
    });
  });
}
