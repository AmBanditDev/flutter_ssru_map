import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/models/user_model.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:provider/provider.dart';

import '../backend/screens/content_manage_screen.dart';
import '../backend/screens/locations_manage_screen.dart';
import '../backend/screens/users_manage_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // call firebase auth
    final user = FirebaseAuth.instance.currentUser;
    final userProvider = Provider.of<UserProvider>(context).users;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          StreamBuilder<DocumentSnapshot>(
            stream: userProvider.doc(user!.uid).snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: myProgressIndigator);
              }
              if (snapshot.hasError) {
                return const Center(
                  child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
                );
              } else if (snapshot.hasData) {
                final user = snapshot.data!.data() as Map<String, dynamic>;
                final userModel = UserModel(
                  username: user['username'],
                  email: user['email'],
                  password: user['password'],
                  cPassword: '',
                  image: user['image'],
                );

                return UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: kGradientColor,
                  ),
                  accountName: Text(
                    userModel.username,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    userModel.email,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  currentAccountPictureSize: const Size.square(64),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Center(
                      child: userModel.image != ""
                          ? CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                userModel.image,
                              ),
                            )
                          : CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              backgroundImage: AssetImage(profileDefault),
                            ),
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text("ไม่พบข้อมูล"),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(
              IconlyBold.profile,
              color: kSecondColor,
            ),
            title: const Text("บัญชีผู้ใช้"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UsersManageScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              IconlyBold.infoSquare,
              color: kSecondColor,
            ),
            title: const Text("เนื้อหาหน้าหลัก"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContentManageScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              IconlyBold.location,
              color: kSecondColor,
            ),
            title: const Text("สถานที่ในมหาลัยฯ"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationsManageScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              IconlyBold.logout,
              color: Colors.red,
            ),
            title: const Text(
              "ออกจากระบบ",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onTap: () => showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
