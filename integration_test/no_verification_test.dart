import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mug_together/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // THIS TEST REQUIRES AN UNUSED TEST EMAIL
  group('end-to-end test', () {
    testWidgets('Login test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // At login screen, finding all required widgets
      Finder emailField = find.byKey(const Key("emailFormField"));
      Finder passwordField = find.byKey(const Key("passwordFormField"));
      Finder loginButton = find.byKey(const Key("loginButton"));

      // Test login without any inputs
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("Please input your email"), findsOneWidget);
      expect(find.text("Please input your password"), findsOneWidget);

      // Test with invalid credentials
      await tester.enterText(emailField, "eee");
      await tester.ensureVisible(passwordField);
      await tester.enterText(passwordField, "eee");
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("The email or password is wrong, please try again"),
          findsOneWidget);

      // Test with somewhat legit email
      TextFormField ef = emailField.evaluate().first.widget as TextFormField;
      ef.controller!.clear();
      await tester.enterText(emailField, "legit@legitly.com");
      await tester.ensureVisible(loginButton);
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("This email is not used, try creating instead"),
          findsOneWidget);
    });

    testWidgets('signup test no verify', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // At login page, move to signup
      Finder signupButton = find.byKey(const Key("signupButton"));
      await tester.tap(signupButton);
      await tester.pumpAndSettle();

      // At sign up page, finding all required widgets
      expect(find.text("Sign Up"), findsOneWidget);
      Finder uf = find.byKey(const Key("usernameField"));
      Finder ef = find.byKey(const Key("emailField"));
      Finder pf = find.byKey(const Key("passwordField"));
      Finder cpf = find.byKey(const Key("confirmPasswordField"));
      Finder cb = find.byKey(const Key("createUser"));

      // Test empty fields
      await tester.tap(cb);
      await tester.pumpAndSettle();
      expect(find.text("Please input an NUS email"), findsOneWidget);
      expect(find.text("Please input your password"), findsOneWidget);
      expect(find.text("Please input a username"), findsOneWidget);
      expect(find.text("Please confirm your password"), findsOneWidget);

      // Test password mismatch
      await tester.enterText(pf, "P@ssword1");
      await tester.ensureVisible(cpf);
      await tester.enterText(cpf, "P@ssword2");
      await tester.ensureVisible(cb);
      await tester.tap(cb);
      await tester.pumpAndSettle();
      expect(find.text("Password does not match"), findsOneWidget);

      // Test invalid NUS mail
      await tester.enterText(ef, "legit@legitly.com");
      await tester.ensureVisible(cb);
      await tester.tap(cb);
      await tester.pumpAndSettle();
      expect(find.text("Please input an NUS email"), findsOneWidget);

      // Enter correct credentials
      final String resp =
          await rootBundle.loadString("integration_test/credentials.json");
      final credentials = jsonDecode(resp);
      await tester.enterText(uf, "testyboi");
      await tester.ensureVisible(ef);
      TextFormField ttfef = ef.evaluate().first.widget as TextFormField;
      ttfef.controller!.clear();
      await tester.enterText(ef, credentials["email"]);
      await tester.ensureVisible(pf);
      TextFormField ttfpf = pf.evaluate().first.widget as TextFormField;
      ttfpf.controller!.clear();
      await tester.enterText(pf, credentials["password"]);
      await tester.ensureVisible(cpf);
      TextFormField ttfcpf = cpf.evaluate().first.widget as TextFormField;
      ttfcpf.controller!.clear();
      await tester.enterText(cpf, credentials["password"]);
      await tester.ensureVisible(cb);
      await tester.tap(cb);
      await Future.delayed(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text("Log In"), findsOneWidget);

      // Test logging without verification
      TextFormField emailField = find
          .byKey(const Key("emailFormField"))
          .evaluate()
          .first
          .widget as TextFormField;
      TextFormField passwordField = find
          .byKey(const Key("passwordFormField"))
          .evaluate()
          .first
          .widget as TextFormField;
      Finder lb = find.byKey(const Key("loginButton"));
      emailField.controller!.text = credentials["email"];
      passwordField.controller!.text = credentials["password"];
      await tester.tap(lb);
      await Future.delayed(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text("Please verify your email before logging in"),
          findsOneWidget);
    });
  });
}
