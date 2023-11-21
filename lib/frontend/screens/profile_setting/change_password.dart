import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';
import 'package:flutter_ssru_map/widgets/button_custom.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _cNewPasswordController = TextEditingController();

  bool _newPasswordVisible = false;
  bool _cNewPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _newPasswordVisible = false;
    _cNewPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // backgroundColor: kPrimaryColor,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: kGradientColor,
          ),
        ),
        title: const Text(
          "เปลี่ยนรหัสผ่าน",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "สร้างรหัสผ่านใหม่",
                style: TextStyle(
                  fontSize: 30,
                  color: kSecondColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_newPasswordVisible,
                      decoration: textInputDecorationWithIcon(
                        hintText: "กรอกรหัสผ่านใหม่",
                        labelText: "รหัสผ่านใหม่",
                        icon: const Icon(
                          IconlyLight.lock,
                          size: 26,
                        ),
                        isPassword: true,
                        isObSecure: !_newPasswordVisible,
                        function: () {
                          setState(() {
                            _newPasswordVisible = !_newPasswordVisible;
                          });
                        },
                      ),
                      validator: RequiredValidator(
                        errorText: "กรุณากรอกรหัสผ่านใหม่",
                      ),
                      onSaved: (String? value) {
                        _newPasswordController.text = value!.trim();
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _cNewPasswordController,
                      obscureText: !_cNewPasswordVisible,
                      decoration: textInputDecorationWithIcon(
                        hintText: "กรอกยืนยันรหัสผ่านใหม่",
                        labelText: "ยืนยันรหัสผ่านใหม่",
                        icon: const Icon(
                          IconlyLight.lock,
                          size: 26,
                        ),
                        isPassword: true,
                        isObSecure: !_cNewPasswordVisible,
                        function: () {
                          setState(() {
                            _cNewPasswordVisible = !_cNewPasswordVisible;
                          });
                        },
                      ),
                      validator: (String? value) =>
                          MatchValidator(errorText: "รหัสผ่านใหม่ไม่ตรงกัน")
                              .validateMatch(
                        value!,
                        _newPasswordController.text.trim(),
                      ),
                      onSaved: (String? value) {
                        _cNewPasswordController.text = value!.trim();
                      },
                    ),
                    const SizedBox(height: 20),
                    BuildButton(
                      textButton: "เปลี่ยนรหัสผ่าน",
                      outlineButton: false,
                      function: () => changePassword(),
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

  Future<void> changePassword() async {
    final userProvider =
        Provider.of<UserProvider>(context, listen: false).users;
    final newPassword = _newPasswordController.text;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      // Update at Firebase Authentication
      await user!.updatePassword(newPassword);

      // Update at Firebase Firestore Database
      await userProvider
          .doc(user!.uid)
          .update({'password': newPassword}).then((value) {
        Navigator.pop(context);
        showSnackBar(context,
            message: "เปลี่ยนรหัสผ่านสำเร็จ!", isSuccessAlert: true);
        _formKey.currentState!.reset();
      });
    } catch (e) {
      print(e.toString());
    }
  }
}
