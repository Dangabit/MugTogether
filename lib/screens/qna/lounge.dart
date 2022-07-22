import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/qna/qna_post.dart';
import 'package:mug_together/screens/qna/discussion_room.dart';

class Lounge extends StatefulWidget {
  const Lounge({Key? key, required this.user, required this.module})
      : super(key: key);
  final User user;
  final String module;

  @override
  State<Lounge> createState() => _Lounge();
}

class _Lounge extends State<Lounge> {
  Widget qnsTile(String qns) {
    return ListTile(
      title: Text(qns),
      onTap: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("QnA Lounge (" + widget.module + ")"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => QnaPost(
                    user: widget.user,
                    module: widget.module,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.edit_note_outlined,
              ),
              label: const Text("Start a post"),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
            ),
          ),
          //TODO: Implement display of discussion lounges
          ElevatedButton(
              onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => DiscussionRoom(
                        user: widget.user,
                        module: widget.module,
                      ),
                    ),
                  ),
              child: const Text("Temp button to discussion room"))
        ],
      ),
    );
  }
}
