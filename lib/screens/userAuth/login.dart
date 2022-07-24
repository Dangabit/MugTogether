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
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: buildLoginScreen(context),
        ),
      ),
    );
  }

  Widget buildLoginScreen(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 5.0),
              child: Image.asset(
                'assets/images/logo3.png',
                height: currentScreenHeight < 680 ? 130 : 160,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Welcome to MugTogether!',
                style: GoogleFonts.firaSansCondensed(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  wordSpacing: 1.5,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 20.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Your app for exam success',
                  style: GoogleFonts.firaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    wordSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: currentScreenWidth < 500
              ? currentScreenWidth
              : currentScreenWidth < 1000
                  ? currentScreenWidth * 0.8
                  : currentScreenWidth * 0.6,
          margin: const EdgeInsets.only(top: 20.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(197, 213, 198, 255),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              children: <Widget>[
                // Login Form
                Padding(
                  padding: EdgeInsets.only(top: currentScreenHeight * 0.05),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Log In',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                        SizedBox(
                          height: currentScreenHeight * 0.05,
                        ),
                        // Email input field
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: currentScreenHeight * 0.001,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextFormField(
                                key: const Key("emailFormField"),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: currentScreenHeight * 0.001,
                            ),
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: TextFormField(
                                key: const Key("passwordFormField"),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 15),
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
                                        _passwordVisible = !_passwordVisible;
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: TextButton(
                                key: const Key("forgetPassword"),
                                onPressed: () => showDialog(
                                    context: context, builder: _popupForm),
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.deepPurple),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Button, with function to login
                        Padding(
                          padding:
                              EdgeInsets.only(top: currentScreenHeight * 0.02),
                          child: SizedBox(
                            width: 350.0,
                            height: 55.0,
                            child: ElevatedButton(
                              key: const Key("loginButton"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              child: const Text(
                                'Login!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: () => _submit(null),
                            ),
                          ),
                        ),
                        // Display any firebase login issue, if any
                        Text(
                          _exception,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(),
                      child: TextButton(
                        key: const Key("signupButton"),
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Sign up here!",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
    final newEmailController = TextEditingController();
    bool _validate = false;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        insetPadding: const EdgeInsets.symmetric(vertical: 100),
        scrollable: true,
        content: Column(
          children: <Widget>[
            TextField(
              controller: newEmailController,
              decoration: InputDecoration(
                hintText: "Input your email",
                errorText: _innerException.isNotEmpty ? _innerException : null,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  newEmailController.text.isEmpty ? _validate = true : false;
                });
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: newEmailController.text)
                    .then((_) => Navigator.pop(context))
                    .catchError((e) => {
                          if (_validate)
                            {
                              setState(() {
                                _innerException = "Email cannot be empty";
                                _validate = false;
                              })
                            }
                          else if (e.code == "user-not-found")
                            {
                              setState(() {
                                _innerException = "This email is not used";
                              })
                            }
                          else if (e.code == "invalid-email")
                            {
                              setState(() {
                                _innerException = "This email is invalid";
                              })
                            }
                          else
                            {
                              setState(() {
                                _innerException =
                                    "There is an unforeseen problem...";
                              })
                            }
                        });
              },
              child: const Text(
                "Confirm",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
