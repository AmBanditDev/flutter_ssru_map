import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';

class CommentManageScreen extends StatefulWidget {
  const CommentManageScreen({super.key});

  @override
  State<CommentManageScreen> createState() => _CommentManageScreenState();
}

class _CommentManageScreenState extends State<CommentManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: Text("ความคิดเห็นของผู้ใช้"),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text("1"),
            title: const Text(
              "ความคิดเห็นจาก ชื่อผู้ใช้",
              style: TextStyle(
                color: kSecondColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "เนื้อความ",
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () {},
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
