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
            .collection("Attempts")
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot<Map<String, dynamic>>> _attemptsList =
                snapshot.data!.docs;
            return ListView.builder(
              itemCount: _attemptsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Attempt ${index + 1}"),
                  subtitle: Text("Date: ${_attemptsList[index].get("Date")}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                IndividualAttempt(doc: _attemptsList[index], user: user,)));
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
