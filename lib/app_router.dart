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

    // Sign up and Log in
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: "/"),
            builder: (context) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(
            settings: const RouteSettings(name: "/signup"),
            builder: (context) => const SignUpPage());
      case '/questions':
        return _checkUser(const QuestionsPage(), settings.name!);
      case '/questions/add':
        return _checkUser(const AddQuestion(), settings.name!);
      case '/profile/me':
        return _checkUser(const ProfilePage(), settings.name!);
      case '/bank':
        return _checkUser(const QuestionBankPage(), settings.name!);
      case '/quiz':
        return _checkUser(const QuizPage(), settings.name!);
      default:
        return _pageNotFound();
    }
  }

  /// Checks if the user is logged in before accessing the screen
  static Route<dynamic> _checkUser(StatefulWidget screen, String routeName) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                      child: Text("Not connected to Firebase"),
                    );
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return screen;
                    } else {
                      return const LoginPage();
                    }
                }
              });
        });
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
