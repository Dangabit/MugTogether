import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/edit_question.dart';

class ViewQuestion extends StatefulWidget {
  // Passing in document info
  const ViewQuestion({Key? key, required this.document, required this.user})
      : super(key: key);
  final DocumentReference document;
  final User user;

  @override
  State<ViewQuestion> createState() => _ViewQuestion();
}

class _ViewQuestion extends State<ViewQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Question"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: FutureBuilder(
          future: widget.document.get(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              return Flex(
                // Display the info from the question document
                direction: Axis.vertical,
                children: [
                  Text(snapshot.data!.get("Question")),
                  Text(snapshot.data!.get("Notes")),
                  Text(snapshot.data!.get("Module")),
                  Text(snapshot.data!.get("LastUpdate")),
                  Row(
                    children: _tagList(snapshot.data!),
                  ),
                  Text(snapshot.data!.get("FromCommunity")
                      ? "This question is taken from the Bank"
                      : snapshot.data!.get("Privacy")
                          ? "This question is private"
                          : "This question can be seen in Question Bank"),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditQuestion(
                                      document: snapshot.data!,
                                      user: widget.user)))
                          .then((_) => setState(() {}));
                    },
                    child: const Text("edit"),
                  ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  /// Makes a List of tags in containers
  List<Widget> _tagList(DocumentSnapshot currentDoc) {
    List<dynamic> tags = currentDoc.get("Tags");
    return tags.map((tag) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: Text(tag),
      );
    }).toList();
  }
}
