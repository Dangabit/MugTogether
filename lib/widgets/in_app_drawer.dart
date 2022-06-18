import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InAppDrawer {
  /// Provide the common menu drawer to be used between all features screen
  static Drawer gibDrawer(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        ListView(shrinkWrap: true, children: [
          _createHeader(context),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          _createDrawerItem(
            Icons.assignment_sharp,
            'My Questions',
            () => Navigator.pushNamed(context, '/questions'),
          ),
          _createDrawerItem(
            Icons.account_balance_sharp,
            'Question Bank',
            () => Navigator.pushNamed(context, '/bank'),
          ),
          _createDrawerItem(
            Icons.quiz_outlined,
            'Quiz',
            () => Navigator.pushNamed(context, '/quiz'),
          ),
        ]),
        const Spacer(),
        Container(
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            children: <Widget>[
              ElevatedButton(
                // Sign out and return to login page
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (route) => false);
                },
                child: const Text(
                  'Sign out',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  /// Generate the clickable profile card for the drawer header
  static Widget _createHeader(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return DrawerHeader(
      margin: EdgeInsets.zero,
      //padding: EdgeInsets.zero,
      child: Card(
        // FIXME: Rounded corners might not be working
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          child: user!.photoURL == null
              ? Image.asset('assets/images/test.jpg', fit: BoxFit.cover)
              : Image.network(user.photoURL!),
          onTap: () {
            Navigator.pushNamed(context, '/profile/me');
          },
          splashColor: Colors.grey,
        ),
      ),
    );
  }

  /// Generate each feature category to navigate to
  static Widget _createDrawerItem(
      IconData icon, String text, GestureTapCallback onTap) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(
            icon,
            color: Colors.deepPurple,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
