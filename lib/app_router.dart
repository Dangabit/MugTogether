import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/add_question.dart';
import 'package:mug_together/screens/questions.dart';
import 'package:mug_together/screens/login.dart';
import 'package:mug_together/screens/signup.dart';

class AppRouter {
  // Handles Routing
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Arguments if needed
    final args = settings.arguments;

    // Sign up and Log in
    switch (settings.name) {
      case '/':
        return _notLoggedIn();
      case '/signup':
        return MaterialPageRoute(
            settings: const RouteSettings(name: "/signup"),
            builder: (context) => const SignUpPage());
    }

    // Checking if the user is logged in
    if (FirebaseAuth.instance.currentUser == null) {
      return _notLoggedIn();
    }

    // Routes available when user is logged in
    switch (settings.name) {
      case '/questions':
        return MaterialPageRoute(
            settings: const RouteSettings(name: "/questions"),
            builder: (context) => const QuestionsPage());
      case '/questions/add':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "/questions/add"),
          builder: (context) => const AddQuestion(),
        );
    }

    // Invalid page
    return _pageNotFound();
  }

  static Route<dynamic> _notLoggedIn() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: "/"),
        builder: (context) => const LoginPage());
  }

  static Route<dynamic> _pageNotFound() {
    return MaterialPageRoute(
      builder: (context) {
        return const Scaffold(
          body: Center(
            child: Text('Error 404: Page not found.'),
          ),
        );
      },
    );
  }
}
