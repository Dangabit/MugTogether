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
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: Text("${user.displayName}'s profile"),
              ),
              drawer: InAppDrawer.gibDrawer(context),
              body: Center(
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(user.displayName!.substring(0, 1)),
                    ),
                    Text(user.displayName!),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EditProfile()));
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
