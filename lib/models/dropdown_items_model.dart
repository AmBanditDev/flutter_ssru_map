import 'package:flutter/material.dart';

class DropdownItem {
  final String label;
  final String? labelIcon;

  DropdownItem({required this.label, required this.labelIcon});
}

List<String> locationsList = ["อาคาร", "คณะ", "หน่วยงาน", "อื่นๆ"];
List<String> labelIconList = [
  "สถานศึกษา",
  "สำนักงาน",
  "พิพิธภัณฑ์",
  "สวน",
  "สนามกีฬา",
  "สระว่ายน้ำ",
  "ร้านค้า",
  "ร้านอาหาร",
  "ร้านกาแฟ",
  "ทางเข้าออก"
];

IconData getIconData(String labelIcon) {
  if (labelIcon == "สถานศึกษา") {
    return Icons.school_rounded;
  } else if (labelIcon == "สำนักงาน") {
    return Icons.domain;
  } else if (labelIcon == "พิพิธภัณฑ์") {
    return Icons.museum_outlined;
  } else if (labelIcon == "สวน") {
    return Icons.park;
  } else if (labelIcon == "สนามกีฬา") {
    return Icons.stadium;
  } else if (labelIcon == "สระว่ายน้ำ") {
    return Icons.pool;
  } else if (labelIcon == "ร้านค้า") {
    return Icons.storefront;
  } else if (labelIcon == "ร้านอาหาร") {
    return Icons.restaurant;
  } else if (labelIcon == "ร้านกาแฟ") {
    return Icons.local_cafe;
  } else if (labelIcon == "ทางเข้าออก") {
    return Icons.door_sliding;
  } else {
    return Icons.question_mark;
  }
}
