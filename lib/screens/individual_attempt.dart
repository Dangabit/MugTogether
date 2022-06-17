import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IndividualAttempt extends StatefulWidget {
  const IndividualAttempt({Key? key, required this.doc, required this.user})
      : super(key: key);
  final QueryDocumentSnapshot<Map<String, dynamic>> doc;
  final User user;

  @override
  State<IndividualAttempt> createState() => _IndividualAttempt();
}

class _IndividualAttempt extends State<IndividualAttempt> {
  int currentIndex = 0;
  late int total;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.doc.data();
    total = data["Questions"].length;
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
      ]),
    );
  }

  Widget _qnNum() {
    return DropdownButton<int>(
        items: List<DropdownMenuItem<int>>.generate(
            total,
            (index) =>
                DropdownMenuItem(child: Text(index.toString()), value: index)),
        onChanged: (value) {
          setState(() {
            currentIndex = value!;
          });
        });
  }

  Widget _questionBody() {
    return Column(
      children: <Widget>[
        Text(data["Questions"][currentIndex]),
        Text(data["Attempts"][currentIndex]),
        ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection(widget.user.uid)
                  .doc(data["Module"])
                  .collection("questions")
                  .add({
                "Question": data["Questions"][currentIndex],
                "Notes": data["Attempts"][currentIndex],
                "Module": data["Module"],
                "LastUpdate": data["Date"],
                "Tags": List.empty(),
                "Importance": 0,
                "Privacy": true,
                "Owner": widget.user.uid,
                "FromBank": true,
              }).then((_) => Navigator.pop(context));
            },
            child: const Text("Add to MyQuestions"))
      ],
    );
  }
}
