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
  final notesController = TextEditingController();
  final tagsController = TextEditingController();
  late bool privacy;
  late bool fromComm;
  late List<String> oldtags;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: const Text("Edit Question"),
        leading: BackButton(onPressed: () {
          Navigator.pushReplacementNamed(context, "/questions");
        }),
      ),
      body: Column(
        children: [
          Text(widget.document.get("Question")),
          TextField(controller: notesController),
          Text(widget.document.get("Module")),
          TextField(controller: tagsController),
          fromComm
              ? const Text("")
              : Checkbox(
                  value: privacy,
                  onChanged: (newValue) => setState(() {
                        privacy = newValue!;
                      })),
          ElevatedButton(
              onPressed: _submitChange, child: const Icon(Icons.save)),
        ],
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
        .update(
            {"Notes": notesController.text, "Tags": tags, "Privacy": privacy});
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
