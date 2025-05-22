import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:final_jokdef/screens/GenScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jok def app 2022',
      home: GenScreen(),
    );
  }
}


