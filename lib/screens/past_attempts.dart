import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/individual_attempt.dart';

class PastAttempts extends StatelessWidget {
  const PastAttempts({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Past Attempts"),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection(user.uid)
            .doc("Quiz Attempts")
            .get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> _attemptsList =
                snapshot.data!.get("AttemptList").cast<Map<String, dynamic>>();
            int len = _attemptsList.length;
            return ListView.builder(
              itemCount: len,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Attempt ${len - index}"),
                  subtitle:
                      Text("Date: ${_attemptsList[len - index - 1]["Date"]}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndividualAttempt(
                                  attempt: _attemptsList[len - index - 1],
                                  user: user,
                                )));
                  },
                );
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
