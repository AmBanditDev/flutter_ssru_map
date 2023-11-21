import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum UserRole { member, admin }

Map<UserRole, String> userRole = {
  UserRole.member: 'member',
  UserRole.admin: 'admin',
};

class AuthMethod {
  // call firebase auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  // call firebase firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String username,
      required String email,
      required String password,
      required String cPassword}) async {
    String res = "Some error occurred";
    try {
      if (username.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          cPassword.isEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // store user info in firestore database
        print(cred.user!.uid);
        await firestore.collection("users").doc(cred.user!.uid).set({
          'username': username,
          'email': email,
          'password': password,
          'user_role': userRole[UserRole.member],
        });
        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }
}
