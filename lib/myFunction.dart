import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

// Function format datetime
String formattedTime(String datatime) {
  DateTime parsedTime = DateTime.parse(datatime);
  String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedTime);
  return formattedTime;
}

// Function show logout dialog
Future<void> showLogoutDialog(BuildContext context) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        content: const Text(
          "คุณต้องการออกจากระบบหรือไม่?",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            child: const Text(
              'ยกเลิก',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(
              'ออกจากระบบ',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () async {
              await auth.signOut().then((value) {
                Navigator.pushReplacementNamed(
                  context,
                  AppRoute.login,
                );
              });
            },
          ),
        ],
      );
    },
  );
}

// Function sending location to open in Google Maps app
Future<void> openOnGoogleMapApp(
    double latitude, double longitude, String label) async {
  await MapsLauncher.launchCoordinates(latitude, longitude, label);
}

// Function open website
Future<void> openWebsite({required String websiteLink}) async {
  String url = websiteLink;
  Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print("Could not open the website.");
  }
}
