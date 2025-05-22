import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_jokdef/screens/Company/AddTaskScreen.dart';
import 'package:final_jokdef/screens/Company/UpdateTaskScreen.dart';
import 'package:final_jokdef/screens/GenScreen.dart';
import 'package:final_jokdef/screens/admin/CreationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:final_jokdef/screens/Company/ProfileScreen.dart';

import '../../util/utils.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({super.key});

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();
}

class _HomeAdminScreenState extends State<HomeAdminScreen> {

  CollectionReference? actionRef;

  @override
  void initState() {
    super.initState();

    String uid = FirebaseAuth.instance.currentUser!.uid;
    actionRef = FirebaseFirestore.instance
        .collection('Actions')
        .doc(uid)
        .collection('Actions');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration Home'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ProfileScreen();
                }));
              },
              icon: const Icon(Icons.person)),
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text('Confirmation !!!'),
                        content: const Text('Are you sure to Log Out ? '),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();

                              FirebaseAuth.instance.signOut();

                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                return const GenScreen();
                              }));
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const SignUpScreen();
          }));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: actionRef!.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Actions Yet'),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {



                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data!.docs[index]['ActionName']),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(Utility.getHumanReadableDate(
                                  snapshot.data!.docs[index]['dt']))
                            ],
                          )),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {

                                     Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                      return UpdateTaskScreen(documentSnapshot: snapshot.data!.docs[index]);
                                    })); 
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 20,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title:
                                                const Text('Confirmation !!!'),
                                            content: const Text(
                                                'Are you sure to delete ? '),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop();
                                                  },
                                                  child: const Text('No')),
                                              TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(ctx).pop();

                                                    if (actionRef != null) {
                                                      await actionRef!
                                                          .doc(
                                                              '${snapshot.data!.docs[index]['ActionId']}')
                                                          .delete();
                                                    }
                                                  },
                                                  child: const Text('Yes')),
                                            ],
                                          );
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 20,
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  });
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}