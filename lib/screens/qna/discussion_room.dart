import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/discussion.dart';

class DiscussionRoom extends StatefulWidget {
  const DiscussionRoom({Key? key, required this.user, required this.discussion})
      : super(key: key);
  final User user;
  final Discussion discussion;

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
      body: Column(
        children: [
          Text(widget.discussion.data["Question"]),
          StreamBuilder(
            stream: widget.discussion.dataStream(),
            builder: (context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasData) {
                return _generateConvo(
                    Discussion.getFromDatabase(snapshot.data!));
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  ListView _generateConvo(Discussion discussion) {
    return ListView.builder(
        itemBuilder: ((context, index) {
          return ListTile(
            title: discussion.data["Discussion"][index],
            subtitle: discussion.data["Users"][index],
          );
        }),
        itemCount: (discussion.data["Users"] as List).length);
  }
}
