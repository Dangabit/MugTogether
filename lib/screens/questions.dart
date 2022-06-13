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
  // Variables Initialisation
  final user = FirebaseAuth.instance.currentUser;
  final nilValue = "ALL";
  late String currentModule;
  late String currentFilter;
  List<Widget> cardList = List.empty();

  @override
  void initState() {
    super.initState();
    currentModule = nilValue;
    currentFilter = nilValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user?.displayName}'s Questions")),
      drawer: InAppDrawer.gibDrawer(context),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(user!.uid)
            .where("isEmpty", isNull: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return Column(
              children: [
                Row(
                  children: <Widget>[
                    // Filter by Module, or not
                    DropdownButton<String>(
                      value: currentModule,
                      items: _getModList(snapshot),
                      onChanged: (String? newValue) {
                        setState(() {
                          currentModule = newValue!;
                        });
                      },
                    ),
                    const Spacer(),
                    _generateDropdown(),
                    // Move to add_question screen, refresh upon returning
                    ElevatedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/questions/add'),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                // Display questions in grid
                Expanded(child: _generateGrid(snapshot)),
              ],
            );
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _getModList(
      AsyncSnapshot<QuerySnapshot> snapshot) {
    // Convert ids into DropdownMenuItem to use with DropdownButton
    List<DropdownMenuItem<String>> res = snapshot.data!.docs
        .where((doc) => !doc.get("isEmpty"))
        .map<DropdownMenuItem<String>>(
            (doc) => DropdownMenuItem(value: doc.id, child: Text(doc.id)))
        .toList();
    res.add(DropdownMenuItem<String>(value: nilValue, child: Text(nilValue)));
    return res;
  }

  // Generate list of modules from the user collection to limit
  // filter choices
  // Layout the question cards in grid view
  Widget _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    late Stream<QuerySnapshot> docStream;
    if (currentModule == nilValue) {
      docStream = FirebaseFirestore.instance
          .collectionGroup("questions")
          .where("Owner", isEqualTo: user!.uid)
          .where("Tags",
              arrayContains: currentFilter == nilValue ? null : currentFilter)
          .snapshots();
    } else {
      docStream = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc(currentModule)
          .collection("questions")
          .where("Tags",
              arrayContains: currentFilter == nilValue ? null : currentFilter)
          .snapshots();
    }
    return StreamBuilder(
      stream: docStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('Disconnected');
          case ConnectionState.waiting:
            return const CircularProgressIndicator();
          case ConnectionState.active:
          case ConnectionState.done:
            List<Widget> cardList = _generateCards(snapshot.data!.docs);
            return cardList.isEmpty
                ? const Text('You have no questions...')
                : GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: 2,
                    children: cardList);
        }
      },
    );
  }

  // Generate a list of cards for each question
  List<Widget> _generateCards(List<QueryDocumentSnapshot> res) {
    // Convert documents from database into cards
    return res.map((doc) {
      DocumentReference currentDoc = FirebaseFirestore.instance
          .collection(user!.uid)
          .doc(doc.get("Module"))
          .collection("questions")
          .doc(doc.id);
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
                    currentDoc.delete();
                  },
                ),
                // Move to view question page
                TextButton(
                  child: const Text("View"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewQuestion(document: currentDoc)));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  FutureBuilder _generateDropdown() {
    return FutureBuilder<DocumentSnapshot<Map>>(
      future:
          FirebaseFirestore.instance.collection(user!.uid).doc("Tags").get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot<Map>> snapshot) {
        if (snapshot.hasData) {
          Map? data = snapshot.data!.data();
          late List<String> tagsList;
          if ((data == null) || data.isEmpty) {
            tagsList = List.empty(growable: true);
          } else {
            tagsList = data.keys.toList() as List<String>;
            tagsList.removeWhere((key) => data[key] <= 0);
          }
          tagsList.add(nilValue);
          return DropdownButton<String>(
            value: currentFilter,
            items: tagsList
                .map((value) =>
                    DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (String? value) => setState(() {
              currentFilter = value!;
            }),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
