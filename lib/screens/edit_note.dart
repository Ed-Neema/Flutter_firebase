// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:freelancer_firebase/models/note.dart';
import 'package:freelancer_firebase/services/firestore_service.dart';

class EditNoteScreen extends StatefulWidget {
  NoteModel note;
  EditNoteScreen({
    Key? key,
    required this.note,
  }) : super(key: key);

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool loading = false;

  // we need to preassign the values for the input fields
  @override
  void initState() {
    titleController.text = widget.note.title;
    descriptionController.text = widget.note.description;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Please Confirm"),
                        content:
                            Text("Do you want to proceed and delete the note?"),
                        actions: [
                          // yes button
                          TextButton(
                              onPressed: () async {
                                await FirestoreService()
                                    .deleteNote(widget.note.id);
                                // close dialog
                                Navigator.pop(context);
                                // close the edit screen
                                Navigator.pop(context);
                                // this snackbar will show on the next context which is the homepage
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text("Note deleted"),
                                  backgroundColor: Colors.yellowAccent,
                                ));
                              },
                              child: Text("Yes")),
                          TextButton(
                              onPressed: () {
                                // remove the dialog
                                Navigator.pop(context);
                                // remember we are still on the edit screen
                              },
                              child: Text("No")),
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
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
                            setState(() {
                              loading = true;
                            });
                            await FirestoreService().updateNote(
                                widget.note.id,
                                titleController.text,
                                descriptionController.text);
                          }
                          setState(() {
                            loading = false;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Update Note",
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
