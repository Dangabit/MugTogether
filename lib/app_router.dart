import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/add_question.dart';
import 'package:mug_together/screens/profile.dart';
import 'package:mug_together/screens/questionbank.dart';
import 'package:mug_together/screens/questions.dart';
import 'package:mug_together/screens/login.dart';
import 'package:mug_together/screens/quiz.dart';
import 'package:mug_together/screens/signup.dart';

class AppRouter {
  /// Generate the route given the RouteSettings.
  ///
  /// [settings] holds the name and arguments, in which the function will
  /// generate a route based on the name. If no routes with the name is found,
  /// an error 404 page is generated.
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
      case '/profile/me':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "/profile/me"),
          builder: (context) => const ProfilePage(),
        );
      case '/bank':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "/bank"),
          builder: (context) => const QuestionBankPage(),
        );
      case '/quiz':
        return MaterialPageRoute(
          settings: const RouteSettings(name: "/quiz"),
          builder: (context) => const QuizPage(),
        );
      default:
        return _pageNotFound();
    }
  }

  /// Generate a route that pushes user to the login page
  static Route<dynamic> _notLoggedIn() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: "/"),
        builder: (context) => const LoginPage());
  }

  /// Generate a route that pushes the user to an error 404 page
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
