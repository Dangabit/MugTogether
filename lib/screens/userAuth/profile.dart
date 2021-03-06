import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/extended_profile.dart';
import 'package:mug_together/screens/userAuth/profile_edit.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.user, required this.profile})
      : super(key: key);
  final User user;
  final String profile;

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  late Future<ExtendedProfile> profileFuture;
  late bool isUser;

  @override
  void initState() {
    super.initState();
    isUser = widget.profile == "me";
    profileFuture =
        ExtendedProfile.getInfo(isUser ? widget.user.uid : widget.profile);
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenHeight = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: profileFuture,
        builder: (context, AsyncSnapshot<ExtendedProfile> snapshot) {
          if (snapshot.hasData) {
            ExtendedProfile profile = snapshot.data!;
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 242, 233, 248),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: Text("${profile.extraData["Username"]}'s Profile"),
              ),
              drawer: InAppDrawer.gibDrawer(context, widget.user),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: _buildImage(isUser
                          ? (widget.user.photoURL == null
                              ? ''
                              : widget.user.photoURL!)
                          : (profile.extraData["PicURL"] ?? '')),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Column(
                      children: [
                        Text(
                          profile.extraData["Username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          isUser ? widget.user.email! : "",
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
                          Align(
                            alignment: Alignment.topLeft,
                            // Insert bio here
                            child: Text(
                              profile.extraData["Bio"],
                              style: const TextStyle(
                                height: 1.3,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: currentScreenHeight * 0.05,
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: currentScreenHeight * 0.05,
                    ),

                    //INCOMPLETE: Achievements

                    // SizedBox(
                    //   width: 400,
                    //   child: Column(
                    //     children: [
                    //       const Align(
                    //         alignment: Alignment.topLeft,
                    //         child: Text(
                    //           "Achievements",
                    //           style: TextStyle(
                    //             fontSize: 25,
                    //             fontWeight: FontWeight.w300,
                    //           ),
                    //         ),
                    //       ),
                    //       const SizedBox(
                    //         height: 10,
                    //       ),
                    //       SizedBox(
                    //         child: SingleChildScrollView(
                    //           scrollDirection: Axis.horizontal,
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             // Generate icons here
                    //             children: List.generate(
                    //               60,
                    //               (index) => Column(
                    //                 children: const [
                    //                   Icon(Icons.badge),
                    //                   SizedBox(
                    //                     width: 30,
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    SizedBox(
                      height: currentScreenHeight * 0.15,
                    ),
                    isUser
                        ? Center(
                            child: SizedBox(
                              width: 160.0,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.deepPurple),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                profile: profile,
                                                user: widget.user,
                                              )));
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
                          )
                        : const Text(""),
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

  Widget _buildImage(String url) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 3,
        ),
      ),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: url == ''
              ? Image.asset(
                  'assets/images/user-profile.png',
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                )
              : Image.network(
                  url,
                  errorBuilder: (context, exception, stackTrace) {
                    return Image.asset(
                      'assets/images/user-profile.png',
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                    );
                  },
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                ),
        ),
      ),
    );
  }
}
