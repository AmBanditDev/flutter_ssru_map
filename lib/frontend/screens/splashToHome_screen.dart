import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashToHomeScreen extends StatefulWidget {
  const SplashToHomeScreen({super.key});

  @override
  State<SplashToHomeScreen> createState() => _SplashToHomeScreenState();
}

class _SplashToHomeScreenState extends State<SplashToHomeScreen> {
  bool _isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 4),
      () {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, AppRoute.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg/gps_map.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withOpacity(0.2),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/logos/main_logo.png",
                    width: 240,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "SSRU ",
                          style: textSpanStyle(
                            color: kPrimaryColor,
                          ),
                        ),
                        TextSpan(
                          text: "Map",
                          style: textSpanStyle(
                            color: kSecondColor,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 180),
                  _isLoading
                      ? LoadingAnimationWidget.fourRotatingDots(
                          color: kPrimaryColor,
                          size: 50,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle textSpanStyle({required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      shadows: kTextStroke,
    );
  }
}
