import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';

class DetailTextSpanWidget extends StatelessWidget {
  const DetailTextSpanWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              color: kSecondColor,
            ),
          ),
          TextSpan(
            text: "   $text",
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'K2D',
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
