// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancer_firebase/services/firestore_service.dart';

class AddNoteScreen extends StatefulWidget {
  // Accept the user data here
  User user;
  AddNoteScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: 20,
              ),
              // ignore: prefer_const_constructors
              TextField(
                controller: titleController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              const Text(
                "Description",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              // ignore: prefer_const_constructors
              TextField(
                controller: descriptionController,
                minLines: 5,
                maxLines: 10,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (titleController.text == "" ||
                              descriptionController == "") {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("All fields are required"),
                              backgroundColor: Colors.redAccent,
                            ));
                          } else {
                            // set loading indicator to true
                            setState(() {
                              loading = true;
                            });

                            await FirestoreService().insertNote(
                                titleController.text,
                                descriptionController.text,
                                widget.user.uid);
                            // stop loading
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Note Added!"),
                              backgroundColor: Colors.yellowAccent,
                            ));
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Add Note",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
