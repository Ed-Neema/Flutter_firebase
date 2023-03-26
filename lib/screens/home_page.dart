import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("home"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: [
          TextButton.icon(
            onPressed: () async {
              try {
                await AuthService().signout(context);
              } catch (error) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("${error.toString()}"),
                  backgroundColor: Colors.redAccent,
                ));
              }
            },
            icon: Icon(Icons.logout),
            label: Text("Sign out"),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  // reference of where we want to insert the data
                  CollectionReference users = firestore.collection("user");
                  await users.doc("flutter123").set({'name': "Google flutter"});
                },
                child: Text("Add Data to Firestore")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  CollectionReference users = firestore.collection('user');
                  // DocumentSnapshot result = await users.doc('flutter123').get();
                  // print("Read clicked");
                  users.doc("flutter123").snapshots().listen((result) {
                    print(result.data());
                    print("I have been clicked");
                  });
                },
                child: const Text("Read Data from firestore")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await firestore
                      .collection('user')
                      .doc("flutter123")
                      .update({'name': "Google Flutter Firebase"});
                  print("update clicked");
                },
                child: const Text("Update Data from Firestore")),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  await firestore.collection('user').doc("flutter123").delete();
                },
                child: const Text("Delete Data in Firestore")),
          ],
        ),
      ),
    );
  }
}
