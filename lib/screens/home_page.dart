// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_firebase/models/note.dart';

import 'package:freelancer_firebase/screens/add_note.dart';
import 'package:freelancer_firebase/screens/edit_note.dart';

import '../services/auth_service.dart';

class HomePage extends StatelessWidget {
  User user;
  HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("home"),
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
            icon: const Icon(Icons.logout),
            label: const Text("Sign out"),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length > 0) {
              // if we have docs
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  // whatever we receive will be in Json format
                  // we will convert to json model
                  NoteModel note =
                      NoteModel.fromJson(snapshot.data.docs[index]);
                  return Card(
                    color: Colors.redAccent,
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      title: Text(
                        note.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                       note.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNoteScreen(note:note)));
                      },
                    ),
                  );
                },
              );
            } else {
              // if there are no docs
              Center(
                child: Text("No notes available"),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNoteScreen(user: user)));
        },
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ListView(
//         children: [
//           Card(
//             color: Colors.redAccent,
//             elevation: 5,
//             margin: EdgeInsets.all(10),
//             child: ListTile(
//               contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               title: Text(
//                 "Build a new app",
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               subtitle: Text(
//                 "Learn to build a fullstack Flutter firebase course",
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 2,
//               ),
//               onTap: () {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => EditNoteScreen()));
//               },
//             ),
//           )
//         ],
//       ),