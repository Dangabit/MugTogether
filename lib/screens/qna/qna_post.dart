import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/question.dart';

class QnaPost extends StatefulWidget {
  const QnaPost({Key? key, required this.user, required this.module})
      : super(key: key);
  final User user;
  final String module;

  @override
  State<QnaPost> createState() => _QnaPost();
}

class _QnaPost extends State<QnaPost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // TODO: implement form initial message and question
              Question.pushToQnA("Initial message to kickstart the discussion",
                  widget.user.displayName!, widget.module, "Question here");
            },
            child: const Text(
              "Create Post",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: const Center(child: Text("To be implemented")),
    );
  }
}
