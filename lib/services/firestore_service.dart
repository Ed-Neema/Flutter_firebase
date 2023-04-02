import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // create an instance of our firebase firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future insertNote(String title, String description, String userId) async {
    try {
      await firestore.collection('notes').add({
        "title": title,
        "description": description,
        "date": DateTime.now(),
        "userId": userId
      });
    } catch (e) {
      print(e);
    }
  }

  // update note
  Future updateNote(String docId, String title, String description) async {
    // id added because we need to know which document id to update
    try {
      await firestore
          .collection('notes')
          .doc(docId)
          .update({'title': title, 'description': description});
    } catch (e) {
      print(e);
    }
  }

  // delete
  Future deleteNote(String docId) async {
    try {
      await firestore.collection('notes').doc(docId).delete();
    } catch (e) {
      print(e);
    }
  }
}
