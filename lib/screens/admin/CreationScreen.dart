import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ndialog/ndialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var fullNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compte creation'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  hintText: 'Company Name',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(
                      horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold)),
              
                onPressed: () async {
                    var fullName = fullNameController.text.trim();
                    var email = emailController.text.trim();
                    var password = passwordController.text.trim();
                    var confirmPass = confirmController.text.trim();

                    if (fullName.isEmpty ||
                        email.isEmpty ||
                        password.isEmpty ||
                        confirmPass.isEmpty) {
                      // show error toast

                      Fluttertoast.showToast(msg: 'Please fill all fields');
                      return;
                    }

                    if (password.length < 6) {
                      // show error toast
                      Fluttertoast.showToast(
                          msg:
                          'Weak Password, at least 6 characters are required');

                      return;
                    }

                    if (password != confirmPass) {
                      // show error toast
                      Fluttertoast.showToast(msg: 'Passwords do not match');

                      return;
                    }

                    // request to firebase auth

                    ProgressDialog progressDialog = ProgressDialog(
                      context,
                      title: const  Text('Creation ....'),
                      message: const Text('Please wait ...'),
                    );

                    progressDialog.show();
                    try {


                      FirebaseAuth auth = FirebaseAuth.instance;

                      UserCredential userCredential =
                      await auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      if (userCredential.user != null) {

                        // store user information in Firestore database

                        FirebaseFirestore firestore = FirebaseFirestore.instance;

                        String uid = userCredential.user!.uid;
                        int dt = DateTime.now().millisecondsSinceEpoch;


                        firestore.collection('users').doc(uid).set({
                          'Company_Name': fullName,
                          'email': email,
                          'uid': uid,
                          'dt': dt,
                          'profileImage': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQGrQoGh518HulzrSYOTee8UO517D_j6h4AYQ&usqp=CAU'
                        });

                        Fluttertoast.showToast(msg: 'Success');

                        Navigator.of(context).pop();
                      } else {
                        Fluttertoast.showToast(msg: 'Failed');
                      }

                      progressDialog.dismiss();

                    } on FirebaseAuthException catch (e) {
                      progressDialog.dismiss();
                      if (e.code == 'email-already-in-use') {
                        Fluttertoast.showToast(msg: 'Email is already in Use');
                      } else if (e.code == 'weak-password') {
                        Fluttertoast.showToast(msg: 'Password is weak');
                      }
                    } catch (e) {
                      progressDialog.dismiss();
                      Fluttertoast.showToast(msg: 'Something went wrong');
                    }
                  },
                  child: const Text('Compte creation'),
                ),
              
            ],
          ),
        ),
      ),
    );  }
}