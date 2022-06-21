import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<EditQuestion> createState() => _EditQuestion();
}

class _EditQuestion extends State<EditQuestion> {
  User? user = FirebaseAuth.instance.currentUser;
  final notesController = TextEditingController();
  final tagsController = TextEditingController();
  late bool privacy;
  late List<String> oldtags;

  @override
  void initState() {
    super.initState();
    notesController.text = widget.document.get("Notes");
    oldtags = widget.document.get("Tags").cast<String>();
    String tags = oldtags.toString();
    tagsController.text = tags.substring(1, tags.length - 1);
    privacy = widget.document.get("Privacy");
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
          fromBank
              ? const Text("")
              : Checkbox(
                  value: privacy,
                  onChanged: (newValue) => setState(() {
                        privacy = newValue!;
                      })),
          ElevatedButton(
              onPressed: () => _submitChange(context),
              child: const Icon(Icons.save)),
        ],
      ),
    );
  }

  Future<void> _submitChange(BuildContext context) async {
    Future updateQnChange = FirebaseFirestore.instance
        .collection(user!.uid)
        .doc(widget.document.get("Module"))
        .collection("questions")
        .doc(widget.document.id)
        .update({
      "Notes": notesController.text,
      "Tags": tagsController.text.split(", ").toSet().toList(),
      "Privacy": privacy
    });
    Future updateTags = FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("Tags")
        .update(Map.fromIterable(tagsController.text.split(", ").toSet(),
            value: (element) => FieldValue.increment(1)));
    Future reduceTags = FirebaseFirestore.instance
        .collection(user!.uid)
        .doc("Tags")
        .update(Map.fromIterable(
          oldtags,
          value: (element) => FieldValue.increment(-1),
        ));
    Future.wait([updateQnChange, updateTags, reduceTags])
        .then((_) => Navigator.pop(context));
  }
}
