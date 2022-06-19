import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  // Variables initialisation
  User? user = FirebaseAuth.instance.currentUser;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  // Initialise the field to contain previous username & email
  @override
  void initState() {
    super.initState();
    nameController.text = user!.displayName!;
    emailController.text = user!.email!;
  }

  // Prevent memory leak
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 248),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Edit Profile Details"),
        leading: BackButton(onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/profile/me", ModalRoute.withName("/questions"));
        }),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 30.0,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 265.0, bottom: 5.0),
                child: Text(
                  "Username",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: InputBorder.none,
                        labelText: 'Username',
                        prefixIcon: Icon(
                          Icons.account_circle_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 295.0, bottom: 5.0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: InputBorder.none,
                        labelText: 'Email',
                        prefixIcon: Icon(
                          Icons.mail_outline,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              const Padding(
                padding: EdgeInsets.only(right: 205.0, bottom: 5.0),
                child: Text(
                  "Update Password",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                        border: InputBorder.none,
                        labelText: 'Password',
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
                      obscureText: !_passwordVisible,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              ElevatedButton(
                // Button to re-verify the user before committing the change
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                            context: context,
                            builder: (context) => _reverify(context))
                        .then((_) => setState(() {}));
                  }
                },
                child: const Icon(Icons.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  StatefulBuilder _reverify(BuildContext context) {
    // Pop-up window for the form to re-authenticate the user
    // Once re-authenticated, update the users' credentials
    final newPassController = TextEditingController();
    bool _validate = false;
    String _fail = "";
    return StatefulBuilder(
      builder: ((context, setState) => AlertDialog(
            content: Column(
              children: <Widget>[
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Input current password",
                    errorText: _validate ? 'Username cannot be empty' : null,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepPurple,
                  ),
                  onPressed: () async {
                    setState(() {
                      newPassController.text.isEmpty ? _validate = true : false;
                    });
                    try {
                      user!
                          .reauthenticateWithCredential(
                              EmailAuthProvider.credential(
                                  email: user!.email!,
                                  password: newPassController.text))
                          .then((credential) {
                        user!.updateDisplayName(nameController.text);
                        user!.updateEmail(emailController.text);
                        if (passwordController.text.isNotEmpty) {
                          user!.updatePassword(passwordController.text);
                        }
                      }).then((_) => Navigator.pop(context));
                    } on FirebaseAuthException {
                      setState(() {
                        _fail = "Invalid password, try again";
                      });
                    }
                  },
                  child: const Text(
                    "Confirm",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(_fail),
              ],
            ),
          )),
    );
  }
}
