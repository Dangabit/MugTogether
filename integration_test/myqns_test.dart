import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mug_together/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // THIS TEST REQUIRES THE TEST MAIL TO BE VERIFIED
  group("MyQns feature test", () {
    testWidgets("CRUD", (tester) async {
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

      // At myQns overview page, check for empty
      await Future.delayed(const Duration(seconds: 5));
      expect(find.text("You have no questions..."), findsOneWidget);

      // Move to add question page
      Finder aqb = find.byKey(const Key("addQnButton"));
      await tester.tap(aqb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));
      expect(find.text("Add Question"), findsOneWidget);

      // Create question, finding all textfields
      Finder qtf = find.byKey(const Key("questionTextField"));
      Finder ntf = find.byKey(const Key("notesTextField"));
      Finder ttf = find.byKey(const Key("tagsTextField"));
      Finder md = find.byKey(const Key("moduleDropdown"));
      Finder pcb = find.byKey(const Key("privacyCheckbox"));
      Finder sb = find.byKey(const Key("saveButton"));

      // Check for validation
      await tester.tap(sb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("Question cannot be empty"), findsOneWidget);

      // Create a generic question
      await tester.enterText(qtf, "How do I become a millionaire in 5 steps?");
      await tester.ensureVisible(ntf);
      await tester.enterText(ntf, ''' # Steps to get rich
      1) Find a rich friend.
      2) Attempt to get closer to him.
      3) Charm him with the good personality.
      4) ???
      5) Yoink his money.''');
      await tester.ensureVisible(ttf);
      await tester.enterText(ttf, "secret, get rich");
      await tester.ensureVisible(md);
      await tester.tap(md);
      await Future.delayed(const Duration(seconds: 5));
      Finder mod = find.text("BPM1705");
      await tester.ensureVisible(mod);
      await tester.tap(mod);
      await tester.ensureVisible(pcb);
      await tester.tap(pcb);
      await tester.ensureVisible(sb);
      await tester.tap(sb);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 1));
      expect(find.text("How do I become a millionaire in 5 steps?"),
          findsOneWidget);
    });
  });
}
