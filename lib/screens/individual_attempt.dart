import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IndividualAttempt extends StatefulWidget {
  const IndividualAttempt({Key? key, required this.attempt, required this.user})
      : super(key: key);
  final Map<String, dynamic> attempt;
  final User user;

  @override
  State<IndividualAttempt> createState() => _IndividualAttempt();
}

class _IndividualAttempt extends State<IndividualAttempt> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: <Widget>[
        _qnNum(),
        _questionBody(),
      ]),
    );
  }

  Widget _qnNum() {
    return DropdownButton<int>(
        items: List<DropdownMenuItem<int>>.generate(
            widget.attempt["Questions"].length,
            (index) =>
                DropdownMenuItem(child: Text("${index + 1}"), value: index)),
        onChanged: (value) {
          setState(() {
            currentIndex = value!;
          });
        });
  }

  Widget _questionBody() {
    return Column(
      children: <Widget>[
        Text(widget.attempt["Questions"][currentIndex]),
        Text(widget.attempt["Attempts"][currentIndex]),
        ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection(widget.user.uid)
                  .doc(widget.attempt["Module"])
                  .collection("questions")
                  .add({
                "Question": widget.attempt["Questions"][currentIndex],
                "Notes": widget.attempt["Attempts"][currentIndex],
                "Module": widget.attempt["Module"],
                "LastUpdate": widget.attempt["Date"],
                "Tags": List.empty(),
                "Importance": 0,
                "Privacy": true,
                "Owner": widget.user.uid,
                "FromCommunity": true,
              }).then((_) => Navigator.pop(context));
            },
            child: const Text("Add to MyQuestions"))
      ],
    );
  }
}
