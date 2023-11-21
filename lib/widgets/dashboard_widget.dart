import 'package:flutter/material.dart';

Widget dashboardCardWidget({
  required BuildContext context,
  required String title,
  required String unit,
  required String number,
  required Widget nextScreen,
  required Color gridColors,
}) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.43,
    margin: const EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: gridColors,
        width: 2,
      ),
      color: gridColors.withOpacity(0.2),
    ),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 0),
            RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontFamily: 'K2D',
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "${number.toString()} ",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  TextSpan(
                    text: unit,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "ดูเพิ่มเติม",
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => nextScreen,
          ),
        );
      },
    ),
  );
}
