import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // Variables initialisation
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _exception = "";

  // Prevent memory leak
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to MugTogether!',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 50.0, left: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Your app for exam success'),
            ),
          ),

          // Login Form
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Email input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pink[100],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input your email';
                          }
                          return null;
                        },
                        onFieldSubmitted: _submit,
                      ),
                    ),
                  ),
                ),

                const Padding(padding: EdgeInsets.all(5)),

                // Password input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.pink[100],
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please input your password';
                          }
                          return null;
                        },
                        obscureText: true,
                        onFieldSubmitted: _submit,
                      ),
                    ),
                  ),
                ),
                // Button, with function to login
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900],
                    ),
                    child: const Text(
                      'Login!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () => _submit(null),
                  ),
                ),
                // Display any firebase login issue, if any
                Text(_exception,
                    style: const TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
          // Sign Up
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Not registered yet? Create one!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.only(right: 10.0)),
              Padding(
                padding: const EdgeInsets.symmetric(),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900],
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () => showDialog(context: context, builder: _popupForm),
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  /// Submit the form to log a user in FirebaseAuth.
  ///
  /// [value] is needed for onFieldSubmitted to work. However, no actual value
  /// is needed to pass into this function.
  Future<void> _submit(String? value) async {
    _exception = "";
    // If inputs are valid
    if (_formKey.currentState!.validate()) {
      try {
        // Try to login, once successful, reset the controllers
        // and move the user to their homepage
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        )
            .then((credential) {
          // Immediately signout the user and throw exception if
          // user is not verified
          if (!credential.user!.emailVerified) {
            FirebaseAuth.instance.signOut();
            throw FirebaseAuthException(code: "email-not-verified");
          }
        });
        emailController.clear();
        passwordController.clear();
        Navigator.pushNamed(context, '/questions');
      } on FirebaseAuthException catch (e) {
        // Login failure, take note of the cause
        if (e.code == 'invalid-email' || e.code == 'wrong-password') {
          _exception = 'The email or password is wrong, please try again';
        } else if (e.code == 'user-not-found') {
          _exception = 'This email is not used, try creating instead';
        } else if (e.code == 'email-not-verified') {
          _exception = 'Please verify your email before logging in';
        }
      } catch (e) {
        // For debugging purposes
        if (kDebugMode) {
          print(e);
        }
      }
      // Reset the state to update the exception
      setState(() {});
    }
  }

  /// A simple form for the user to input their email for resetting of password
  StatefulBuilder _popupForm(BuildContext context) {
    String _innerException = "";
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        content: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: "email"),
              onSubmitted: (value) {
                FirebaseAuth.instance.sendPasswordResetEmail(email: value).then(
                  (_) => Navigator.pop(context),
                  onError: (e) {
                    if (e.code == "user-not-found") {
                      setState(() {
                        _innerException = "This email is not used";
                      });
                    } else {
                      setState(() {
                        _innerException = "There is an unforeseen problem...";
                      });
                    }
                  },
                );
              },
            ),
            Text(_innerException,
                style: const TextStyle(color: Colors.redAccent)),
          ],
        ),
      );
    });
  }
}
