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
      body: Column(
        children: <Widget>[
          // Login Form
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Email input field
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input your email';
                    }
                    return null;
                  },
                ),
                // Password input field
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please input your password';
                    }
                    return null;
                  },
                ),
                // Button, with function to login
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    child: const Text('Login!'),
                    onPressed: () async {
                      _exception = "";
                      if (_formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pushNamed(context, '/home');
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'invalid-email' ||
                              e.code == 'wrong-password') {
                            _exception =
                                'The email or password is wrong, please try again';
                          } else if (e.code == 'user-not-found') {
                            _exception =
                                'This email is not used, try creating instead';
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                        setState(() {});
                      }
                    },
                  ),
                ),
                Text(_exception,
                    style: const TextStyle(color: Colors.redAccent)),
              ],
            ),
          ),
          // Sign Up
          Row(
            children: <Widget>[
              const Text("Not registered yet? Create one!"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
