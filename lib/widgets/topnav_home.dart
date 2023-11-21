import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:provider/provider.dart';

class TopNavHomeWidget extends StatefulWidget {
  const TopNavHomeWidget({super.key});

  @override
  State<TopNavHomeWidget> createState() => _TopNavHomeWidgetState();
}

class _TopNavHomeWidgetState extends State<TopNavHomeWidget> {
  // call firebase auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).users;

    final widthScreen = MediaQuery.of(context).size.width;
    return StreamBuilder<DocumentSnapshot>(
      stream: userProvider.doc(user!.uid).snapshots(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: myProgressIndigator);
        }
        return Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: kGradientColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.all(20),
              constraints: const BoxConstraints(
                maxHeight: 200,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 56,
                        child: Image.asset(myLogoWhite),
                      ),
                      const Text(
                        "SSRU Map",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'K2D',
                          ),
                          children: [
                            const TextSpan(
                              text: "ยินดีต้อนรับ\n",
                              style: TextStyle(fontSize: 16),
                            ),
                            TextSpan(
                              text: "คุณ ${user!['username']}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CircleAvatar(
                        radius: widthScreen * 0.08,
                        backgroundColor: Colors.white,
                        child: user['image'] == ""
                            ? CircleAvatar(
                                radius: widthScreen * 0.07,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(profileDefault),
                              )
                            : CircleAvatar(
                                radius: widthScreen * 0.07,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(user['image']),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
