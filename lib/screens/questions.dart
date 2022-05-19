import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/add_question.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool noQuestions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${user?.displayName}'s Questions")),
      drawer: InAppDrawer.gibDrawer(context),
      body: Column(
        children: [
          Row(
            children: <Widget>[
              // TODO: Add a sorter here
              const Spacer(),
              // Move to add_question screen
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddQuestion())),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          // Display questions in grid
          _generateGrid(),
        ],
      ),
    );
  }

  Widget _generateGrid() {
    if (noQuestions) {
      return const Text('You have no questions...');
    } else {
      return GridView.count(
        crossAxisCount: 2,
        children: _generateCards(),
      );
    }
  }

  List<Widget> _generateCards() {
    // TODO: Retrieve data from database and return as card view
    return [];
  }
}
