// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// providers
import 'package:flutter_ssru_map/providers/gender_provider.dart';
import 'package:flutter_ssru_map/providers/user_provider.dart';

// widgets
import 'package:flutter_ssru_map/widgets/button_custom.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';

// utilities
import 'package:flutter_ssru_map/utils.dart';

// validators
import 'package:flutter_ssru_map/validators.dart';

enum Genders { male, female }

Map<Genders, String> genders = {
  Genders.male: "male",
  Genders.female: "female",
};

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  // default selected gender
  String _selectedGenders = 'male';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

  // image
  File? _imageFile;

  String _oldImageUrl = '';
  String _imageUrl = '';

  String checkGenderUser(Genders gender) {
    String userGender = '';
    switch (gender) {
      case Genders.male:
        userGender = genders[Genders.male]!;
        break;
      case Genders.female:
        userGender = genders[Genders.female]!;
        break;
      default:
        userGender = 'No Gender';
    }
    return userGender;
  }

  Future<void> _showPopupSelectEditProfile() async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            SimpleDialogOption(
              child: const Text("ถ่ายภาพ", style: TextStyle(fontSize: 18)),
              onPressed: () {
                _pickImage(isFromGallery: false);
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: const Text("เลือกภาพ", style: TextStyle(fontSize: 18)),
              onPressed: () {
                _pickImage(isFromGallery: true);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   print("Image File = ${_imageFile}");
  //   print("Old Image Url = ${_oldImageUrl}");
  //   print("Current Image Url = ${_imageUrl}");
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context).users;
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: kGradientColor,
          ),
        ),
        title: const Text(
          "แก้ไขโปรไฟล์",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<DocumentSnapshot>(
              future: userProvider.doc(user!.uid).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
                  );
                } else if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  _usernameController.text = userData['username'];
                  _emailController.text = userData['email'];
                  _oldImageUrl = userData['image'];
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: widthScreen * 0.4,
                        height: widthScreen * 0.4,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: widthScreen * 0.18,
                              backgroundColor: kPrimaryColor,
                              /* ถ้าผู้ใช้ไม่มี profile => แสดงภาพโปรไฟล์ปลอม
                              ถ้าผู้ใช้มี profile => แสดงภาพโปรไฟล์ผู้ใช้ */
                              // ถ้าผู้ใช้ต้องการเปลี่ยนภาพโปรไฟล์อีกครั้ง
                              /* ถ้าผู้ใช้เปลี่ยน profile ใหม่ => แสดงภาพโปรไฟล์ใหม่แทน
                              ถ้าผู้ใช้ไม่เปลี่ยน profile ใหม่ => แสดงภาพโปรไฟล์เดิม */
                              child: _oldImageUrl == ""
                                  // ถ้าไม่ได้เลือกภาพใหม่
                                  ? _imageFile == null
                                      ? CircleAvatar(
                                          radius: widthScreen * 0.17,
                                          backgroundColor: kPrimaryColor,
                                          backgroundImage:
                                              AssetImage(profileDefault),
                                        )
                                      : CircleAvatar(
                                          radius: widthScreen * 0.17,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              FileImage(_imageFile!),
                                        )
                                  // ถ้า path imageUrl เป็นค่าว่าง (ไม่ได้เลือกภาพใหม่)
                                  // => แสดงภาพเดิมในฐานข้อมูล
                                  // ถ้า path imageUrl ไม่เป็นค่าว่าง (มีการเลือกภาพใหม่)
                                  // => แสดงภาพใหม่จากที่เลือก
                                  : _imageUrl == ""
                                      ? CircleAvatar(
                                          radius: widthScreen * 0.17,
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            _oldImageUrl,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: widthScreen * 0.17,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              FileImage(_imageFile!),
                                        ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 50,
                              right: 50,
                              child: GestureDetector(
                                child: const CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  radius: 20,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                                onTap: () => _showPopupSelectEditProfile(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<GenderProvider>(
                                  builder: (context, genderProvider, child) {
                                    return Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          genderProvider.isMale = true;
                                          setState(() {
                                            _selectedGenders =
                                                checkGenderUser(Genders.male);
                                            print(_selectedGenders);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: genderProvider.maleColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.male,
                                                size: 30,
                                                color: genderProvider.maleColor,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "เพศชาย",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      genderProvider.maleColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                Consumer<GenderProvider>(
                                  builder: (context, genderProvider, child) {
                                    return Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          genderProvider.isMale = false;
                                          setState(() {
                                            _selectedGenders =
                                                checkGenderUser(Genders.female);
                                            print(_selectedGenders);
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: genderProvider.femaleColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.female,
                                                size: 30,
                                                color:
                                                    genderProvider.femaleColor,
                                              ),
                                              Text(
                                                "เพศหญิง",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: genderProvider
                                                      .femaleColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            const Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                "ชื่อผู้ใช้",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: kSecondColor,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _usernameController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกชื่อผู้ใช้",
                                labelText: "",
                              ),
                              validator: usernameValidator,
                              onSaved: (String? value) {
                                _usernameController.text = value!;
                              },
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.only(
                                bottom: 10,
                              ),
                              child: Text(
                                "อีเมล",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: kSecondColor,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกอีเมล",
                                labelText: "",
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: emailValidator,
                              onSaved: (String? value) {
                                _emailController.text = value!;
                              },
                            ),
                            const SizedBox(height: 40),
                            BuildButton(
                              textButton: "บันทึกข้อมูล",
                              outlineButton: false,
                              function: () => updateInfoUser(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  // return Center(child: myProgressIndigator);
                  return const Center(
                    child: Text("ไม่มีข้อมูล"),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage({required bool isFromGallery}) async {
    /* 1 : Pick Image */
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(
      source: isFromGallery == true ? ImageSource.gallery : ImageSource.camera,
    );
    print('${file!.path}');

    // set image path
    setState(() {
      _imageFile = File(file.path);
    });

    if (file == null) return;

    /* 2 : Upload to firebase storage */
    // get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('user_images');

    // Change image name
    String uniqueFileName =
        DateTime.now().millisecondsSinceEpoch.toString(); // Ex. 1661845640186

    // create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImage.child(uniqueFileName);

    // handle
    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file.path));
      // Success: get the download URL
      _imageUrl = await referenceImageToUpload.getDownloadURL();
      // refresh ui
      setState(() {});
      print(_imageUrl);
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> updateInfoUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        String userGender = _selectedGenders;
        String username = _usernameController.text;
        String email = _emailController.text;
        String currentImage = '';
        String currentTime = formattedTime(DateTime.now().toString());
        // ถ้าไม่ได้เลือกภาพใหม่
        if (_imageUrl.isEmpty && _imageUrl == '') {
          // ภาพปัจจุบัน คือ profile default
          currentImage = '';
        } else {
          // ภาพปัจจุบัน คือ ภาพที่เลือก
          currentImage = _imageUrl;
        }

        // ถ้ามีภาพเก่า และมีการเลือกภาพใหม่
        if (_oldImageUrl != '' && _imageUrl != '') {
          // ภาพปัจจุบัน คือ ภาพใหม่จากที่เลือก
          currentImage = _imageUrl;
          // ถ้ามีภาพเก่า แต่ไม่เลือกภาพใหม่
        } else if (_oldImageUrl != '' && _imageUrl == '') {
          // ภาพปัจจุบัน คือ ภาพเดิมจากฐานข้อมูล
          currentImage = _oldImageUrl;
        }

        Map<String, String> userData = {
          'gender': userGender,
          'username': username,
          'email': email,
          'image': currentImage,
          'update_at': currentTime,
        };

        print(userData);

        if (userGender.isNotEmpty && username.isNotEmpty && email.isNotEmpty) {
          userProvider.editUser(user!.uid, userData).then((value) {
            Navigator.pop(context);
            showSnackBar(
              context,
              message: "อัพเดตข้อมูลผู้ใช้แล้ว",
              isSuccessAlert: true,
            );
            _formKey.currentState!.reset();
            _imageFile = null;
            // setState(() {
            //   _imageFile = null;
            // });
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          showSnackBar(
            context,
            message: 'อีเมลนี้ถูกใช้งานไปแล้ว กรุณาลองใหม่อีกครั้ง',
            isSuccessAlert: false,
          );
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
