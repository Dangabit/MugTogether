import 'dart:ui';

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
    return FutureBuilder(
      future: widget.document.get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 242, 233, 248),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: const Text("View Question"),
                leading: BackButton(onPressed: () {
                  Navigator.pop(context);
                }),
              ),
              body: LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Flex(
                        direction: Axis.vertical,
                        // Display the info from the question document
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.question_mark_outlined,
                                color: Colors.deepPurple,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Question",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 45.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(),
                              ),
                              child: Center(
                                child: Wrap(
                                  runSpacing: 5.0,
                                  spacing: 5.0,
                                  children: [
                                    Text(
                                      snapshot.data!.get("Question"),
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.notes_outlined,
                                color: Colors.deepPurple,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Notes",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 45.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 60.0,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(),
                                ),
                                child: Center(
                                  child: Wrap(
                                    runSpacing: 5.0,
                                    spacing: 5.0,
                                    children: [
                                      Text(
                                        snapshot.data!.get("Notes"),
                                        style: const TextStyle(
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Module ->",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                width: 5.0,
                              ),
                              Container(
                                height: 30.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data!.get("Module"),
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.sell_outlined,
                                color: Colors.deepPurple,
                                size: 18.0,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Tags",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Wrap(
                                runSpacing: 5.0,
                                spacing: 5.0,
                                children: _tagList(snapshot.data!),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  children: [
                                    const Text(
                                      "Note: ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.get("FromCommunity")
                                          ? "This question is taken from the Community"
                                          : snapshot.data!.get("Privacy")
                                              ? "This question is private"
                                              : "This question can be seen in Question Bank",
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Wrap(
                                  children: [
                                    const Text(
                                      "Last updated: ",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(snapshot.data!.get("LastUpdate")),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 100.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.deepPurple,
                              ),
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditQuestion(
                                                document: snapshot.data!,
                                                user: widget.user)))
                                    .then((_) => setState(() {}));
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
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
                  ),
                );
              }));
        } else {
          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 242, 233, 248),
              appBar: AppBar(
                backgroundColor: Colors.deepPurple,
                title: const Text("View Question"),
                leading: BackButton(onPressed: () {
                  Navigator.pop(context);
                }),
              ),
              body: const CircularProgressIndicator());
        }
      },
    );
  }

  /// Makes a List of tags in containers
  List<Widget> _tagList(DocumentSnapshot currentDoc) {
    List<dynamic> tags = currentDoc.get("Tags");
    return tags.map((tag) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(tag),
      );
    }).toList();
  }
}
