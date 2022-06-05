import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/edit_question.dart';

class ViewQuestion extends StatefulWidget {
  // Passing in document info
  const ViewQuestion({Key? key, required this.document}) : super(key: key);
  final QueryDocumentSnapshot document;

  @override
  State<ViewQuestion> createState() => _ViewQuestion();
}

class _ViewQuestion extends State<ViewQuestion> {
  // Variables Initialisation
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Flex(
        // Display the info from the question document
        direction: Axis.vertical,
        children: [
          Text(widget.document.get("Question")),
          Text(widget.document.get("Notes")),
          Text(widget.document.get("Module")),
          Text(widget.document.get("LastUpdate")),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditQuestion(document: widget.document)));
            },
            child: const Text("edit"),
          ),
        ],
      ),
    );
  }
}
