import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/discussion.dart';
import 'package:mug_together/screens/qna/discussion_room.dart';

class QnaPost extends StatefulWidget {
  const QnaPost({Key? key, required this.user, required this.module})
      : super(key: key);
  final User user;
  final String module;

  @override
  State<QnaPost> createState() => _QnaPost();
}

class _QnaPost extends State<QnaPost> {
  late final TextEditingController questionController;
  late final TextEditingController initTextController;
  late bool _validateQn;
  late bool _validateText;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController();
    initTextController = TextEditingController();
    _validateQn = false;
    _validateText = false;
  }

  @override
  void dispose() {
    questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leadingWidth: 90,
        leading: ElevatedButton(
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
          ElevatedButton(
            onPressed: () {
              // TODO: Update initmsg & qn, check form too
              setState(() {
                _validateQn = questionController.text.isEmpty;
              });
              _validateQn
                  ? null
                  : showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 10.0, 10.0, 0.0),
                              child: TextFormField(
                                controller: initTextController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 40),
                                  border: InputBorder.none,
                                  hintText: 'Input your initial message',
                                  errorText:
                                      _validateText ? "Field required" : null,
                                  prefixIcon: const Icon(
                                    Icons.chat,
                                    color: Colors.deepPurple,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.deepPurple,
                                    ),
                                    onPressed: _submit,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
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
      body: Column(
        children: [
          const SizedBox(
            height: 50.0,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 25.0,
              ),
              child: Text(
                "Enter the question you want to discuss about",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  width: 1,
                  color: const Color.fromARGB(255, 100, 100, 100),
                ),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TextFormField(
                    controller: questionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 40),
                      border: InputBorder.none,
                      hintText: 'Input your question',
                      errorText: _validateQn ? "Field required" : null,
                      prefixIcon: const Icon(
                        Icons.question_mark_outlined,
                        color: Colors.deepPurple,
                      ),
                    ),
                  )),
            ),
          ),
        ],
      ),
      // TODO: Implement posting field and details
      // Need a field for question and initial message
    );
  }

  void _submit() {
    setState(() {
      _validateText = initTextController.text.isEmpty;
    });
    _validateText
        ? null
        : Discussion.create(initTextController.text, widget.user.displayName!,
                widget.user.uid, widget.module, questionController.text)
            .then((discussion) => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => DiscussionRoom(
                    user: widget.user,
                    discussion: discussion,
                  ),
                )));
  }
}
