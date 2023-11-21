// packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/widgets/addImageButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:form_field_validator/form_field_validator.dart';

final List<String> _locationsList = ['อาคาร', 'คณะ', 'หน่วยงาน', 'อื่นๆ'];

class TestFormScreen extends StatefulWidget {
  const TestFormScreen({super.key});

  @override
  State<TestFormScreen> createState() => _TestFormScreenState();
}

class _TestFormScreenState extends State<TestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = _locationsList.first;

  final TextEditingController _locationsIDController = TextEditingController();
  final TextEditingController _locationsNameController =
      TextEditingController();
  final TextEditingController _locationsLatitudeController =
      TextEditingController();
  final TextEditingController _locationsLongitudeController =
      TextEditingController();

  File? _imageFile;
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text("Test Form Add Locations"),
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
                            fit: BoxFit.cover,
                          ),
                  ),
                  child: AddImageButton(
                    function: () => _pickImgFromGallery(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _locationsIDController,
                        decoration: kTextInputDecoration(
                          hintText: "กรอกหมายเลขอาคาร",
                          labelText: "หมายเลขอาคาร",
                        ),
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                          errorText: "กรุณากรอกหมายเลขอาคาร",
                        ),
                        onSaved: (String? value) {
                          _locationsIDController.text = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField(
                        value: dropdownValue,
                        decoration: InputDecoration(
                          isDense: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        items: _locationsList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _locationsNameController,
                  decoration: kTextInputDecoration(
                    hintText: "กรอกชื่ออาคาร",
                    labelText: "ชื่ออาคาร",
                  ),
                  validator: RequiredValidator(
                    errorText: "กรุณากรอกชื่ออาคาร",
                  ),
                  onSaved: (String? value) {
                    _locationsNameController.text = value!;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _locationsLatitudeController,
                        decoration: kTextInputDecoration(
                          hintText: "พิกัดอาคาร (ละติจูด)",
                          labelText: "พิกัดอาคาร (ละติจูด)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: "กรุณากรอกพิกัด (ละติจูด)"),
                        onSaved: (String? value) {
                          _locationsLatitudeController.text = value!;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        controller: _locationsLongitudeController,
                        decoration: kTextInputDecoration(
                          hintText: "พิกัดอาคาร (ลองจิจูด)",
                          labelText: "พิกัดอาคาร (ลองจิจูด)",
                        ),
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: "กรุณากรอกพิกัด (ลองจิจูด)"),
                        onSaved: (String? value) {
                          _locationsLongitudeController.text = value!;
                        },
                      ),
                    ),
                  ],
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
                      ),
                    ),
                    child: const Text(
                      "เพิ่มข้อมูล",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => addDataToDB(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration kTextInputDecoration({
    required String hintText,
    required String labelText,
  }) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      label: Text(labelText),
      // labelStyle: const TextStyle(
      //   color: kSecondColor,
      // ),
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: kPrimaryColor,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 2,
        ),
      ),
    );
  }

  Future<void> _pickImgFromGallery() async {
    /* 1 : Pick Image */
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    print('${file!.path}');

    // set image path
    setState(() {
      _imageFile = File(file.path);
    });

    if (file == null) return;

    /* 2 : Upload to firebase storage */
    // get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImage = referenceRoot.child('locations_images');

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

  Future<void> addDataToDB() async {
    final locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("กรุณาเพิ่มรูปภาพด้วย"),
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String locationsID = _locationsIDController.text;
        String locationsName = _locationsNameController.text;
        String locationsLatitude = _locationsLatitudeController.text;
        String locationsLongitude = _locationsLongitudeController.text;
        String locationsCategory = dropdownValue;

        String currentTime = formattedTime(DateTime.now().toString());

        Map<String, String> locationsData = {
          'locations_id': locationsID,
          'locations_name': locationsName,
          'locations_category': locationsCategory,
          'locations_latitude': locationsLatitude,
          'locations_longitude': locationsLongitude,
          'locations_img': imageUrl,
          'create_at': currentTime,
          'edit_at': currentTime,
        };
        if (locationsID != null &&
            locationsName != null &&
            locationsCategory != null &&
            locationsLatitude != null &&
            locationsLongitude != null) {
          locationsProvider.addLocation(locationsData).then((value) {
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
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
