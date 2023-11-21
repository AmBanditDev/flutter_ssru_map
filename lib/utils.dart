import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Font Family
const K2D = 'K2D';

// Colors
const Color kPrimaryColor = Color(0xFFF06EAA);
const Color kSecondColor = Color(0xFF0C6FC1);
const Color kThirdColor = Color(0xFF252525);
const Color kFourthColor = Color(0xFFF9F9F9);

const kGradientColor = LinearGradient(
  colors: [Color(0xFFF06EAA), Color(0xFFC32BAC)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const List<Shadow> kTextStroke = [
  Shadow(
      // bottomLeft
      offset: Offset(-1.5, -1.5),
      color: Colors.white),
  Shadow(
      // bottomRight
      offset: Offset(1.5, -1.5),
      color: Colors.white),
  Shadow(
      // topRight
      offset: Offset(1.5, 1.5),
      color: Colors.white),
  Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
      color: Colors.white),
];

// All images
String myLogo = "assets/images/logos/main_logo.png";
String myLogoWhite = "assets/images/logos/logo_white.png";
String ssruLogo = "assets/images/logos/ssru_logo.png";

String noPicture = "assets/images/icons/no_picture.png";
String profileDefault = "assets/images/icons/profile_default.png";

String undraw_login = "assets/images/icons/undraw_login.png";
String undraw_register = "assets/images/icons/undraw_register.png";
String undraw_forgotpw = "assets/images/icons/undraw_forgotpw.png";
String undraw_sendcomment = "assets/images/icons/undraw_sendcomment.png";
String undraw_no_data = "assets/images/icons/undraw_no_data.png";

// CircularProgressIndigator
final myProgressIndigator = LoadingAnimationWidget.fourRotatingDots(
  color: kPrimaryColor,
  size: 50,
);
