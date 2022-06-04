import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InAppDrawer {
  /// Provide the common menu drawer to be used between all features screen
  static Drawer gibDrawer(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        ListView(shrinkWrap: true, children: [
          DrawerHeader(
            child: _generateProfileCard(context),
          ),
          ListTile(
            title: const Text('My Questions'),
            onTap: () => Navigator.pushNamed(context, '/questions'),
          ),
          ListTile(
              title: const Text('Question Bank'),
              onTap: () {
                //TODO: Add navigation to Question Bank
              }),
          ListTile(
              title: const Text('Quiz'),
              onTap: () {
                //TODO: Add navigation to Question Bank
              }),
        ]),
        const Spacer(),
        Container(
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            children: <Widget>[
              ElevatedButton(
                // Sign out and return to login page
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /// Generate the clickable profile card for the drawer header
  static Widget _generateProfileCard(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Card(
      // FIXME: Rounded corners might not be working
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        child: user!.photoURL == null
            ? Image.asset('assets/test.jpg', fit: BoxFit.cover)
            : Image.network(user.photoURL!),
        onTap: () {
          Navigator.pushNamed(context, '/profile/me');
        },
        splashColor: Colors.grey,
      ),
    );
  }
}
