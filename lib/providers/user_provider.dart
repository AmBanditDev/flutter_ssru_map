import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  CollectionReference _users = FirebaseFirestore.instance.collection('users');

  CollectionReference get users => _users;

  set users(CollectionReference users) {
    _users = users;
    notifyListeners();
  }

  Stream<int> getCountUsersStream() {
    return _users.snapshots().map((snapshot) => snapshot.size);
  }

  Future<void> editUser(String documentID, Map<String, dynamic> data) async {
    await _users.doc(documentID).update(data);
    notifyListeners();
  }

  // Delete from Firebase Authentication
  Future<void> deleteFirebaseUser(String docId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      final userDocRef = firestore.collection('users').doc(docId);
      final userDocUID = userDocRef.id;
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null && userDocUID == currentUser.uid) {
        // ลบบัญชีผู้ใช้จาก Firebase Authentication
        await currentUser.delete();
        print('User deleted from Firebase Authentication');

        // ลบเอกสารผู้ใช้จาก Firebase Firestore
        await userDocRef.delete();
        print('User document deleted from Firestore');
      } else {
        print(
            'User not found or current user is not the same as the specified uid');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

// Delete from Firebase Storage
  Future<void> deleteProfileImage(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(uid);
      final userDocSnap = await userDocRef.get();

      if (userDocSnap.exists) {
        // Get image path from Firestore document
        var imagePath = userDocSnap.data()!['image'];

        if (imagePath != null && imagePath.isNotEmpty) {
          // Delete Image from Firebase Storage
          var storage = FirebaseStorage.instance;
          var imageRef = storage.refFromURL(imagePath);
          await imageRef.delete();
        }
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // Delete from Firebase Firestore
  Future<void> deleteUserData(String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDocRef = firestore.collection('users').doc(uid);
      await userDocRef.delete();
      print('User data deleted from Firestore Database');
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> deleteAccount(String userId) async {
    await deleteUserData(userId);
    await deleteProfileImage(userId);
    await deleteFirebaseUser(userId);
    notifyListeners();
  }
}
