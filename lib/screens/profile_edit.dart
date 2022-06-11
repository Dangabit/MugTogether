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
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: BackButton(onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/profile/me", ModalRoute.withName("/questions"));
        }),
      ),
      body: Center(
        // Form to edit the profile
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text("username"),
              TextFormField(
                controller: nameController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Username cannot be empty';
                  }
                  return null;
                },
              ),
              const Text("email"),
              TextFormField(
                controller: emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  return null;
                },
              ),
              const Text("Update password"),
              TextFormField(
                controller: passwordController,
                obscureText: true,
              ),
              ElevatedButton(
                // Button to re-verify the user before committing the change
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
    String _fail = "";
    return StatefulBuilder(
      builder: ((context, setState) => AlertDialog(
            content: Column(
              children: <Widget>[
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Input current password"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      user!.reauthenticateWithCredential(
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
                  child: const Text("Confirm"),
                ),
                Text(_fail),
              ],
            ),
          )),
    );
  }
}
