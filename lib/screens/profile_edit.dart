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
          Navigator.pop(context);
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
                        .then((_) => Navigator.pop(context));
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

  AlertDialog _reverify(BuildContext context) {
    // Pop-up window for the form to re-authenticate the user
    // Once re-authenticated, update the users' credentials
    final newPassController = TextEditingController();
    return AlertDialog(
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
                await user!
                    .reauthenticateWithCredential(EmailAuthProvider.credential(
                        email: user!.email!, password: newPassController.text))
                    .then((credential) {
                  user!.updateDisplayName(nameController.text);
                  user!.updateEmail(emailController.text);
                  user!.updatePassword(passwordController.text);
                });
                Navigator.pop(context);
              } on FirebaseAuthException {
                const fail = SnackBar(
                  content: Text("Invalid password, try again"),
                );
                ScaffoldMessenger.of(context).showSnackBar(fail);
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
