// packages
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:flutter_ssru_map/utils.dart';

// widgets
import 'package:flutter_ssru_map/widgets/content_list.dart';
import 'package:flutter_ssru_map/widgets/topnav_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          TopNavHomeWidget(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ContentListWidget(),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            border: Border.all(
              color: kSecondColor,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(100)),
        child: FittedBox(
          child: FloatingActionButton(
            elevation: 6,
            backgroundColor: Colors.white,
            child: Image.asset(
              "assets/images/logos/main_logo.png",
              width: MediaQuery.of(context).size.width * 0.12,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.map);
            },
          ),
        ),
      ),
    );
  }
}
