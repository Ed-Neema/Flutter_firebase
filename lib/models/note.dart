import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  String id;
  String title;
  String description;
  Timestamp date;
  String userId;

  NoteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.userId,
  });

  // factory method to take data from firestore snapshot and convert it to this model
  factory NoteModel.fromJson(DocumentSnapshot snapshot) {
    return NoteModel(
        id: snapshot.id, //document id to identify document
        title: snapshot['title'],
        description: snapshot['description'],
        date: snapshot['date'],
        userId: snapshot['userId']); //unique id of the user
  }
}
