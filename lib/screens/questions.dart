import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/view_question.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<QuestionsPage> createState() => _QuestionsPage();
}

class _QuestionsPage extends State<QuestionsPage> {
  // Variables Initialisation
  final nilValue = "ALL";
  late String currentModule;
  late String currentFilter;
  List<Widget> cardList = List.empty();
  late List<DropdownMenuItem<String>> modlist;
  late List<DropdownMenuItem<String>> tagsList;
  late final Future checkInit;

  @override
  void initState() {
    super.initState();
    currentModule = nilValue;
    currentFilter = nilValue;
    Future initModList = FirebaseFirestore.instance
        .collection(widget.user.uid)
        .where("isEmpty", isNull: false)
        .get()
        .then((snapshot) {
      modlist = _getModList(snapshot);
    });
    Future initTagsList = FirebaseFirestore.instance
        .collection(widget.user.uid)
        .doc("Tags")
        .get()
        .then((snapshot) {
      tagsList = _generateDropdown(snapshot);
    });
    checkInit = Future.wait([initModList, initTagsList]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.user.displayName}'s Questions")),
      drawer: InAppDrawer.gibDrawer(context),
      body: FutureBuilder(
        // Future builder to check if everything is initialised completely
        future: checkInit,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(widget.user.uid)
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
                            items: modlist,
                            onChanged: (String? newValue) {
                              setState(() {
                                currentModule = newValue!;
                              });
                            },
                          ),
                          const Spacer(),
                          DropdownButton<String>(
                            value: currentFilter,
                            items: tagsList,
                            onChanged: (String? value) => setState(() {
                              currentFilter = value!;
                            }),
                          ),
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
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  /// Retrieve a list of mods for the widget.user
  List<DropdownMenuItem<String>> _getModList(QuerySnapshot snapshot) {
    // Convert ids into DropdownMenuItem to use with DropdownButton
    List<DropdownMenuItem<String>> res = snapshot.docs
        .where((doc) => doc.get("isEmpty") > 0)
        .map<DropdownMenuItem<String>>(
            (doc) => DropdownMenuItem(value: doc.id, child: Text(doc.id)))
        .toList();
    res.add(DropdownMenuItem<String>(value: nilValue, child: Text(nilValue)));
    return res;
  }

  /// Generate a gridview of the documents based on query
  Widget _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    // Streaming based on filters
    late Stream<QuerySnapshot> docStream;
    if (currentModule == nilValue) {
      docStream = FirebaseFirestore.instance
          .collectionGroup("questions")
          .where("Owner", isEqualTo: widget.user!.uid)
          .where("Tags",
              arrayContains: currentFilter == nilValue ? null : currentFilter)
          .orderBy("Importance", descending: true)
          .snapshots();
    } else {
      docStream = FirebaseFirestore.instance
          .collection(widget.user!.uid)
          .doc(currentModule)
          .collection("questions")
          .where("Tags",
              arrayContains: currentFilter == nilValue ? null : currentFilter)
          .orderBy("Importance", descending: true)
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

  /// Generate a list of cards from the documents passed in
  List<Widget> _generateCards(List<QueryDocumentSnapshot> res) {
    // Convert documents from database into cards
    return res.map((doc) {
      bool emptyNotes = doc.get("Notes") == "";
      DocumentReference currentDoc = FirebaseFirestore.instance
          .collection(widget.user!.uid)
          .doc(doc.get("Module"))
          .collection("questions")
          .doc(doc.id);
      return Card(
        // Glow if no notes
        color: emptyNotes ? Colors.yellow : null,
        shadowColor: emptyNotes ? const Color.fromARGB(255, 169, 169, 0) : null,
        elevation: 2,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.donut_large),
              title: Text(doc.get("Question")),
            ),
            Row(
              children: [
                // Delete button
                TextButton(
                  child: const Text("Delete"),
                  onPressed: () async {
                    Future updateTags = currentDoc
                        .get()
                        .then((doc) => doc.get("Tags") as List)
                        .then((List taglist) {
                      FirebaseFirestore.instance
                          .collection(widget.user!.uid)
                          .doc("Tags")
                          .update(Map.fromIterable(
                            taglist,
                            value: (element) => FieldValue.increment(-1),
                          ));
                    });
                    Future updateMod = currentDoc.get().then<String>((doc) {
                      return doc.get("Module");
                    }).then((mod) {
                      FirebaseFirestore.instance
                          .collection(widget.user!.uid)
                          .doc(mod)
                          .update({"isEmpty": FieldValue.increment(-1)});
                    });
                    Future.wait([updateMod, updateTags]).then(
                      (_) => currentDoc.delete(),
                    );
                  },
                ),
                // Move to view question page
                TextButton(
                  child: const Text("View"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewQuestion(
                                  document: currentDoc,
                                  user: widget.user,
                                )));
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Generate Tags as a list of Dropdown Menu Item
  List<DropdownMenuItem<String>> _generateDropdown(DocumentSnapshot snapshot) {
    Map? data = snapshot.data() as Map?;
    late List<String> tagsList;
    if ((data == null) || data.isEmpty) {
      tagsList = List.empty(growable: true);
    } else {
      tagsList = data.keys.toList() as List<String>;
      tagsList.removeWhere((key) => data[key] <= 0);
    }
    tagsList.add(nilValue);
    return tagsList
        .map((value) => DropdownMenuItem(value: value, child: Text(value)))
        .toList();
  }
}
