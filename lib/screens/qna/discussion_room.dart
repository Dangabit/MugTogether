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
  late Stream<DocumentSnapshot<Map<String, dynamic>>> discussionStream;
  late final TextEditingController messageController;
  late bool _validate;

  @override
  void initState() {
    super.initState();
    discussionStream = widget.discussion.dataStream();
    messageController = TextEditingController();
    _validate = false;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Discussion Room"),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/qna/module",
            arguments: widget.discussion.data["Module"],
          );
        }),
      ),
      body: StreamBuilder(
        stream: discussionStream,
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.0, left: 20.0),
                    child: Text(
                      "Question:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 20.0, right: 20.0),
                    child: Text(
                      widget.discussion.data["Question"],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: _generateConvo(
                      Discussion.getFromDatabase(snapshot.data!)),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: const Key("mtff"),
                            controller: messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              labelText: "Write Message",
                              errorText: _validate
                                  ? "Cannot send an empty text"
                                  : null,
                              labelStyle: const TextStyle(
                                fontSize: 18,
                              ),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                key: const Key("enter"),
                                icon: const Icon(
                                  Icons.send,
                                  color: Colors.deepPurple,
                                ),
                                iconSize: 20.0,
                                onPressed: _submit,
                              ),
                            ),
                            onFieldSubmitted: (_) => _submit(),
                          ),
                        ),
                      ],
                    ),
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

  void _submit() {
    if (messageController.text.trim().isEmpty) {
      setState(() {
        _validate = true;
      });
    } else {
      setState(() {
        _validate = false;
      });
      widget.discussion.update(
          messageController.text, widget.user.displayName!, widget.user.uid);
      messageController.clear();
    }
  }

  ListView _generateConvo(Discussion discussion) {
    return ListView.builder(
      itemBuilder: ((context, index) {
        return Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Column(
            crossAxisAlignment:
                discussion.data["Users"][index] == widget.user.displayName
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      discussion.data["Users"][index] == widget.user.displayName
                          ? Colors.blue[200]
                          : Colors.grey[200],
                ),
                child: Text(discussion.data["Discussion"][index]),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/profile",
                      arguments: discussion.data["UserID"][index]);
                },
                child: Padding(
                  padding:
                      discussion.data["Users"][index] == widget.user.displayName
                          ? const EdgeInsets.only(right: 6.0)
                          : const EdgeInsets.only(left: 6.0),
                  child: Text(
                    discussion.data["Users"][index],
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      itemCount: (discussion.data["Users"] as List).length,
    );
  }
}
