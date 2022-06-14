import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  bool _passwordVisible = false;

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
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Text(
                    'Welcome to MugTogether!',
                    style: GoogleFonts.robotoSerif(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 23.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your app for exam success',
                      style: GoogleFonts.robotoSerif(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 150.0),
              color: Colors.transparent,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(98, 180, 180, 180),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: <Widget>[
                      // Login Form
                      Padding(
                        padding: const EdgeInsets.only(top: 55),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              const Text(
                                'Log In',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              // Email input field
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 15),
                                        border: InputBorder.none,
                                        labelText: 'Email',
                                        hintText: 'Enter your email',
                                        prefixIcon: Icon(
                                          Icons.mail_outline,
                                          color: Colors.deepPurple,
                                        ),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: TextFormField(
                                      controller: passwordController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 15),
                                        border: InputBorder.none,
                                        labelText: 'Password',
                                        hintText: 'Enter your password',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Colors.deepPurple,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      ),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please input your password';
                                        }
                                        return null;
                                      },
                                      obscureText: !_passwordVisible,
                                      onFieldSubmitted: _submit,
                                    ),
                                  ),
                                ),
                              ),
                              // Button, with function to login
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: SizedBox(
                                  width: 350.0,
                                  height: 55.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.deepPurple,
                                    ),
                                    child: const Text(
                                      'Login!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () => _submit(null),
                                  ),
                                ),
                              ),
                              // Display any firebase login issue, if any
                              Text(_exception,
                                  style:
                                      const TextStyle(color: Colors.redAccent)),
                            ],
                          ),
                        ),
                      ),
                      // Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Not registered yet?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 5.0)),
                          Padding(
                            padding: const EdgeInsets.symmetric(),
                            child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: const Text(
                                "Sign up here!",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            // child: ElevatedButton(
                            //   style: ElevatedButton.styleFrom(
                            //     primary: Colors.blue[900],
                            //   ),
                            //   child: const Text(
                            //     'Sign Up',
                            //     style: TextStyle(fontWeight: FontWeight.bold),
                            //   ),
                            //   onPressed: () {
                            //     Navigator.pushNamed(context, '/signup');
                            //   },
                            // ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            showDialog(context: context, builder: _popupForm),
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
