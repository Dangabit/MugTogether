import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/extended_profile.dart';
import 'package:mug_together/screens/userAuth/profile_edit.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<ExtendedProfile> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = ExtendedProfile.getInfo(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: profileFuture,
        builder: (context, AsyncSnapshot<ExtendedProfile> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 242, 233, 248),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text("${widget.user.displayName}'s Profile"),
              ),
              drawer: InAppDrawer.gibDrawer(context, widget.user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Stack(children: [
                        _buildImage(),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: _buildEditIcon(
                            Colors.deepPurple,
                          ),
                        )
                      ]),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Text(
                          widget.user.displayName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          widget.user.email!,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: currentScreenHeight * 0.05,
                    ),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const Divider(),
                          SizedBox(
                            height: currentScreenHeight * 0.05,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Bio",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            // Insert bio here
                            child: Text(
                              "I'm Jane Hong, and I recently graduated with an advanced diploma from Smith secondary school. I'm seeking an internship where I can apply my skills in content creation and increase my experience in digital marketing.",
                              style: TextStyle(
                                height: 1.3,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: currentScreenHeight * 0.05,
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: currentScreenHeight * 0.05,
                    ),
                    SizedBox(
                      width: 400,
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Achievements",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                // Generate icons here
                                children: List.generate(
                                  60,
                                  (index) => Column(
                                    children: const [
                                      Icon(Icons.badge),
                                      SizedBox(
                                        width: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: currentScreenHeight * 0.15,
                    ),
                    Center(
                      child: SizedBox(
                        width: 160.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(profile: snapshot.data!)));
                          },
                          child: const Text(
                            'Edit Details',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
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

  Widget _buildImage() {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Image.asset(
          'assets/images/user-profile.png',
          fit: BoxFit.cover,
          width: 128,
          height: 128,
        ),
      ),
    );
  }

  Widget _buildEditIcon(Color color) {
    return _buildCircle(
      color: Colors.white,
      all: 3,
      child: _buildCircle(
        color: color,
        all: 8,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
