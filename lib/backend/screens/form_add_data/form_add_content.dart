// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/providers/content_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/addImageButton.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FormAddContentScreen extends StatefulWidget {
  const FormAddContentScreen({super.key});

  @override
  State<FormAddContentScreen> createState() => _FormAddContentScreenState();
}

class _FormAddContentScreenState extends State<FormAddContentScreen> {
  final _formKey = GlobalKey<FormState>();

  // controllers
  final TextEditingController _contentTitleController = TextEditingController();
  final TextEditingController _contentDetailController =
      TextEditingController();

  // image
  File? _imageFile;
  String imageUrl = '';

  Future<void> _showPopupSelectChangeImage() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text("ฟอร์มเพิ่มเนื้อหามหาลัยฯ"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, size: 26),
            onPressed: () => _addDataToDB(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    image: _imageFile == null
                        ? const DecorationImage(
                            image: AssetImage(
                              "assets/images/icons/no_image.png",
                            ),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                  child: AddImageButton(
                    function: () => _showPopupSelectChangeImage(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecorationWithOutIcon(
                    hintText: "กรอกหัวข้อเนื้อหา",
                    labelText: "หัวข้อเนื้อหา *",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกหัวข้อเนื้อหา';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _contentTitleController.text = value!;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  maxLines: 6,
                  textAlign: TextAlign.start,
                  decoration: textInputDecorationWithOutIcon(
                    hintText: "กรอกรายละเอียด",
                    labelText: "รายละเอียด *",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                  onSaved: (String? value) {
                    _contentDetailController.text = value!;
                  },
                ),
              ],
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
        source:
            isFromGallery == true ? ImageSource.gallery : ImageSource.camera);
    print('${file!.path}');

    // set image path
    setState(() {
      _imageFile = File(file.path);
    });

    if (file == null) return;

    /* 2 : Upload to firebase storage */
    // get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('content_images');

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
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> _addDataToDB() async {
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    // if (imageUrl.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("กรุณาเพิ่มรูปภาพด้วย"),
    //     ),
    //   );
    //   return;
    // }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String contentTitle = _contentTitleController.text;
        String contentDetail = _contentDetailController.text;
        String currentTime = formattedTime(DateTime.now().toString());

        Map<String, String> contentData = {
          "content_title": contentTitle,
          "content_detail": contentDetail,
          "content_img": imageUrl,
          "create_at": currentTime,
          "edit_at": currentTime,
        };
        if (contentTitle != null && contentDetail != null) {
          contentProvider.addContent(contentData).then((value) {
            Navigator.pop(context);
            showSnackBar(
              context,
              message: "เพิ่มข้อมูลสำเร็จ!",
              isSuccessAlert: true,
            );
            _formKey.currentState!.reset();
            setState(() {
              _imageFile = null;
            });
          });
        }
      } catch (error) {
        print("Error: $error");
      }
    }
  }
}
