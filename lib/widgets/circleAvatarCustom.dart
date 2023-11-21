import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';

Widget circleAvatarCustomWidget({
  required double radius,
  required bool isNetworkImage,
  required String image,
}) {
  return CircleAvatar(
    radius: radius,
    backgroundColor: kPrimaryColor,
    child: isNetworkImage != true
        ? CircleAvatar(
            radius: (radius - 5),
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(image),
          )
        : CircleAvatar(
            radius: (radius - 5),
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(image),
          ),
  );
}
