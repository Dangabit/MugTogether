import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/question.dart';
import 'package:mug_together/screens/myQns/view_question.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key, required this.user}) : super(key: key);
  final User user;

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
    final currentScreenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        title: Text("${widget.user.displayName}'s Questions"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: InAppDrawer.gibDrawer(context, widget.user),
      body: FutureBuilder(
        // Future builder to check if everything is initialised completely
        future: checkInit,
        builder: (context, snapshot) {
          if (kDebugMode && snapshot.hasError) {
            // ignore: avoid_print
            print(snapshot.error);
          }
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            // Filter by Module, or not
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    "Modules:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: DropdownButton2<String>(
                                    value: currentModule,
                                    items: modlist,
                                    buttonWidth:
                                        currentScreenWidth < 450 ? 100 : 110,
                                    dropdownWidth:
                                        currentScreenWidth < 450 ? 110 : 120,
                                    dropdownMaxHeight: 300,
                                    dropdownDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    offset: const Offset(-5, 0),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        currentModule = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 3.0),
                                  child: Text(
                                    "Tags:",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: DropdownButton2<String>(
                                    isExpanded: true,
                                    value: currentFilter,
                                    items: tagsList,
                                    buttonWidth:
                                        currentScreenWidth < 450 ? 90 : 110,
                                    dropdownWidth:
                                        currentScreenWidth < 450 ? 100 : 120,
                                    dropdownMaxHeight: 300,
                                    dropdownDecoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.black26,
                                      ),
                                    ),
                                    offset: const Offset(-5, 0),
                                    onChanged: (String? value) => setState(() {
                                      currentFilter = value!;
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Move to add_question screen, refresh upon returning
                            Column(
                              children: [
                                const Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Tooltip(
                                  message: "Add new question entry",
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.deepPurple,
                                        side: const BorderSide(
                                          width: 1.0,
                                          color: Colors.black,
                                        )),
                                    onPressed: () => Navigator.pushNamed(
                                        context, '/questions/add'),
                                    child: const Icon(Icons.add_outlined),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
    res.insert(
        0, DropdownMenuItem<String>(value: nilValue, child: Text(nilValue)));
    return res;
  }

  /// Generate a gridview of the documents based on query
  Widget _generateGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    // Streaming based on filters
    late Stream<QuerySnapshot> docStream;
    final currentScreenWidth = MediaQuery.of(context).size.width;

    if (currentModule == nilValue) {
      docStream = FirebaseFirestore.instance
          .collectionGroup("questions")
          .where("Owner", isEqualTo: widget.user.uid)
          .where("Tags",
              arrayContains: currentFilter == nilValue ? null : currentFilter)
          .orderBy("Importance", descending: true)
          .snapshots();
    } else {
      docStream = FirebaseFirestore.instance
          .collection(widget.user.uid)
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
                ? const Center(
                    child: Text('You have no questions...'),
                  )
                : GridView.count(
                    physics: const ScrollPhysics(),
                    crossAxisCount: currentScreenWidth < 560
                        ? 2
                        : currentScreenWidth < 1060
                            ? 3
                            : currentScreenWidth < 1360
                                ? 4
                                : 5,
                    children: cardList,
                  );
        }
      },
    );
  }

  /// Generate a list of cards from the documents passed in
  List<Widget> _generateCards(List<QueryDocumentSnapshot> res) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    // Convert documents from database into cards
    return res.map((doc) {
      Question question = Question.getFromDatabase(
          doc as QueryDocumentSnapshot<Map<String, dynamic>>);
      bool emptyNotes = question.data["Notes"] == "";
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          decoration: emptyNotes
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 233, 42, 106),
                        blurRadius: 20.0,
                      ),
                    ])
              : null,
          child: Card(
            // Glow if no notes
            color: emptyNotes
                ? Colors.pink[200]
                : const Color.fromARGB(255, 242, 233, 248),
            shadowColor: emptyNotes ? Colors.pink[200] : null,
            elevation: 2,
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 10.0,
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        const Icon(
                          Icons.donut_large,
                          color: Color.fromARGB(255, 121, 120, 120),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 3.0,
                            vertical: 1.5,
                          ),
                          height: currentScreenWidth < 450
                              ? 60
                              : currentScreenWidth < 750
                                  ? 90
                                  : 120,
                          child: SingleChildScrollView(
                            physics: const ClampingScrollPhysics(),
                            child: Text(
                              question.data["Question"],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Delete button
                    const SizedBox(
                      width: 20.0,
                    ),
                    TextButton(
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        question.removeFromDatabase();
                      },
                    ),
                    const Spacer(),
                    // Move to view question page
                    TextButton(
                      child: const Text(
                        "View",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewQuestion(
                                      question: question,
                                    )));
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
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
    tagsList.insert(0, nilValue);
    return tagsList
        .map((value) => DropdownMenuItem(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            )))
        .toList();
  }
}
