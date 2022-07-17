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
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Past Attempts",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: FutureBuilder(
        // Retrieve the list of quiz attempts
        future: FirebaseFirestore.instance
            .collection(user.uid)
            .doc("Quiz Attempts")
            .get(),
        builder: (context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            // Due to firebase not saving nested typing, casting is required
            List<Map<String, dynamic>> _attemptsList =
                snapshot.data!.get("AttemptList").cast<Map<String, dynamic>>();
            int len = _attemptsList.length;
            // Build a list view of the attempts, in order from the newest
            return ListView.separated(
              itemCount: len,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Attempt ${len - index}"),
                  subtitle: Text(
                    "Module: ${_attemptsList[len - index - 1]["Module"]}\nDate: ${_attemptsList[len - index - 1]["Date"]}",
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IndividualAttempt(
                                  attempt: _attemptsList[len - index - 1],
                                  attemptNum: len - index,
                                  user: user,
                                )));
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
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
