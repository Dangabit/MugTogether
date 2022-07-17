import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({Key? key, required this.document, required this.user})
      : super(key: key);
  final DocumentSnapshot document;
  final User user;

  @override
  State<EditQuestion> createState() => _EditQuestion();
}

class _EditQuestion extends State<EditQuestion> {
  // Variables Initialisation
  final questionController = TextEditingController();
  final notesController = TextEditingController();
  final tagsController = TextEditingController();
  late bool privacy;
  late bool fromComm;
  late List<String> oldtags;

  @override
  void initState() {
    super.initState();
    questionController.text = widget.document.get("Question");
    notesController.text = widget.document.get("Notes");
    oldtags = widget.document.get("Tags").cast<String>();
    String tags = oldtags.toString();
    tagsController.text = tags.substring(1, tags.length - 1);
    privacy = widget.document.get("Privacy");
    fromComm = widget.document.get("FromCommunity");
  }

  // Prevent memory leak
  @override
  void dispose() {
    notesController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 233, 248),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Edit Question"),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacementNamed(context, "/questions");
        }),
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
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
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: questionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 30),
                      border: InputBorder.none,
                      hintText: 'Input your question',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: notesController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 30),
                      border: InputBorder.none,
                      hintText: 'Input any notes (Multiline) (Optional)',
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
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: TextField(
                    controller: tagsController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 20),
                      border: InputBorder.none,
                      hintText: 'Tags, separated by commas (Optional)',
                    ),
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
                        widget.document.get("Module"),
                        style: const TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            fromComm
                ? const Text("")
                : Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Privatise question? ",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Checkbox(
                              value: privacy,
                              onChanged: (newValue) => setState(() {
                                    privacy = newValue!;
                                  })),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
              ),
              onPressed: _submitChange,
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ),
    );
  }

  /// Submit changes to the document to Firebase
  Future<void> _submitChange() async {
    List tags = tagsController.text.isEmpty
        ? List.empty()
        : tagsController.text.split(", ").toSet().toList();
    Future updateQnChange = FirebaseFirestore.instance
        .collection(widget.user.uid)
        .doc(widget.document.get("Module"))
        .collection("questions")
        .doc(widget.document.id)
        .update({
      "Question": questionController.text,
      "Notes": notesController.text,
      "Tags": tags,
      "Privacy": privacy,
      "LastUpdate": DateTime.now().toString()
    });
    Future updateTags = FirebaseFirestore.instance
        .collection(widget.user.uid)
        .doc("Tags")
        .update(Map.fromIterable(tags,
            value: (element) => FieldValue.increment(1)));
    Future reduceTags = FirebaseFirestore.instance
        .collection(widget.user.uid)
        .doc("Tags")
        .update(Map.fromIterable(
          oldtags,
          value: (element) => FieldValue.increment(-1),
        ));
    Future.wait([updateQnChange, updateTags, reduceTags])
        .then((_) => Navigator.pushReplacementNamed(context, "/questions"));
  }
}
