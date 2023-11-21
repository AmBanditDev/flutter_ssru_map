import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';

class FormEditUser extends StatefulWidget {
  const FormEditUser({super.key, required this.userID});

  final String userID;

  @override
  State<FormEditUser> createState() => _FormEditUserState();
}

class _FormEditUserState extends State<FormEditUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text("ฟอร์มแก้ไขข้อมูลผู้ใช้"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=387&q=80",
                ),
                radius: 80,
              ),
              const SizedBox(height: 40),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      decoration: textInputDecorationWithOutIcon(
                        hintText: "กรอกชื่อผู้ใช้",
                        labelText: "ชื่อผู้ใช้",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: textInputDecorationWithOutIcon(
                        hintText: "กรอกอีเมล",
                        labelText: "อีเมล",
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            padding: const EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        child: const Text(
                          "บันทึกข้อมูล",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
