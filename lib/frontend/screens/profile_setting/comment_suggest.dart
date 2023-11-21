import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/widgets/button_custom.dart';
import 'package:flutter_ssru_map/utils.dart';

class CommentSuggestScreen extends StatefulWidget {
  const CommentSuggestScreen({Key? key}) : super(key: key);

  @override
  State<CommentSuggestScreen> createState() => _CommentSuggestScreenState();
}

class _CommentSuggestScreenState extends State<CommentSuggestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          "ส่งความคิดเห็น",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ฟอร์มกรอกความคิดเห็น",
                  style: TextStyle(
                    fontSize: 30,
                    color: kSecondColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _labeltxtInput(labelName: "ชื่อผู้ใช้"),
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          // prefixIcon: const Icon(Icons.lock),
                          hintText: "ชื่อผู้ใช้",
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _labeltxtInput(labelName: "ความคิดเห็น"),
                      TextFormField(
                        minLines:
                            6, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: kPrimaryColor,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          // prefixIcon: const Icon(Icons.lock),
                          hintText: "กรอกความคิดเห็นของคุณ..",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BuildButton(
                  textButton: "ส่งความคิดเห็น",
                  outlineButton: false,
                  function: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _labeltxtInput extends StatelessWidget {
  final labelName;
  const _labeltxtInput({
    Key? key,
    required this.labelName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        labelName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: kSecondColor,
        ),
      ),
    );
  }
}
