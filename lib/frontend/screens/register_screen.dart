import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/models/user_model.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/routes.dart';
import 'package:flutter_ssru_map/frontend/screens/login_screen.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/validators.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../../widgets/button_custom.dart';
import '../../widgets/snackbar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final Future<FirebaseApp> _firebase = Firebase.initializeApp();
  // call firebase auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  // call firebase firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // user object
  UserModel user = UserModel(
      username: '', email: '', password: '', cPassword: '', image: '');

  Future<void> _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // save data to user model
      user.username = _usernameController.text.trim();
      user.email = _usernameController.text.trim();
      user.password = _passwordController.text.trim();
      user.image = '';

      String currentTime = formattedTime(DateTime.now().toString());
      try {
        // create user at Authentication
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // create user at Firestore Database
        // store user info in firestore database
        await firestore.collection("users").doc(cred.user!.uid).set({
          'gender': '',
          'image': '',
          'username': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
          'user_role': userRole[UserRole.member],
          'register_at': currentTime,
          'update_at': currentTime,
        }).then((value) {
          showSnackBar(
            context,
            message: "สมัครบัญชีผู้ใช้สำเร็จ!",
            isSuccessAlert: true,
          );
          _formKey.currentState!.reset();
        });
        // _formKey.currentState!.reset();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(
            context,
            message: 'อีเมลนี้ถูกใช้งานไปแล้ว กรุณาลองใหม่อีกครั้ง',
            isSuccessAlert: false,
          );
        }
      }
    }
  }

  String? cPasswordValidator(String? value) =>
      MatchValidator(errorText: "รหัสผ่านไม่ตรงกัน")
          .validateMatch(value!, _passwordController.text);

  bool _passwordVisible = false;
  bool _cPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _cPasswordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: _firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Error"),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
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
                            // Image.asset(
                            //   undraw_login,
                            //   width: widthScreen * 0.8,
                            // ),
                            Image.asset(
                              myLogo,
                              width: widthScreen * 0.3,
                            ),
                            const Text(
                              "สร้างบัญชีผู้ใช้",
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
                                    /*** INPUT USERNAME ***/
                                    TextFormField(
                                      controller: _usernameController,
                                      
                                      decoration: textInputDecorationWithIcon(
                                        hintText: "กรอกชื่อผู้ใช้",
                                        labelText: "ชื่อผู้ใช้",
                                        icon: const Icon(
                                          IconlyLight.profile,
                                          size: 24,
                                        ),
                                        isPassword: false,
                                        isObSecure: false,
                                        function: () {},
                                      ),
                                      validator: usernameValidator,
                                      onSaved: (String? username) {
                                        _usernameController.text =
                                            username!.trim();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    /*** INPUT EMAIL ***/
                                    TextFormField(
                                      controller: _emailController,
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
                                      validator: emailValidator,
                                      onSaved: (String? email) {
                                        _emailController.text = email!.trim();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    /*** INPUT PASSWORD ***/
                                    TextFormField(
                                      obscureText: !_passwordVisible,
                                      controller: _passwordController,
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
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        },
                                      ),
                                      validator: passwordValidator,
                                      onSaved: (String? password) {
                                        _passwordController.text =
                                            password!.trim();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    /*** INPUT CONFIRM PASSWORD ***/
                                    TextFormField(
                                      obscureText: !_cPasswordVisible,
                                      controller: _cPasswordController,
                                      decoration: textInputDecorationWithIcon(
                                        hintText: "กรอกยืนยันรหัสผ่าน",
                                        labelText: "ยืนยันรหัสผ่าน",
                                        icon: const Icon(
                                          IconlyLight.lock,
                                          size: 24,
                                        ),
                                        isPassword: true,
                                        isObSecure: !_cPasswordVisible,
                                        function: () {
                                          setState(() {
                                            _cPasswordVisible =
                                                !_cPasswordVisible;
                                          });
                                        },
                                      ),
                                      validator: cPasswordValidator,
                                      onSaved: (String? cPassword) {
                                        _cPasswordController.text =
                                            cPassword!.trim();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BuildButton(
                              outlineButton: false,
                              textButton: "สร้างบัญชีผู้ใช้",
                              function: _signUpUser,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "คุณมีบัญชีแล้วใช่ไหม?",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                TextButton(
                                  child: const Text(
                                    "ลงชื่อเข้าใช้",
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, AppRoute.login);
                                  },
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
      },
    );
  }

  OutlineInputBorder errorOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: Colors.red,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        width: 2,
        color: kPrimaryColor,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
