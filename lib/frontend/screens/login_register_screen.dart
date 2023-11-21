import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/widgets/button_custom.dart';

import '../../routes.dart';
import '../../utils.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg/gps_map.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            color: Colors.black.withOpacity(0.15),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      myLogo,
                      width: widthScreen * 0.3,
                    ),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: "SSRU ",
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              shadows: kTextStroke,
                            ),
                          ),
                          TextSpan(
                            text: "Map",
                            style: TextStyle(
                              color: kSecondColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              shadows: kTextStroke,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    BuildButton(
                      outlineButton: false,
                      textButton: "สร้างบัญชีผู้ใช้",
                      function: () =>
                          Navigator.pushNamed(context, AppRoute.register),
                    ),
                    const SizedBox(height: 20),
                    BuildButton(
                      outlineButton: true,
                      textButton: "ลงชื่อเข้าใช้",
                      function: () =>
                          Navigator.pushNamed(context, AppRoute.login),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
