import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/discussion.dart';
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
  late Future<QuerySnapshot<Map>> allDiscussions;

  @override
  void initState() {
    super.initState();
    allDiscussions = FirebaseFirestore.instance
        .collection("QnA")
        .doc("Lounges")
        .collection(widget.module)
        .get();
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
      body: FutureBuilder(
        future: allDiscussions,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
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
                  ],
                ),
                snapshot.data!.size != 0
                    ? _generateListView(snapshot.data!.docs
                        as List<QueryDocumentSnapshot<Map<String, dynamic>>>)
                    : const Expanded(
                        child: Center(
                          child: Text("No discussions yet..."),
                        ),
                      ),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  ListView _generateListView(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> docsList) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return _discussionTile(Discussion.getFromDatabase(docsList[index]));
      }),
      itemCount: docsList.length,
    );
  }

  ListTile _discussionTile(Discussion discussion) {
    return ListTile(
      title: discussion.data["Question"],
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => DiscussionRoom(
            user: widget.user,
            discussion: discussion,
          ),
        ),
      ),
    );
  }
}
