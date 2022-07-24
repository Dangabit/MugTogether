import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/extended_profile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.profile, required this.user})
      : super(key: key);
  final ExtendedProfile profile;
  final User user;

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  // Variables initialisation
  final picController = TextEditingController();
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  // Initialise the field to contain previous username
  @override
  void initState() {
    super.initState();
    picController.text =
        widget.user.photoURL == null ? "" : widget.user.photoURL!;
    nameController.text = widget.profile.extraData["Username"];
    bioController.text = widget.profile.extraData["Bio"];
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 248),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Edit Profile Details"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Center(
          child: _buildEditProfile(context),
        ),
      ),
    );
  }

  Widget _buildEditProfile(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: currentScreenWidth < 500
          ? currentScreenWidth
          : currentScreenWidth < 1000
              ? currentScreenWidth * 0.8
              : currentScreenWidth * 0.6,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: currentScreenHeight * 0.05,
            ),
            // Profile pic url field
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Profile Picture URL",
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
                    controller: picController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                      border: InputBorder.none,
                      labelText: 'Profile Pic URL',
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                    validator: null,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: currentScreenHeight * 0.05,
            ),
            // Username field
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
                        Icons.person_outlined,
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
            SizedBox(
              height: currentScreenHeight * 0.05,
            ),
            // Bio field
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Bio",
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
                      controller: bioController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                        border: InputBorder.none,
                        labelText: 'Bio',
                        prefixIcon: Icon(
                          Icons.badge_outlined,
                          color: Colors.deepPurple,
                        ),
                      ),
                      validator: null),
                ),
              ),
            ),
            SizedBox(
              height: currentScreenHeight * 0.05,
            ),
            // Update Password field
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
                      errorMaxLines: 3,
                    ),
                    validator: (String? value) {
                      RegExp regex = RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      if (!regex.hasMatch(value)) {
                        return 'Password should contain at least one '
                            'upper case, one lower case, one digit, '
                            'one special character, and be at least '
                            '8 characters long';
                      }
                      return null;
                    },
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
      ),
    );
  }

  StatefulBuilder _reverify(BuildContext context) {
    // Pop-up window for the form to re-authenticate the widget.user
    // Once re-authenticated, update the widget.users' credentials
    final newPassController = TextEditingController();
    String? _fail;
    return StatefulBuilder(
      builder: ((context, setState) => AlertDialog(
            insetPadding: const EdgeInsets.symmetric(vertical: 100),
            scrollable: true,
            content: Column(
              children: <Widget>[
                TextField(
                  controller: newPassController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Input current password",
                    errorText: _fail,
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
                    widget.profile
                        .reverify({
                          "Password": newPassController.text,
                          "NewPassword": passwordController.text,
                        }, {
                          "Bio": bioController.text,
                          "Achievements": List.empty(),
                          "Username": nameController.text,
                          "PicURL": picController.text
                        }, widget.user)
                        .then((_) => Navigator.pushNamedAndRemoveUntil(context,
                            '/profile', ModalRoute.withName("/"), arguments: "me"))
                        .onError<FirebaseAuthException>((error, stackTrace) {
                          switch (error.code) {
                            case "weak-password":
                              setState(() {
                                _fail = "New password is too weak";
                              });
                              break;
                            case "wrong-password":
                              setState(() {
                                _fail = newPassController.text.isEmpty
                                    ? "Current password cannot be empty"
                                    : "Wrong password, try again";
                              });
                              break;
                            default:
                              setState(() {
                                _fail = "Unforeseen error has occurred";
                              });
                              break;
                          }
                          return null;
                        })
                        .onError((error, stackTrace) {
                          setState(() {
                            _fail = "Invalid permission";
                          });
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
          )),
    );
  }
}
