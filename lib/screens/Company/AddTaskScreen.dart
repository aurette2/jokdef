import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_jokdef/screens/Company/HomeCompanyScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  var taskController = TextEditingController();
  var taskController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Action'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Your can add all actions you need here'),
            SizedBox(
              height: 20.0,
            ),
            Text('Action Name'),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: taskController,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
              ),
              decoration: InputDecoration(
                hintText: 'Action name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text('Add text'),
            SizedBox(
              height: 10.0,
            ),
            TextField(
              controller: taskController2,
              style: TextStyle(
                color: Colors.orange,
                fontSize: 10,
              ),
              decoration: InputDecoration(
                hintText: 'Description ....',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                String taskName = taskController.text.trim();
                String taskText = taskController2.text.trim();

                if (taskName.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please provide action name');
                  return;
                }

                User? user = FirebaseAuth.instance.currentUser;

                if (user != null) {
                  String uid = user.uid;
                  int dt = DateTime.now().millisecondsSinceEpoch;

                  //DatabaseReference taskRef = FirebaseDatabase.instance.reference().child('tasks').child(uid);

                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                  var taskRef = firestore
                      .collection('tasks')
                      .doc(uid)
                      .collection('tasks')
                      .doc();

                  await taskRef.set({
                    'dt': dt,
                    'taskName': taskName,
                    'taskId': taskRef.id,
                    'taskText': taskText
                  });

                  Fluttertoast.showToast(msg: 'Action Added');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                      return HomeCompanyScreen();
                    }));

                }
              },
              child: Text(
                'Save'.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
