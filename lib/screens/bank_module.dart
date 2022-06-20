import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';

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
      appBar: AppBar(
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
    return ListView.builder(
      // TODO: Limit count to prevent the need to render large amount of Listview
      itemCount: docslist.length,
      itemBuilder: (context, index) {
        String question = docslist[index].get("Question");
        return Container(
          margin: const EdgeInsets.all(1),
          child: Row(
            children: <Widget>[
              Text(question),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/questions/add", arguments: {
                      "module": widget.module,
                      "question" : question,
                    });
                  },
                  child: const Icon(Icons.download))
            ],
          ),
        );
      },
    );
  }
}
