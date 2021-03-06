import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/myQns/add_question.dart';
import 'package:mug_together/screens/bank/bank_module.dart';
import 'package:mug_together/screens/qna/lounge.dart';
import 'package:mug_together/screens/myQns/question_share.dart';
import 'package:mug_together/screens/quiz/past_attempts.dart';
import 'package:mug_together/screens/userAuth/profile.dart';
import 'package:mug_together/screens/bank/questionbank.dart';
import 'package:mug_together/screens/myQns/questions.dart';
import 'package:mug_together/screens/userAuth/login.dart';
import 'package:mug_together/screens/quiz/quiz.dart';
import 'package:mug_together/screens/userAuth/signup.dart';
import 'package:mug_together/screens/qna/qna.dart';

class AppRouter {
  /// Generate the route given the RouteSettings.
  ///
  /// [settings] holds the name and arguments, in which the function will
  /// generate a route based on the name. If no routes with the name is found,
  /// an error 404 page is generated.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final Uri uri = Uri.parse(settings.name ?? '');

    // Sign up and Log in
    switch (uri.path) {
      case '/':
        return MaterialPageRoute(
            settings: settings, builder: (context) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(
            settings: settings, builder: (context) => const SignUpPage());
      case '/questions':
        return _checkUser((user) => QuestionsPage(user: user), settings);
      case '/questions/add':
        return args != null
            ? _checkUser(
                (user) => AddQuestion(
                    user: user,
                    question: (args as Map<String, dynamic>)["Question"]),
                settings)
            : _checkUser(
                (user) => AddQuestion(
                      user: user,
                    ),
                settings);
      case '/profile':
        return args != null
            ? _checkUser(
                (user) => ProfilePage(user: user, profile: args as String),
                settings)
            : _checkUser(
                (user) => QuestionsPage(
                      user: user,
                    ),
                settings);
      case '/bank':
        return _checkUser((user) => QuestionBankPage(user: user), settings);
      case '/bank/module':
        if (args != null) {
          return _checkUser(
              (user) => BankModulePage(user: user, module: args as String),
              settings);
        } else {
          return _checkUser((user) => QuestionBankPage(user: user),
              const RouteSettings(name: '/bank'));
        }
      case '/quiz':
        return _checkUser((user) => QuizPage(user: user), settings);
      case '/quiz/past':
        return _checkUser((user) => PastAttempts(user: user), settings);
      case '/qna':
        return _checkUser((user) => QnAPage(user: user), settings);
      case '/qna/module':
        if (args != null) {
          return _checkUser(
              (user) => Lounge(user: user, module: args as String), settings);
        } else {
          return _checkUser(
              (user) => QnAPage(user: user), const RouteSettings(name: '/qna'));
        }
      case '/shareable':
        return _checkUser(
            (user) => SharedQuestion(data: uri.queryParameters, user: user),
            settings);
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
