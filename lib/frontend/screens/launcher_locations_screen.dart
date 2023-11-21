import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/frontend/screens/cate_locations_screen.dart/faculty.dart';
import 'package:flutter_ssru_map/frontend/screens/cate_locations_screen.dart/institute.dart';
import 'package:flutter_ssru_map/frontend/screens/cate_locations_screen.dart/locations.dart';
import 'package:flutter_ssru_map/frontend/screens/cate_locations_screen.dart/locations_other.dart';
import 'package:flutter_ssru_map/utils.dart';

class LauncherLocationsScreen extends StatefulWidget {
  const LauncherLocationsScreen({Key? key}) : super(key: key);

  @override
  State<LauncherLocationsScreen> createState() =>
      _LauncherLocationsScreenState();
}

class _LauncherLocationsScreenState extends State<LauncherLocationsScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: kGradientColor,
            ),
          ),
          leading: const Icon(null),
          title: const Text(
            "สถานที่ภายในมหาวิทยาลัยฯ",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            indicatorColor: kSecondColor,
            indicatorWeight: 3,
            tabs: <Widget>[
              Tab(
                text: "อาคาร",
              ),
              Tab(
                text: "คณะ",
              ),
              Tab(
                text: "หน่วยงาน",
              ),
              Tab(
                text: "อื่นๆ",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            LocationsScreen(),
            FacultyScreen(),
            InstitudeScreen(),
            LocationsOtherScreen(),
          ],
        ),
      ),
    );
  }
}
