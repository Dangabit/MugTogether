import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mug_together/models/question.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SharedQuestion extends StatefulWidget {
  final dynamic data;
  final User user;

  const SharedQuestion({Key? key, required this.data, required this.user})
      : super(key: key);

  @override
  State<SharedQuestion> createState() => _SharedQuestion();
}

class _SharedQuestion extends State<SharedQuestion> {
  late Future<Question> questionFuture;
  late TextEditingController notesController;
  late bool _isEnabled;
  int importance = 0;

  @override
  void initState() {
    super.initState();
    questionFuture = Question.getByPath(
        widget.data["module"], widget.data["uid"], widget.data["qid"]);
    notesController = TextEditingController();
    _isEnabled = false;
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 242, 233, 248),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text("Add Question"),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
          future: questionFuture,
          builder: (context, AsyncSnapshot<Question> snapshot) {
            if (snapshot.hasData) {
              MarkdownBody markdown = MarkdownBody(
                data: snapshot.data?.data["Notes"],
                selectable: true,
                shrinkWrap: true,
                softLineBreak: true,
                styleSheet: MarkdownStyleSheet(
                  textScaleFactor: 1.1,
                  blockSpacing: 5,
                ),
                onTapLink: (text, url, title) {
                  launchUrlString(url!);
                },
              );
              notesController.text = markdown.data;
              return SingleChildScrollView(
                  child: Column(
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
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: Center(
                        child: Wrap(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          children: [
                            Text(
                              snapshot.data?.data["Question"],
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
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.notes_outlined,
                        color: Colors.deepPurple,
                        size: 18.0,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Text(
                        "Notes",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Tooltip(
                        message: !_isEnabled ? "Edit" : "Save",
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              snapshot.data?.data["Notes"] =
                                  notesController.text;
                              _isEnabled = !_isEnabled;
                            });
                          },
                          icon: const Icon(
                            Icons.edit,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 45.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 30.0,
                      ),
                      decoration: BoxDecoration(
                        color: _isEnabled ? Colors.grey[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      child: _isEnabled
                          ? TextField(
                              controller: notesController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'Input any notes (Multiline) (Optional)',
                              ),
                            )
                          : markdown,
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
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data?.data["Module"],
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
                    height: 60,
                  ),
                  SizedBox(
                    height: 40,
                    width: 95,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.deepPurple,
                      ),
                      onPressed: () {
                        snapshot.data!
                            .pullToUser(widget.user.uid, notesController.text)
                            .then((_) => Navigator.pushReplacementNamed(
                                context, "/questions"));
                      },
                      child: const Text(
                        "Add to My Questions",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ));
            } else {
              // Question is deleted
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "This question has been deleted",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 2),
                          color: Colors.deepPurple,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          tooltip: "Back to MyQuestions",
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, "/questions");
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              }
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
