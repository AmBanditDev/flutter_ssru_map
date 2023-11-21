import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:flutter_ssru_map/frontend/screens/search_screen.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/tabbar_material_widget.dart';

import 'home_screen.dart';
import 'launcher_locations_screen.dart';
import 'profile_screen.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pageWidget = <Widget>[
    const HomeScreen(),
    const LauncherLocationsScreen(),
    const SearchScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  StreamSubscription? _subscription;
  bool _isDeviceConnected = false;
  bool _isAlertSet = false;

  @override
  void initState() {
    super.initState();
    getConnectivity();
  }

  getConnectivity() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      _isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!_isDeviceConnected && _isAlertSet == false) {
        showDialogBox();
        setState(() {
          _isAlertSet = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _selectedIndex == 0
                ? const Icon(IconlyBold.home)
                : const Icon(IconlyLight.home),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 1
                ? const Icon(IconlyBold.location)
                : const Icon(IconlyLight.location),
            label: 'สถานที่ทั้งหมด',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 2
                ? const Icon(IconlyBold.search)
                : const Icon(IconlyLight.search),
            label: 'ค้นหาสถานที่',
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 3
                ? const Icon(IconlyBold.profile)
                : const Icon(IconlyLight.profile),
            label: 'บัญชีผู้ใช้',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.blueGrey,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }

  void showDialogBox() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: SizedBox(
            height: 100,
            child: Image.asset("assets/images/icons/no_wifi.png"),
          ),
          content: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'K2D',
              ),
              children: [
                TextSpan(
                  text: "ไม่มีการเชื่อมต่ออินเตอร์เน็ต\n",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kSecondColor),
                ),
                TextSpan(
                  text: "โปรดเชื่อมต่ออินเตอร์เน็ตก่อนใช้งาน",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("ตกลง"),
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() {
                  _isAlertSet = false;
                });
                _isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!_isDeviceConnected) {
                  showDialogBox();
                  setState(() {
                    _isAlertSet = true;
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }
}
