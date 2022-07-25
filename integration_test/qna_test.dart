import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mug_together/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // THIS TEST REQUIRES THE TEST MAIL TO BE VERIFIED
  group("QnA feature test", () {
    testWidgets("Forum check", (tester) async {
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

      // Move to QnA page
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      Finder qnab = find.byKey(const Key('QnA Forum'));
      await tester.tap(qnab);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("QnA Forum"), findsOneWidget);

      // Enter a lounge
      Finder md = find.byKey(const Key("moduleDropdown"));
      Finder nb = find.byKey(const Key("nextButton"));
      await tester.tap(md);
      await tester.pumpAndSettle();
      Finder mod = find.text("AC5001");
      await tester.tap(mod);
      await tester.pumpAndSettle();
      await tester.ensureVisible(nb);
      await tester.tap(nb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("QnA Lounge (AC5001)"), findsOneWidget);

      // Start a post
      Finder spb = find.byKey(const Key("startPost"));
      await tester.tap(spb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Enter the question you want to discuss about"),
          findsOneWidget);

      // Create a post
      Finder pb = find.byKey(const Key("post"));
      Finder qtff = find.byKey(const Key("questiontff"));
      await tester.enterText(qtff, "What is the best way to create an app?");
      await tester.ensureVisible(pb);
      await tester.tap(pb);
      await tester.pumpAndSettle();
      Finder imtff = find.byKey(const Key("initMessagetff"));
      Finder sb = find.byKey(const Key("submit"));
      await tester.enterText(imtff, "Help please, my app sus");
      await tester.ensureVisible(sb);
      await tester.tap(sb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Discussion Room"), findsOneWidget);

      // Update post
      Finder mtff = find.byKey(const Key("mtff"));
      Finder eb = find.byKey(const Key("enter"));
      await tester.enterText(mtff, "I would recommend not using Flutter");
      await tester.ensureVisible(eb);
      await tester.tap(eb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(
          find.text("I would recommend not using Flutter", skipOffstage: false),
          findsOneWidget);
    });
  });
}
