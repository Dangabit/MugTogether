import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mug_together/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
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
      TextFormField ef = emailField.evaluate().first.widget as TextFormField;
      ef.controller!.text = "eee";
      TextFormField pf = passwordField.evaluate().first.widget as TextFormField;
      pf.controller!.text = "eee";
      await tester.tap(loginButton);
      await tester.pumpAndSettle();
      expect(find.text("The email or password is wrong, please try again"),
          findsOneWidget);

      // Test with somewhat legit email
      ef.controller!.clear();
      ef.controller!.text = "legit@legitly.com";
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
    });
  });
}
