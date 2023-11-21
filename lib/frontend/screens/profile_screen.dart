// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

// providers
import 'package:flutter_ssru_map/providers/user_provider.dart';

// screens
import 'package:flutter_ssru_map/frontend/screens/profile_setting/change_password.dart';
import 'package:flutter_ssru_map/frontend/screens/profile_setting/edit_profile.dart';

// router
import 'package:flutter_ssru_map/routes.dart';

// utilities
import 'package:flutter_ssru_map/utils.dart';

// widgets
import 'package:flutter_ssru_map/widgets/listTileSetting.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Logout Function
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _showConfirmLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ต้องการออกจากระบบบัญชีของคุณใช่ไหม'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                await signOut();
                Navigator.popAndPushNamed(
                  context,
                  AppRoute.splashToLoginRegister,
                );
              },
              child: const Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmDeleteAccountDialog(String uid) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        final userProvider = Provider.of<UserProvider>(context);
        return AlertDialog(
          title: const Text(
            'ลบบัญชีผู้ใช้',
            style: TextStyle(color: kSecondColor),
          ),
          content: Text(
            "จะไม่อยู่ด้วยกันแล้วจริงๆ เหรอ แน่ใจหรือว่าต้องการจะลบบัญชีผู้ใช้ของคุณ เพราะเมื่อคุณยืนยันแล้ว ข้อมูลจะหายไปหมด",
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text(
                'ยกเลิก',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                userProvider.deleteAccount(uid).then((value) {
                  showSnackBar(
                    context,
                    message: "ลบบัญชีผู้ใช้สำเร็จ!",
                    isSuccessAlert: true,
                  );
                  Navigator.popAndPushNamed(
                      context, AppRoute.splashToLoginRegister);
                });
              },
              child: const Text(
                'ลบบัญชีผู้ใช้',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).users;

    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: kGradientColor,
          ),
        ),
        leading: const Icon(null),
        title: const Text(
          "โปรไฟล์ผู้ใช้งาน",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: userProvider.doc(user!.uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          final user = snapshot.data;
          final documentID = snapshot.data?.id;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: myProgressIndigator);
          }
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(
                  minHeight: 280,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: widthScreen * 0.4,
                      height: widthScreen * 0.4,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: widthScreen * 0.18,
                            backgroundColor: kPrimaryColor,
                            child: user['image'] == ""
                                ? CircleAvatar(
                                    radius: widthScreen * 0.17,
                                    backgroundColor: Colors.white,
                                    backgroundImage: AssetImage(profileDefault),
                                  )
                                : CircleAvatar(
                                    radius: widthScreen * 0.17,
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(
                                      user['image'],
                                    ),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 50,
                            right: 50,
                            child: CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              radius: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 16,
                                child: Icon(
                                  user['gender'] != ""
                                      ? user['gender'] == 'male'
                                          ? Icons.male
                                          : Icons.female
                                      : Icons.question_mark,
                                  color: kSecondColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "${user['username']}",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: kSecondColor,
                      ),
                    ),
                    Text(
                      "${user['email']}",
                      style: const TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildListTileSetting(
                      context: context,
                      isDangerBtn: false,
                      disableArrowRight: false,
                      icon: IconlyLight.edit,
                      title: "แก้ไขโปรไฟล์",
                      eventOnTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    buildListTileSetting(
                      context: context,
                      isDangerBtn: false,
                      disableArrowRight: false,
                      icon: IconlyLight.lock,
                      title: "เปลี่ยนรหัสผ่าน",
                      eventOnTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChangePasswordScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    buildListTileSetting(
                      context: context,
                      isDangerBtn: true,
                      disableArrowRight: true,
                      icon: IconlyLight.logout,
                      title: "ออกจากระบบ",
                      eventOnTap: () => _showConfirmLogoutDialog(),
                    ),
                    buildListTileSetting(
                      context: context,
                      isDangerBtn: true,
                      disableArrowRight: true,
                      icon: IconlyLight.delete,
                      title: "ลบบัญชีผู้ใช้",
                      eventOnTap: () =>
                          _showConfirmDeleteAccountDialog(documentID),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
