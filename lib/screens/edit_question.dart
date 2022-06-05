import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({Key? key, required this.document}) : super(key: key);
  final QueryDocumentSnapshot document;

  @override
  State<EditQuestion> createState() => _EditQuestion();
}

class _EditQuestion extends State<EditQuestion> {
  User? user = FirebaseAuth.instance.currentUser;
  final notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notesController.text = widget.document.get("Notes");
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
          ElevatedButton(
              onPressed: _submitChange, child: const Icon(Icons.save)),
        ],
      ),
    );
  }

  Future<void> _submitChange() async {
    await FirebaseFirestore.instance
        .collection(user!.uid)
        .doc(widget.document.get("Module"))
        .collection("questions")
        .doc(widget.document.id)
        .update({"Notes": notesController.text});
    Navigator.pop(context);
  }
}
