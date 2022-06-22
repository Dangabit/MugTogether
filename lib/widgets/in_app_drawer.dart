import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InAppDrawer {
  /// Provide the common menu drawer to be used between all features screen
  static Drawer gibDrawer(BuildContext context, User user) {
    return Drawer(
      child: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                _createHeader(context, user),
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                _createDrawerItem(
                  Icons.account_circle_sharp,
                  'My Profile',
                  () => Navigator.popAndPushNamed(context, '/profile/me'),
                ),
                _createDrawerItem(
                  Icons.assignment_sharp,
                  'My Questions',
                  () => Navigator.popAndPushNamed(context, '/questions'),
                ),
                _createDrawerItem(
                  Icons.account_balance_sharp,
                  'Question Bank',
                  () => Navigator.popAndPushNamed(context, '/bank'),
                ),
                _createDrawerItem(
                  Icons.quiz_outlined,
                  'Quiz',
                  () => Navigator.popAndPushNamed(context, '/quiz'),
                ),
                const Spacer(),
                _signOutButton(context),
              ]),
            ),
          ),
        );
      }),
    );
  }

  /// Generate the clickable profile card for the drawer header
  static Widget _createHeader(BuildContext context, User user) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
          image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('assets/images/drawerheader.jpg'),
      )),
      child: Stack(children: <Widget>[
        Positioned(
          bottom: 40.0,
          left: 16.0,
          child: Text(
            user.displayName!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          bottom: 20.0,
          left: 16.0,
          child: Text(
            user.email!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Positioned(
          top: 17.0,
          left: 9.0,
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Image.asset(
                'assets/images/user-profile.png',
                fit: BoxFit.cover,
                width: 55,
                height: 55,
              ),
            ),
          ),
        ),
      ]),
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

  /// Sign Out Button
  static Widget _signOutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
      child: Container(
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
              child: Row(
                children: const [
                  Icon(Icons.exit_to_app_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                  ),
                  Text(
                    'Sign out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
