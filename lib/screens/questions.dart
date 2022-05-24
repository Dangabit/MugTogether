import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/view_question.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
  final user = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  String currentValue = "ALL";
  List<Widget> cardList = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user?.displayName}'s Questions")),
      drawer: InAppDrawer.gibDrawer(context),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              // Filter by Module, or not
              FutureBuilder<List<DropdownMenuItem<String>>>(
                future: _getModList(),
                builder: (context, snapshot) {
                  return DropdownButton<String>(
                    value: currentValue,
                    items: snapshot.data,
                    onChanged: (String? newValue) {
                      setState(() {
                        currentValue = newValue!;
                      });
                    },
                  );
                },
              ),
              const Spacer(),
              // Move to add_question screen, refresh upon returning
              ElevatedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/questions/add').then((_) {
                  setState(() {});
                }),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          // Display questions in grid
          Expanded(child: _generateGrid()),
        ],
      ),
    );
  }

  // Layout the question cards in grid view
  Widget _generateGrid() {
    return FutureBuilder<List<Widget>>(
      future: _generateCards(),
      builder: (context, snapshot) {
        // Check if there are any questions
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return GridView.count(
            physics: const ScrollPhysics(),
            crossAxisCount: 2,
            children: snapshot.data!,
          );
        } else {
          return const Text('You have no questions...');
        }
      },
    );
  }

  // Generate a list of cards for each question
  Future<List<Widget>> _generateCards() async {
    List<QueryDocumentSnapshot> res = List.empty(growable: true);
    // Pull out all the questions from the user collection
    if (currentValue == "ALL") {
      await db.collection(user!.uid).get().then((value) async {
        for (var doc in value.docs) {
          await db
              .collection(user!.uid)
              .doc(doc.id)
              .collection("questions")
              .get()
              .then((innerDocs) {
            res.addAll(innerDocs.docs);
          });
        }
      });
    } else {
      // Pull out all the questions from the user collection filtered by module
      await db
          .collection(user!.uid)
          .doc(currentValue)
          .collection("questions")
          .get()
          .then((value) {
        res.addAll(value.docs);
      });
    }
    // Convert documents from database into cards
    return res.map((doc) {
      return Card(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.donut_large),
              title: Text(doc.get("Question")),
            ),
            Row(
              children: [
                TextButton(
                  child: const Text("Delete"),
                  onPressed: () {
                    db
                        .collection(user!.uid)
                        .doc(doc.get("Module"))
                        .collection("questions")
                        .doc(doc.id)
                        .delete();
                    setState(() {});
                  }, // TODO: Delete question
                ),
                // Move to view question page
                TextButton(
                  child: const Text("View"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewQuestion(document: doc)));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  // Generate list of modules from the user collection to limit
  // filter choices
  Future<List<DropdownMenuItem<String>>> _getModList() async {
    List<String> res = List.empty(growable: true);
    res.add("ALL");
    // Get all the module ids
    await db.collection(user!.uid).get().then((value) {
      for (var doc in value.docs) {
        res.add(doc.id);
      }
    });
    // Convert ids into DropdownMenuItem to use with DropdownButton
    return res
        .map<DropdownMenuItem<String>>(
            (e) => DropdownMenuItem(value: e, child: Text(e)))
        .toList();
  }
}
