import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/view_question.dart';

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

  @override
  void initState() {
    super.initState();
    notesController.text = widget.document.get("Notes");
    String tags = widget.document.get("Tags").toString();
    tagsController.text = tags.substring(1, tags.length - 1);
    privacy = widget.document.get("Privacy");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Question"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Column(
        children: [
          Text(widget.document.get("Question")),
          TextField(controller: notesController),
          Text(widget.document.get("Module")),
          TextField(controller: tagsController),
          Checkbox(
              value: privacy,
              onChanged: (newValue) => setState(() {
                    privacy = newValue!;
                  })),
          ElevatedButton(
              onPressed: () => _submitChange(context), child: const Icon(Icons.save)),
        ],
      ),
    );
  }

  Future<void> _submitChange(BuildContext context) async {
    await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc(widget.document.get("Module"))
        .collection("questions")
        .doc(widget.document.id)
        .update({
      "Notes": notesController.text,
      "Tags": tagsController.text.split(", ").toSet().toList(),
      "Privacy": privacy
    }).then((_) =>
    Navigator.pop(context));
  }
}
