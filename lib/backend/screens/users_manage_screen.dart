import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/backend/screens/form_edit_data/form_edit_user.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/circleAvatarCustom.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:provider/provider.dart';

class UsersManageScreen extends StatefulWidget {
  const UsersManageScreen({super.key});

  @override
  State<UsersManageScreen> createState() => _UsersManageScreenState();
}

class _UsersManageScreenState extends State<UsersManageScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context)
        .users
        .orderBy('register_at', descending: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text("รายการบัญชีผู้ใช้"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userProvider.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("เกิดข้อผิดพลาดบางอย่าง: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data.docs;
            return ListView.separated(
              itemCount: users.length,
              itemBuilder: (context, index) {
                // Get the item at this index
                final user = users[index].data();
                final documentID = users[index].id;
                return ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: user['image'] == ""
                      ? circleAvatarCustomWidget(
                          radius: 30,
                          isNetworkImage: false,
                          image: profileDefault,
                        )
                      : circleAvatarCustomWidget(
                          radius: 30,
                          isNetworkImage: true,
                          image: user['image'],
                        ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 12),
                        decoration: BoxDecoration(
                          color: user['user_role'] == 'member'
                              ? Colors.blue
                              : kPrimaryColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          "${user['user_role']}".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        "${user['username']}",
                        style: const TextStyle(
                          color: kSecondColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showUserDialog(
                    image: user['image'],
                    urole: user['user_role'],
                    username: user['username'],
                    email: user['email'],
                    gender: user['gender'],
                    registerAt: user['register_at'],
                    updateAt: user['update_at'],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              },
            );
          } else {
            return Center(child: myProgressIndigator);
          }
        },
      ),
    );
  }

  Future<void> _showUserDialog({
    required String image,
    required String urole,
    required String username,
    required String email,
    required String gender,
    required String registerAt,
    required String updateAt,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: Column(
              children: [
                image == ""
                    ? circleAvatarCustomWidget(
                        radius: 80,
                        image: profileDefault,
                        isNetworkImage: false,
                      )
                    : circleAvatarCustomWidget(
                        radius: 80,
                        image: image,
                        isNetworkImage: true,
                      ),
                const SizedBox(height: 40),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  decoration: BoxDecoration(
                    color: urole == 'member' ? Colors.blue : kPrimaryColor,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Text(
                    urole.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kSecondColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 18,
                    color: kPrimaryColor,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                Text(
                  "เพศ: ${gender == '' ? 'ไม่ระบุ' : gender == 'male' ? 'ชาย' : 'หญิง'}",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "สมัครเมื่อ: $registerAt",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "แก้ไขเมื่อ: $updateAt",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ปิด',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
