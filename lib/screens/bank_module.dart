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

  Widget _generateListView(List<QueryDocumentSnapshot<Map>> docslist, BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) => Container(
        margin: const EdgeInsets.all(1),
        child: Text(docslist[index].get("Question"))
      ),
    );
  }
}
