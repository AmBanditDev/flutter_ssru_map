// packages
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
// screens
import 'package:flutter_ssru_map/models/user_model.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/button_custom.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../../widgets/snackbar.dart';
import '../../widgets/textFormField_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  UserModel user = UserModel(
      username: '', email: '', password: '', cPassword: '', image: '');

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  Future<void> _signInUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: user.email.toString(), password: user.password.toString());
        if (userCredential != null) {
          // Get the user role
          final user = userCredential.user;
          if (user != null) {
            var userRole = await getUserRole(user.uid);
            // print("User role = $userRole");
            // print("User role type = ${userRole.runtimeType}");
            if (userRole == 'admin') {
              // ถ้าผู้ใช้มีระดับเป็น admin
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.dashboard,
                (route) => false,
              );
            } else if (userRole == 'member') {
              // ถ้าผู้ใช้มีระดับเป็น member
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoute.home,
                (route) => false,
              );
            } else {
              // Invalid user role
              print('ระดับผู้ใช้ไม่ถูกต้อง');
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        // print(e.code);
        // อีเมลนี้มีอยู่ในระบบแล้ว
        // แจ้งเตือนผู้ใช้ว่าอีเมลนี้ถูกใช้แล้ว
        if (e.code == 'email-already-in-use') {
          showSnackBar(
            context,
            message: 'อีเมลนี้ถูกใช้งานแล้ว กรุณาลองใหม่อีกครั้ง',
            isSuccessAlert: false,
          );
        } else if (e.code == 'user-not-found') {
          showSnackBar(
            context,
            message: 'ไม่มีอีเมลนี้ในระบบ กรุณาลองใหม่อีกครั้ง',
            isSuccessAlert: false,
          );
        } else if (e.code == 'wrong-password') {
          showSnackBar(
            context,
            message: 'รหัสผ่านของคุณไม่ถูกต้อง กรุณาลองใหม่อีกครั้ง',
            isSuccessAlert: false,
          );
        }
      } catch (e) {
        // เกิดข้อผิดพลาดอื่นๆ
        print(e.toString());
      }
    }
  }

  Future<String> getUserRole(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot.get('user_role') as String;
      } else {
        return 'เกิดข้อผิดพลาด';
      }
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(    
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg/review_ssru.jpg"),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black.withOpacity(0.1),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        myLogo,
                        width: widthScreen * 0.3,
                      ),
                      const Text(
                        "ลงชื่อเข้าใช้",
                        style: TextStyle(
                          fontSize: 30,
                          color: kSecondColor,
                          fontWeight: FontWeight.bold,
                          shadows: kTextStroke,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white70,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _usernameController,
                                decoration: textInputDecorationWithIcon(
                                  hintText: "กรอกอีเมล",
                                  labelText: "อีเมล",
                                  icon: const Icon(
                                    IconlyLight.message,
                                    size: 24,
                                  ),
                                  isPassword: false,
                                  isObSecure: false,
                                  function: () {},
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณากรอกอีเมล"),
                                  EmailValidator(errorText: "อีเมลไม่ถูกต้อง"),
                                ]),
                                onSaved: (String? email) {
                                  user.email = email!;
                                },
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: textInputDecorationWithIcon(
                                    hintText: "กรอกรหัสผ่าน",
                                    labelText: "รหัสผ่าน",
                                    icon: const Icon(
                                      IconlyLight.lock,
                                      size: 24,
                                    ),
                                    isPassword: true,
                                    isObSecure: !_passwordVisible,
                                    function: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    }),
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "กรุณากรอกรหัสผ่าน"),
                                ]),
                                onSaved: (String? password) {
                                  user.password = password!;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: const Text(
                            "ลืมรหัสผ่าน?",
                            style: TextStyle(
                              fontSize: 16,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoute.forgetPassword);
                          },
                        ),
                      ),
                      BuildButton(
                        textButton: "ลงชื่อเข้าใช้",
                        outlineButton: false,
                        function: _signInUser,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "คุณยังไม่มีบัญชีใช่ไหม?",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          TextButton(
                            child: const Text(
                              "สร้างบัญชีผู้ใช้",
                              style: TextStyle(
                                color: kPrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoute.register,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
