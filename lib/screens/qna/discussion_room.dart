import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DiscussionRoom extends StatefulWidget {
  const DiscussionRoom({Key? key, required this.user, required this.module})
      : super(key: key);
  final User user;
  final String module;

  @override
  State<DiscussionRoom> createState() => _DiscussionRoom();
}

class _DiscussionRoom extends State<DiscussionRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Discussion Room"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: const Text("Display question here"),
      //TODO: Implement discussion details
    );
  }
}
