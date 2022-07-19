import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/firebase_options.dart';
import 'package:mug_together/app_router.dart';
import 'package:mug_together/widgets/module_list.dart';

// Initialising everything necessary
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ModuleList.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MugTogether',
      initialRoute: '/',
      onGenerateRoute: AppRouter.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
