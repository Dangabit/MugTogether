import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  // Variables initialisation
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  String _exception = "";

  // Prevent memory leak
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

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
              // Username input field
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: 'Username'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please input a username';
                  }
                  return null;
                },
              ),
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
                onFieldSubmitted: submit,
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
                obscureText: true,
                onFieldSubmitted: submit,
              ),
              // Button, with function to create user in Firebase
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () => submit(null),
                  child: const Text('Create'),
                ),
              ),
              // Display firebase account creation issue, if any
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

  Future<void> submit(String? value) async {
    _exception = "";
    // If the inputs are valid
    if (_formKey.currentState!.validate()) {
      try {
        // Try to create account, if successful, tag
        // the user to the username and move the user to login
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        credential.user?.updateDisplayName(usernameController.text);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Account creation problem, take note here
        if (e.code == 'weak-password') {
          _exception = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _exception = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          _exception = 'Not a valid email.';
        }
      } catch (e) {
        // For debugging purposes
        if (kDebugMode) {
          print(e);
        }
      }
      // Reset page to update exception
      setState(() {});
    }
  }
}
