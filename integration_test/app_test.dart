import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Login & Signup test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // At login screen, finding all required widgets
      List<TextFormField> formFields = find
          .byType(TextFormField)
          .evaluate()
          .map<TextFormField>((e) => e.widget as TextFormField)
          .toList();
      Finder eb = find.byType(ElevatedButton);

      // Test login without any inputs
      await tester.tap(eb);
      await tester.pumpAndSettle();
      expect(find.text("Please input your email"), findsOneWidget);
      expect(find.text("Please input your password"), findsOneWidget);

      // Test with invalid credentials
      for (TextFormField element in formFields) {
        element.controller!.text = "eee";
      }
      await tester.tap(eb);
      await tester.pumpAndSettle();
      expect(find.text("The email or password is wrong, please try again"),
          findsOneWidget);
    });
  });
}
