import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';

class AddImageButton extends StatelessWidget {
  const AddImageButton({
    Key? key,
    required this.function,
  }) : super(key: key);

  final Function function;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.all(14.0),
          decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: const Icon(
            Icons.add_photo_alternate,
            size: 34,
            color: Colors.white,
          ),
        ),
        onTap: () => function(),
      ),
    );
  }
}
