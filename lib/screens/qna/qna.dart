import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:mug_together/widgets/module_list.dart';

class QnAPage extends StatefulWidget {
  const QnAPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<QnAPage> createState() => _QnAPage();
}

class _QnAPage extends State<QnAPage> {
  // User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Data module = Data();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        title: const Text("QnA Forum"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: InAppDrawer.gibDrawer(context, widget.user),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ModuleList.createListing(module),
              ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/qna/post'),
                icon: const Icon(
                  Icons.edit_note_outlined,
                ),
                label: const Text("Start a post"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const Text("To be implemented"),
        ],
      ),
    );
  }
}
