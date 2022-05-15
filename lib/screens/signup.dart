import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final exceptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Email input field
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input an email';
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
                    return 'Please input a password';
                  }
                  return null;
                },
              ),
              // Button, with function to create user in Firebase
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    exceptionController.text = "";
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          exceptionController.text =
                              'The password provided is too weak.';
                        } else if (e.code == 'email-already-in-use') {
                          exceptionController.text =
                              'The account already exists for that email.';
                        } else if (e.code == 'invalid-email') {
                          exceptionController.text = 'Not a valid email.';
                        }
                      } catch (e) {
                        if (kDebugMode) {
                          print(e);
                        }
                      }
                      setState(() {});
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
              // Display error, if any
              Text(
                exceptionController.text,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
