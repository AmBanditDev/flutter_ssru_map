import 'package:flutter/material.dart';
import '../utils.dart';

class BuildButton extends StatelessWidget {
  final String textButton;
  final VoidCallback function;
  final bool outlineButton;
  const BuildButton({
    Key? key,
    required this.textButton,
    required this.function,
    required this.outlineButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // child: ElevatedButton(
      //   style: outlineButton != true
      //       // background pink button
      //       ? ElevatedButton.styleFrom(
      //           elevation: 0,
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           backgroundColor: kPrimaryColor,
      //           padding: const EdgeInsets.symmetric(vertical: 14),
      //           textStyle: const TextStyle(fontSize: 16),
      //         )
      //       // outline pink button
      //       : ElevatedButton.styleFrom(
      //           elevation: 0,
      //           shape: RoundedRectangleBorder(
      //             side: const BorderSide(
      //               width: 3,
      //               color: kPrimaryColor,
      //             ),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           backgroundColor: Colors.white,
      //           padding: const EdgeInsets.symmetric(vertical: 14),
      //         ),
      //   onPressed: function,
      //   child: Text(
      //     textButton,
      //     style: TextStyle(
      //       fontFamily: K2D,
      //       fontSize: 18,
      //       fontWeight: FontWeight.w500,
      //       color: outlineButton != true ? Colors.white : kPrimaryColor,
      //     ),
      //   ),
      // ),
      child: outlineButton != true
          ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: function,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: kGradientColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  child: Text(
                    textButton,
                    style: const TextStyle(
                      fontFamily: K2D,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          : ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: function,
              child: Ink(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  gradient: kGradientColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    textButton,
                    style: const TextStyle(
                      fontFamily: K2D,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
