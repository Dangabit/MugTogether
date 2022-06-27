import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BankModulePage extends StatefulWidget {
  const BankModulePage({Key? key, required this.module, required this.user})
      : super(key: key);
  final String module;
  final User user;

  @override
  State<BankModulePage> createState() => _BankModulePage();
}

class _BankModulePage extends State<BankModulePage> {
  late Future<QuerySnapshot<Map>> allQuestions;

  @override
  void initState() {
    super.initState();
    allQuestions = FirebaseFirestore.instance
        .collectionGroup("questions")
        .where("Module", isEqualTo: widget.module)
        .where("Owner", isNotEqualTo: widget.user.uid)
        .where("Privacy", isEqualTo: false)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.module),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: FutureBuilder(
          future: allQuestions,
          builder: (content, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
            if (snapshot.hasData) {
              return _generateListView(snapshot.data!.docs, context);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _generateListView(
      List<QueryDocumentSnapshot<Map>> docslist, BuildContext context) {
    return docslist.isNotEmpty
        ? SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      widget.module + " Questions",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ListView.builder(
                  // TODO: Limit count to prevent the need to render large amount of Listview
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docslist.length,
                  itemBuilder: (context, index) {
                    String question = docslist[index].get("Question");
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Q" + (index + 1).toString(),
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  Flexible(
                                    child: Text(
                                      question,
                                      style: const TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  const VerticalDivider(
                                    thickness: 1,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    height: 30.0,
                                    width: 40.0,
                                    child: Tooltip(
                                      message: "Click to add this question",
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.deepPurple,
                                            padding: EdgeInsets.zero,
                                          ),
                                          onPressed: () {
                                            Navigator.pushNamed(
                                                context, "/questions/add",
                                                arguments: {
                                                  "module": widget.module,
                                                  "question": question,
                                                });
                                          },
                                          child: const Icon(Icons.download)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          )
        : const Center(
            child: Text(
              "There are no questions publicly available for this module :(",
            ),
          );
  }
}
