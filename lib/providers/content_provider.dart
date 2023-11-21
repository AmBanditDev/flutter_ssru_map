import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ContentProvider with ChangeNotifier {
  CollectionReference _contents =
      FirebaseFirestore.instance.collection('content_ssru');

  CollectionReference get contents => _contents;

  set contents(CollectionReference contents) {
    _contents = contents;
    notifyListeners();
  }

  Stream<int> getCountContentsStream() {
    return _contents.snapshots().map(
          (snapshot) => snapshot.size,
        );
  }

  Future<void> addContent(Map<String, dynamic> data) async {
    await _contents.add(data);
    notifyListeners();
  }

  Future<void> updateContent(
      String documentID, Map<String, dynamic> data) async {
    await _contents.doc(documentID).update(data);
    notifyListeners();
  }

  Future<void> deleteContent(String contentId) async {
    try {
      var firestore = FirebaseFirestore.instance;
      var contentDocRef = firestore.collection('content_ssru').doc(contentId);
      var contentDocSnap = await contentDocRef.get();

      if (contentDocSnap.exists) {
        // Get image path from Firestore document
        var imagePath = contentDocSnap.data()!['content_img'];

        if (imagePath != null && imagePath.isNotEmpty) {
          // Delete Image from Firebase Storage
          var storage = FirebaseStorage.instance;
          var imageRef = storage.refFromURL(imagePath);
          await imageRef.delete();
        }
        // Delete Data from Firebase Firestore
        await contentDocRef.delete();
        print('Content data deleted successfully');
      } else {
        print('Content document does not exist');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
