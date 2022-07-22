import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:mug_together/models/question.dart';
import 'package:mug_together/screens/myQns/edit_question.dart';
import 'package:mug_together/utilities/pdf.dart';

class ViewQuestion extends StatefulWidget {
  // Passing in question info
  const ViewQuestion({Key? key, required this.question}) : super(key: key);
  final Question question;

  @override
  State<ViewQuestion> createState() => _ViewQuestion();
}

class _ViewQuestion extends State<ViewQuestion> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 248),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("View Question"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: SingleChildScrollView(
        child: Flex(
          direction: Axis.vertical,
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
                        widget.question.data["Question"],
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 45.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: MarkdownBody(
                  data: widget.question.data["Notes"],
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
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.question.data["Module"],
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
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                  children: _tagList(widget.question.data["Tags"] as List),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
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
                        widget.question.data["FromCommunity"]
                            ? "This question is taken from the Community"
                            : widget.question.data["Privacy"]
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
                      Text(widget.question.data["LastUpdate"]),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton(
                    key: const Key("editButton"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditQuestion(
                                    question: widget.question,
                                  ))).then((_) => setState(() {}));
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
                  width: 30,
                ),
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    onPressed: _genAndSaveURL,
                    child: const Text(
                      "Get URL",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    onPressed: () async {
                      final name = await openDialog();
                      if (name == null || name.isEmpty) {
                        return;
                      }
                      PDFcreator.createPDF(widget.question, name);
                    },
                    child: const Text(
                      "PDF",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }

  /// Makes a List of tags in containers
  List<Widget> _tagList(List tags) {
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

  /// Generate URL and save into clipboard
  void _genAndSaveURL() {
    Clipboard.setData(ClipboardData(
            text: Uri.https('mugtogether.web.app', '/shareable', {
      'uid': widget.question.data["Owner"],
      'qid': widget.question.docId,
      'module': widget.question.data["Module"]
    }).toString()))
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("URL is saved into your clipboard!")));
    });
  }

  Future<String?> openDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Name your PDF"),
          content: TextField(
            autofocus: true,
            controller: controller,
            decoration: const InputDecoration(hintText: "Name your PDF"),
            onSubmitted: (_) => submit(),
          ),
          actions: [
            TextButton(
              onPressed: submit,
              child: const Text("ENTER"),
            )
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop(controller.text);
    controller.clear();
  }
}
