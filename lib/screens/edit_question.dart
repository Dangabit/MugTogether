import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({Key? key}) : super(key: key);

  @override
  State<EditQuestion> createState() => _EditQuestion();
}

class _EditQuestion extends State<EditQuestion> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Question"),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
    );
  }
}
