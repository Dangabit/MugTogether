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
  // Variables Initialisation
  int currentIndex = 0;
  late List<bool> added;
  late bool timerInfo;

  @override
  void initState() {
    super.initState();
    added = List.generate(widget.attempt.length, (index) => false);
    timerInfo = widget.attempt.containsKey("StartTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Column(children: <Widget>[
        _qnNum(),
        _questionBody(),
        timerInfo ? _timerInfo() : const Text(""),
      ]),
    );
  }

  /// Display timer info if the attempt uses a timer
  Widget _timerInfo() {
    return Row(
      children: [
        Text(widget.attempt["StartTime"].toDate().toString()),
        const Spacer(),
        Text(widget.attempt["EndTime"].toDate().toString())
      ],
    );
  }

  /// Display a dropdrop menu to move between questions
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

  /// Show the individual question
  Widget _questionBody() {
    return Column(
      children: <Widget>[
        Text(widget.attempt["Questions"][currentIndex]),
        Text(widget.attempt["Attempts"][currentIndex]),
        added[currentIndex]
            ? const Text("Qn added!")
            : ElevatedButton(
                // Pulling of questions into the user collection
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection(widget.user.uid)
                      .doc(widget.attempt["Module"])
                      .update({"isEmpty": FieldValue.increment(1)});
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
                  }).then((_) => setState(() {
                            added[currentIndex] = true;
                          }));
                },
                child: const Text("Add to MyQuestions"))
      ],
    );
  }
}
