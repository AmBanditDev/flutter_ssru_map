import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/utils.dart';

InputDecoration textInputDecorationWithOutIcon({
  required String hintText,
  required String labelText,
}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,
    label: Text(labelText),
    labelStyle: const TextStyle(
      color: kSecondColor,
    ),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade400,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: kPrimaryColor,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}

InputDecoration textInputDecorationWithIcon({
  required String hintText,
  required String labelText,
  required Icon icon,
  required bool isPassword,
  required bool isObSecure,
  required Function function,
}) {
  return InputDecoration(
    isDense: true,
    hintText: hintText,
    filled: true,
    fillColor: Colors.white.withOpacity(0.4),
    prefixIcon: icon,
    suffixIcon: isPassword == false
        ? const Icon(null)
        : isObSecure
            ? IconButton(
                icon: const Icon(IconlyLight.show, size: 24),
                onPressed: () {
                  function();
                },
              )
            : IconButton(
                icon: const Icon(IconlyLight.hide, size: 24),
                onPressed: () {
                  function();
                },
              ),
    label: Text(labelText),
    labelStyle: const TextStyle(
      color: kSecondColor,
      // color: Colors.white,
    ),
    alignLabelWithHint: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1.4,
      ),
    ),
    focusedBorder: OutlineInputBorder(

      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: kPrimaryColor,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}
