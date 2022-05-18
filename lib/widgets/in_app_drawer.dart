import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InAppDrawer {
  static Drawer gibDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: [
              const DrawerHeader(
                child: Text('Menu'),
              ),
              ListTile(
                title: const Text('Button 1'),
                onTap: () {
                  // Do smth
                }
              ),
            ]
          ),
          const Spacer(),
          Container(
            alignment: FractionalOffset.bottomCenter,
            child: Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
