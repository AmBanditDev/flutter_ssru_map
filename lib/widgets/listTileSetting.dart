import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/utils.dart';

Widget buildListTileSetting({
  required BuildContext context,
  required bool isDangerBtn,
  required bool disableArrowRight,
  required IconData icon,
  required String title,
  required eventOnTap,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: isDangerBtn == true ? Colors.red : kSecondColor,
    ),
    title: Text(
      title,
      style: TextStyle(
        color: isDangerBtn == true ? Colors.red : kSecondColor,
      ),
    ),
    trailing: disableArrowRight == true
        ? const Icon(null)
        : const Icon(
            IconlyLight.arrowRight2,
            size: 24,
            color: kSecondColor,
          ),
    onTap: eventOnTap,
  );
}
