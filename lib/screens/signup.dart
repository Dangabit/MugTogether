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
  String _exception = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // For backward navigation
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Sign Up!"),
      ),
      // Sign Up Form
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
                    _exception = "";
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          _exception = 'The password provided is too weak.';
                        } else if (e.code == 'email-already-in-use') {
                          _exception =
                              'The account already exists for that email.';
                        } else if (e.code == 'invalid-email') {
                          _exception = 'Not a valid email.';
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
                _exception,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
