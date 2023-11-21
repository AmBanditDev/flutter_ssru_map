// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/backend/screens/comment_manage_screen.dart';
import 'package:flutter_ssru_map/backend/screens/content_manage_screen.dart';
import 'package:flutter_ssru_map/backend/screens/locations_manage_screen.dart';
import 'package:flutter_ssru_map/backend/screens/users_manage_screen.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/circleAvatarCustom.dart';
import 'package:flutter_ssru_map/widgets/dashboard_widget.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ssru_map/providers/content_provider.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/utils.dart';

// widget
import 'package:flutter_ssru_map/widgets/drawer.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    // calling provider
    final contentsProvider = Provider.of<ContentProvider>(context);
    final locationsProvider = Provider.of<LocationsProvider>(context);
    final usersProvider = Provider.of<UserProvider>(context);
    final usersProviderQuery = Provider.of<UserProvider>(context)
        .users
        .orderBy('register_at', descending: true)
        .limit(5);
    // calling methods count stream
    var stream1 = contentsProvider.getCountContentsStream();
    var stream2 = locationsProvider.getCountLocationsStream();
    var stream3 = usersProvider.getCountUsersStream();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text("ระบบหลังบ้าน - SSRU Map"),
        actions: [
          IconButton(
            icon: const Icon(
              IconlyLight.logout,
            ),
            onPressed: () => showLogoutDialog(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "แดชบอร์ด",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: kSecondColor,
              ),
            ),
          ),
          StreamBuilder3<int, int, int>(
            streams: StreamTuple3(stream1, stream2, stream3),
            initialData: InitialDataTuple3(0, 0, 0),
            builder: (context, snapshots) {
              final countContents = snapshots.snapshot1.data;
              final countLocations = snapshots.snapshot2.data;
              final countUsers = snapshots.snapshot3.data;
              return SizedBox(
                height: MediaQuery.of(context).size.width * 0.32,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    dashboardCardWidget(
                      context: context,
                      gridColors: Colors.orange,
                      title: "บัญชีผู้ใช้",
                      number: "$countUsers",
                      unit: "บัญชี",
                      nextScreen: const UsersManageScreen(),
                    ),
                    dashboardCardWidget(
                      context: context,
                      gridColors: Colors.green,
                      title: "เนื้อหาหน้าหลัก",
                      number: "$countContents",
                      unit: "เนื้อหา",
                      nextScreen: const ContentManageScreen(),
                    ),
                    dashboardCardWidget(
                      context: context,
                      gridColors: Colors.blue,
                      title: "สถานที่ในมหาลัยฯ",
                      number: "$countLocations",
                      unit: "แห่ง",
                      nextScreen: const LocationsManageScreen(),
                    ),
                  ],
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "สมาชิกใหม่ล่าสุด 5 บัญชีแรก",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kSecondColor,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: usersProviderQuery.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text("เกิดข้อผิดพลาดบางอย่าง: ${snapshot.error}");
              } else if (snapshot.hasData) {
                final users = snapshot.data.docs;
                return Flexible(
                  flex: 1,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index].data();
                      return ListTile(
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
                            Text(
                              "${user['username']}",
                              style: const TextStyle(
                                color: kSecondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${user['email']}",
                                style: const TextStyle(color: kPrimaryColor)),
                          ],
                        ),
                        subtitle: Text(
                            "สมัครเมื่อ ${formattedTime(user['register_at'])}"),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}
