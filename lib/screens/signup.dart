import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/size_config.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  // Variables initialisation
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  String _exception = "";
  bool _passwordVisible1 = false;
  bool _passwordVisible2 = false;

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
    final currentScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: currentScreenWidth > 650
              ? SizedBox(
                  width: SizeConfig.widthSize(context, 60),
                  child: _buildSignupScreen(context),
                )
              : _buildSignupScreen(context),
        ),
      ),
    );
  }

  Widget _buildSignupScreen(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25.0, bottom: 5.0),
          child: Image.asset('assets/images/logo3.png'),
        ),
        // Sign Up Form
        Container(
          margin: const EdgeInsets.only(top: 20.0),
          color: Colors.transparent,
          child: Container(
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
              padding: const EdgeInsets.only(bottom: 65),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Text(
                        'Sign Up',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    // Username input field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            key: const Key("usernameField"),
                            controller: usernameController,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 15),
                              border: InputBorder.none,
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              prefixIcon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.deepPurple,
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input a username';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(5)),

                    // Email input field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            key: const Key("emailField"),
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
                            // Checking for an NUS email using Regex
                            validator: (String? value) {
                              if (!RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@u.nus.edu")
                                  .hasMatch(value!)) {
                                return 'Please input an NUS email';
                              }
                              return null;
                            },
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
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            key: const Key("passwordField"),
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
                                    _passwordVisible1 = !_passwordVisible1;
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              errorMaxLines: 3,
                            ),
                            validator: (String? value) {
                              RegExp regex = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (value == null || value.isEmpty) {
                                return 'Please input your password';
                              }
                              if (!regex.hasMatch(value)) {
                                return 'Password should contain at least one ' +
                                    'upper case, one lower case, one digit, ' +
                                    'one special character, and be at least ' +
                                    '8 characters long';
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible1,
                            onFieldSubmitted: submit,
                          ),
                        ),
                      ),
                    ),

                    const Padding(padding: EdgeInsets.all(5)),

                    // Confirm Password input field
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                            key: const Key("confirmPasswordField"),
                            controller: confirmPassController,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 15),
                              border: InputBorder.none,
                              labelText: 'Confirm Password',
                              hintText: 'Retype your password',
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.deepPurple,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible2 = !_passwordVisible2;
                                  });
                                },
                                icon: Icon(
                                  _passwordVisible2
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != passwordController.text) {
                                return 'Password does not match';
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible2,
                            onFieldSubmitted: submit,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // For backward navigation
                          SizedBox(
                            width: 100.0,
                            height: 40.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () => Navigator.popUntil(context,
                                  (route) => route.settings.name == "/"),
                              child: const Text(
                                'Back',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(right: 152)),
                          // Create Button, with function to create user in Firebase
                          SizedBox(
                            width: 100.0,
                            height: 40.0,
                            child: ElevatedButton(
                              key: const Key("createUser"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () => submit(null),
                              child: const Text(
                                'Create',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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
          ),
        ),
      ],
    );
  }

  /// Submit the form to create a user in FirebaseAuth.
  ///
  /// [value] is needed for onFieldSubmitted to work. However, no actual value
  /// is needed to pass into this function.
  Future<void> submit(String? value) async {
    _exception = "";
    // If the inputs are valid
    if (_formKey.currentState!.validate()) {
      try {
        // Try to create account, if successful, tag
        // the user to the username and move the user to login
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            )
            .then((credential) {
              credential.user!.updateDisplayName(usernameController.text);
              FirebaseFirestore.instance
                  .collection(credential.user!.uid)
                  .doc("Tags")
                  .set({});
              FirebaseFirestore.instance
                  .collection(credential.user!.uid)
                  .doc("Quiz Attempts")
                  .set({"AttemptList": List.empty()});
              return credential;
            })
            .then((credential) => credential.user?.sendEmailVerification())
            .then((_) => Navigator.pop(context));
      } on FirebaseAuthException catch (e) {
        // Account creation problem, take note here
        if (e.code == 'email-already-in-use') {
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
