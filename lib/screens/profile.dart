import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/profile_edit.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  // Variables initialisation
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${user!.displayName}'s profile"),
      ),
      drawer: InAppDrawer.gibDrawer(context),
      body: Center(
        child: Column(
          children: <Widget>[
            // TODO: Implement profile pic change here
            // - Need to save into local storage
            // - Pull data from local storage to display
            CircleAvatar(
              backgroundImage: NetworkImage(user!.photoURL == null ? "" : user!.photoURL!),
              backgroundColor: Colors.grey,
              child: Text(user!.displayName!.substring(0, 1)),
            ),
            Text(user!.displayName!),
            ElevatedButton(
              onPressed: () {
                // FIXME: Doesn't reset state when popped
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile())).then((_) {
                  setState(() {});
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
