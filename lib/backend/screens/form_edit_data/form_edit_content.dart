// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/widgets/addImageButton.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/button_custom.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ssru_map/providers/content_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';

class FormEditContentScreen extends StatefulWidget {
  const FormEditContentScreen({super.key, required this.contentID});

  final String contentID;

  @override
  State<FormEditContentScreen> createState() => _FormEditContentScreenState();
}

class _FormEditContentScreenState extends State<FormEditContentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _contentTitleController = TextEditingController();
  final TextEditingController _contentDetailController =
      TextEditingController();

  // image
  File? _newImageFile;

  String _oldImageUrl = '';
  String _imageUrl = '';

  Future<DocumentSnapshot>? _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = fetchContentById(widget.contentID);
  }

  Future<DocumentSnapshot> fetchContentById(String contentID) async {
    return FirebaseFirestore.instance
        .collection('content_ssru')
        .doc(contentID)
        .get();
  }

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
        title: const Text("ฟอร์มแก้ไขเนื้อหามหาลัยฯ"),
        actions: [
          IconButton(
            onPressed: () => updateDataToDB(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: _contentFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("เกิดข้อผิดพลาดในการเรียกข้อมูล");
              } else if (snapshot.hasData) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                _contentTitleController.text = data['content_title'];
                _contentDetailController.text = data['content_detail'];
                // old image url
                _oldImageUrl = data['content_img'];
                return Form(
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
                          image: _newImageFile == null
                              ? _oldImageUrl != ""
                                  ? DecorationImage(
                                      image: NetworkImage(
                                        data.containsKey('content_img')
                                            ? data['content_img']
                                            : null,
                                      ),
                                      fit: BoxFit.fitHeight,
                                    )
                                  : DecorationImage(
                                      image: AssetImage(noPicture),
                                    )
                              : DecorationImage(
                                  image: FileImage(_newImageFile!),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        child: AddImageButton(
                          function: () => _showPopupSelectChangeImage(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _contentTitleController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกหัวข้อเนื้อหา",
                          labelText: "หัวข้อเนื้อหา",
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
                        controller: _contentDetailController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกรายละเอียด",
                          labelText: "รายละเอียด",
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
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
      _newImageFile = File(file.path);
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
      _imageUrl = await referenceImageToUpload.getDownloadURL();
      print(_imageUrl);
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> updateDataToDB() async {
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      String contentTitle = _contentTitleController.text;
      String contentDetail = _contentDetailController.text;
      String currentTime = formattedTime(DateTime.now().toString());

      Map<String, String> contentData = {
        'content_title': contentTitle,
        'content_detail': contentDetail,
        'content_img': _imageUrl.isNotEmpty ? _imageUrl : _oldImageUrl,
        'edit_at': currentTime,
      };

      // print(contentTitle);
      // print(contentDetail);
      // print("Old image url = $_oldImageUrl");
      // print("New image url = $imageUrl");
      if (contentTitle.isNotEmpty && contentDetail.isNotEmpty) {
        contentProvider
            .updateContent(widget.contentID, contentData)
            .then((value) {
          Navigator.pop(context);
          showSnackBar(
            context,
            message: "แก้ไขข้อมูลสำเร็จ!",
            isSuccessAlert: true,
          );
          _formKey.currentState!.reset();
          setState(() {
            _newImageFile = null;
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
