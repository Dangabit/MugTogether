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
        title: Text("QnA Lounge (${widget.module})"),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/qna",
          );
        }),
      ),
      body: FutureBuilder(
        future: allDiscussions,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton.icon(
                      key: const Key("startPost"),
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
                ),
                const SizedBox(
                  height: 30,
                ),
                const Divider(
                  color: Colors.grey,
                ),
                snapshot.data!.size != 0
                    ? Expanded(
                        child: _generateListView(snapshot.data!.docs as List<
                            QueryDocumentSnapshot<Map<String, dynamic>>>),
                      )
                    : const Expanded(
                        child: Center(child: Text("No discussions yet..."))),
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
    return ListView.separated(
      itemBuilder: ((context, index) {
        return _discussionTile(
            Discussion.getFromDatabase(docsList[index]), index);
      }),
      itemCount: docsList.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
        );
      },
    );
  }

  ListTile _discussionTile(Discussion discussion, int index) {
    return ListTile(
      title: Text("Room " + (index + 1).toString()),
      subtitle: Text(discussion.data["Question"]),
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
