import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/size_config.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  // Variables initialisation
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  // Initialise the field to contain previous username
  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.displayName!;
  }

  // Prevent memory leak
  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
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
        child: Center(
          child: currentScreenWidth > 650
              ? SizedBox(
                  width: SizeConfig.widthSize(context, 60),
                  child: _buildEditProfile(context),
                )
              : _buildEditProfile(context),
        ),
      ),
    );
  }

  Widget _buildEditProfile(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Username",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Update Password",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
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
            // Button to re-verify the widget.user before committing the change
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
    );
  }

  StatefulBuilder _reverify(BuildContext context) {
    // Pop-up window for the form to re-authenticate the widget.user
    // Once re-authenticated, update the widget.users' credentials
    final newPassController = TextEditingController();
    bool _validate = false;
    String _fail = "";
    return StatefulBuilder(
      builder: ((context, setState) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(vertical: 200),
            content: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: newPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Input current password",
                      errorText: _validate ? 'username cannot be empty' : null,
                    ),
                  ),
                  Text(
                    _fail,
                    style: const TextStyle(color: Colors.redAccent),
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
                        newPassController.text.isEmpty
                            ? _validate = true
                            : false;
                      });
                      widget.user
                          .reauthenticateWithCredential(
                              EmailAuthProvider.credential(
                                  email: widget.user.email!,
                                  password: newPassController.text))
                          .then((credential) async {
                            widget.user.updateDisplayName(nameController.text);
                            if (passwordController.text.isNotEmpty) {
                              await widget.user
                                  .updatePassword(passwordController.text);
                            }
                          })
                          .then((_) => Navigator.pushNamedAndRemoveUntil(
                              context, "/profile/me", ModalRoute.withName("/")))
                          .onError<FirebaseAuthException>((error, stackTrace) {
                            switch (error.code) {
                              case "weak-password":
                                setState(() {
                                  _fail = "New password is too weak";
                                });
                                break;
                              case "wrong-password":
                                setState(() {
                                  _fail = "Wrong password, try again";
                                });
                                break;
                            }
                            return null;
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
            ),
          )),
    );
  }
}
