import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/models/dropdown_items_model.dart';
import 'package:flutter_ssru_map/myFunction.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/addImageButton.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';
import 'package:flutter_ssru_map/widgets/textFormField_widget.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FormEditLocations extends StatefulWidget {
  const FormEditLocations({super.key, required this.locationsID});

  final String locationsID;

  @override
  State<FormEditLocations> createState() => _FormEditLocationsState();
}

class _FormEditLocationsState extends State<FormEditLocations> {
  final _formKey = GlobalKey<FormState>();

  final _locationsIDController = TextEditingController();
  final _locationsNameController = TextEditingController();
  final _locationsAnotherNameController = TextEditingController();
  final _locationsAddressController = TextEditingController();
  final _locationsLatitudeController = TextEditingController();
  final _locationsLongitudeController = TextEditingController();
  final _locationsLinkWebsiteController = TextEditingController();
  final _locationsWorkDateController = TextEditingController();
  final _locationsTimeDateController = TextEditingController();
  final _locationsTelController = TextEditingController();
  final _locationsFaxController = TextEditingController();
  final _locationsEmailController = TextEditingController();

  // Dropdown values
  // locations value
  String oldDropdownLocationsValue = '';
  String newDropdownLocationsValue = '';
  String tempDropdownLocationsValue = '';

  // icon value
  String oldDropdownLabelIconValue = '';
  String newDropdownLabelIconValue = '';
  String tempDropdownLabelIconValue = '';

  // image
  File? _newImageFile;

  String _oldImageUrl = '';
  String _newImageUrl = '';

  Future<DocumentSnapshot>? _locationsFuture;

  @override
  void initState() {
    super.initState();
    _locationsFuture = fetchLocationsByID(widget.locationsID);
  }

  Future<DocumentSnapshot> fetchLocationsByID(String locationsID) async {
    return FirebaseFirestore.instance
        .collection('locations')
        .doc(locationsID)
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
        title: const Text("ฟอร์มแก้ไขข้อมูลสถานที่"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, size: 26),
            onPressed: () => updateDataToDB(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _locationsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data!.data() as Map<dynamic, dynamic>;

                _locationsIDController.text = data['locations_id'];
                _locationsNameController.text = data['locations_name'];
                _locationsAnotherNameController.text =
                    data['locations_anotherName'];
                _locationsAddressController.text = data['locations_address'];
                _locationsLatitudeController.text = data['locations_latitude'];
                _locationsLongitudeController.text =
                    data['locations_longitude'];
                _locationsLinkWebsiteController.text =
                    data['locations_website'];
                _locationsWorkDateController.text = data['locations_workdate'];
                _locationsTimeDateController.text = data['locations_timedate'];
                _locationsTelController.text = data['locations_tel'];
                _locationsFaxController.text = data['locations_fax'];
                _locationsEmailController.text = data['locations_email'];

                // old dropdown value
                oldDropdownLocationsValue = data['locations_category'];
                tempDropdownLocationsValue = oldDropdownLocationsValue;

                oldDropdownLabelIconValue = data['locations_icon'];
                tempDropdownLabelIconValue = oldDropdownLabelIconValue;

                // old image url
                _oldImageUrl = data['locations_img'];
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
                                        data['locations_img'],
                                      ),
                                      fit: BoxFit.fitHeight,
                                    )
                                  : DecorationImage(
                                      image: AssetImage(noPicture),
                                    )
                              : DecorationImage(
                                  image: FileImage(_newImageFile!),
                                  fit: BoxFit.fitHeight,
                                ),
                        ),
                        child: AddImageButton(
                          function: () => _showPopupSelectChangeImage(),
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
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกเลขสถานที่",
                                labelText: "เลขสถานที่",
                              ),
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                _locationsIDController.text = value!;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 2,
                            child: TextFormField(
                              controller: _locationsNameController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกชื่อสถานที่",
                                labelText: "ชื่อสถานที่ *",
                              ),
                              validator: RequiredValidator(
                                errorText: "กรุณากรอกชื่อสถานที่",
                              ),
                              onSaved: (String? value) {
                                _locationsNameController.text = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationsAnotherNameController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกชื่อเรียกอื่น (ถ้ามี)",
                          labelText: "ชื่อเรียกอื่น (ถ้ามี)",
                        ),
                        onSaved: (String? value) {
                          _locationsAnotherNameController.text = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField(
                              value: tempDropdownLocationsValue,
                              style: const TextStyle(
                                color: kSecondColor,
                                fontFamily: K2D,
                                fontSize: 16,
                              ),
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
                              items: locationsList.map((String value) {
                                return DropdownMenuItem<String>(
                                    value: value, child: Text(value));
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (tempDropdownLocationsValue != null) {
                                  newDropdownLocationsValue = newValue!;
                                  tempDropdownLocationsValue =
                                      newDropdownLocationsValue;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: DropdownButtonFormField(
                              value: tempDropdownLabelIconValue,
                              style: const TextStyle(
                                color: kSecondColor,
                                fontFamily: K2D,
                                fontSize: 16,
                              ),
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
                              items: labelIconList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(getIconData(value),
                                          color: kPrimaryColor),
                                      const SizedBox(width: 10),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (tempDropdownLabelIconValue != null) {
                                  newDropdownLabelIconValue = newValue!;
                                  tempDropdownLabelIconValue =
                                      newDropdownLabelIconValue;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationsAddressController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกที่อยู่สถานที่",
                          labelText: "ที่อยู่สถานที่ *",
                        ),
                        validator: RequiredValidator(
                          errorText: "กรุณากรอกที่อยู่สถานที่",
                        ),
                        onSaved: (String? value) {
                          _locationsAddressController.text = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              controller: _locationsLatitudeController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "พิกัดสถานที่ (ละติจูด)",
                                labelText: "พิกัดสถานที่ (ละติจูด)*",
                              ),
                              keyboardType: TextInputType.number,
                              validator: RequiredValidator(
                                  errorText: "กรุณากรอกพิกัด (ละติจูด)"),
                              onSaved: (String? value) {
                                _locationsLatitudeController.text = value!;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              controller: _locationsLongitudeController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "พิกัดสถานที่ (ลองจิจูด)",
                                labelText: "พิกัดสถานที่ (ลองจิจูด)*",
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
                      TextFormField(
                        controller: _locationsLinkWebsiteController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกลิ้งค์เว็บไซต์ (ถ้ามี)",
                          labelText: "ลิ้งค์เว็บไซต์ (ถ้ามี)",
                        ),
                        onSaved: (String? value) {
                          _locationsLinkWebsiteController.text = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              controller: _locationsWorkDateController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกวันทำการของสถานที่",
                                labelText: "วันทำการของสถานที่",
                              ),
                              onSaved: (String? value) {
                                _locationsWorkDateController.text = value!;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            flex: 1,
                            child: TextFormField(
                              controller: _locationsTimeDateController,
                              decoration: textInputDecorationWithOutIcon(
                                hintText: "กรอกเวลาทำการของสถานที่",
                                labelText: "เวลาทำการของสถานที่",
                              ),
                              onSaved: (String? value) {
                                _locationsTimeDateController.text = value!;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationsTelController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกเบอร์โทรศัพท์",
                          labelText: "เบอร์โทรศัพท์",
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {
                          _locationsTelController.text = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationsFaxController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกเบอร์โทรสาร",
                          labelText: "เบอร์โทรสาร",
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {
                          _locationsFaxController.text = value!;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationsEmailController,
                        decoration: textInputDecorationWithOutIcon(
                          hintText: "กรอกอีเมล",
                          labelText: "อีเมล",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? value) {
                          _locationsEmailController.text = value!;
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: myProgressIndigator);
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
      _newImageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      print("Error: $error");
    }
  }

  Future<void> updateDataToDB() async {
    final locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
    try {
      String locationsCategory = tempDropdownLocationsValue;
      String locationsIcon = tempDropdownLabelIconValue;
      String locationsID = _locationsIDController.text;
      String locationsName = _locationsNameController.text;
      String locationsAnotherName = _locationsAnotherNameController.text;
      String locationsAddress = _locationsAddressController.text;
      String locationsLatitude = _locationsLatitudeController.text;
      String locationsLongitude = _locationsLongitudeController.text;
      String locationsWebsite = _locationsLinkWebsiteController.text;
      String locationsWorkdate = _locationsWorkDateController.text;
      String locationsTimedate = _locationsTimeDateController.text;
      String locationsTel = _locationsTelController.text;
      String locationsFax = _locationsFaxController.text;
      String locationsEmail = _locationsEmailController.text;

      String currentTime = formattedTime(DateTime.now().toString());

      Map<String, String> locationsData = {
        'locations_id': locationsID,
        'locations_name': locationsName,
        'locations_anotherName': locationsAnotherName,
        'locations_address': locationsAddress,
        'locations_category': locationsCategory,
        'locations_icon': locationsIcon,
        'locations_latitude': locationsLatitude,
        'locations_longitude': locationsLongitude,
        'locations_website': locationsWebsite,
        'locations_workdate': locationsWorkdate,
        'locations_timedate': locationsTimedate,
        'locations_tel': locationsTel,
        'locations_fax': locationsFax,
        'locations_email': locationsEmail,
        'locations_img': _newImageUrl.isNotEmpty ? _newImageUrl : _oldImageUrl,
        'edit_at': currentTime,
      };
      if (locationsName.isNotEmpty &&
          locationsAddress.isNotEmpty &&
          locationsCategory.isNotEmpty &&
          locationsLatitude.isNotEmpty &&
          locationsLongitude.isNotEmpty) {
        locationsProvider
            .updateLocation(widget.locationsID, locationsData)
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
