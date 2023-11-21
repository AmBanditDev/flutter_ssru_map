import 'package:flutter/material.dart';

showSnackBar(
  BuildContext context, {
  required String message,
  required bool isSuccessAlert,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      content: Text(message),
      backgroundColor: isSuccessAlert == true ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
