import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InAppDrawer {
  static Drawer gibDrawer(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        ListView(shrinkWrap: true, children: [
          DrawerHeader(
            child: _generateProfileCard(),
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
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  static Widget _generateProfileCard() {
    User? user = FirebaseAuth.instance.currentUser;

    return Card(
      // FIXME: Rounded corners might not be working
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        // TODO: Use user pic if have
        child: Image.asset('assets/test.jpg', fit: BoxFit.cover),
        onTap: () {
          // TODO: Direct to user account screen
        },
        splashColor: Colors.grey,
      ),
    );
  }
}
