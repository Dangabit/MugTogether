import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/add_question.dart';
import 'package:mug_together/screens/bank_module.dart';
import 'package:mug_together/screens/past_attempts.dart';
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
    final args = settings.arguments;

    // Sign up and Log in
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (context) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(
            settings: settings, builder: (context) => const SignUpPage());
      case '/questions':
        return _checkUser((user) => QuestionsPage(user: user), settings);
      case '/questions/add':
        if (args != null) {
          return _checkUser(
              (user) => AddQuestion(data: args as Map, user: user), settings);
        } else {
          return _checkUser((user) => AddQuestion(user: user), settings);
        }
      case '/profile/me':
        return _checkUser((user) => ProfilePage(user: user), settings);
      case '/bank':
        return _checkUser((_) => const QuestionBankPage(), settings);
      case '/bank/module':
        if (args != null) {
          return _checkUser(
              (user) => BankModulePage(user: user, module: args as String),
              settings);
        } else {
          return _checkUser((_) => const QuestionBankPage(),
              const RouteSettings(name: '/bank'));
        }
      case '/quiz':
        return _checkUser((user) => QuizPage(user: user), settings);
      case '/quiz/past':
        return _checkUser((user) => PastAttempts(user: user), settings);
      default:
        return _pageNotFound();
    }
  }

  /// Checks if the user is logged in before accessing the screen
  static Route<dynamic> _checkUser(
      Function screen, RouteSettings routeSettings) {
    return MaterialPageRoute(
        settings: routeSettings,
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
                      return screen(snapshot.data!);
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
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 241, 222, 255),
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            leading: BackButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              },
            ),
            title: const Text(
              "Error 404: Page not found",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "This page does not exist...",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Press back to return to our login page",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
