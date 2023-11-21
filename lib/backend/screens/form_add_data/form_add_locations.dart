import 'dart:io';

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

List<String> locationsList = ["อาคาร", "คณะ", "หน่วยงาน", "อื่นๆ"];
List<String> labelIconList = [
  "การศึกษา",
  "สำนักงาน",
  "พิพิธภัณฑ์",
  "ร้านค้า",
  "ร้านอาหาร",
  "ร้านกาแฟ",
  "ทางเข้าออก"
];

// List<DropdownItem> iconsList = [
//   DropdownItem(label: "การศึกษา", iconData: Icons.school_rounded),
//   DropdownItem(label: "สำนักงาน", iconData: Icons.domain),
//   DropdownItem(label: "พิพิธภัณฑ์", iconData: Icons.museum_outlined),
//   DropdownItem(label: "ร้านค้า", iconData: Icons.storefront),
//   DropdownItem(label: "ร้านอาหาร", iconData: Icons.restaurant),
//   DropdownItem(label: "ร้านกาแฟ", iconData: Icons.local_cafe),
//   DropdownItem(label: "ทางเข้าออก", iconData: Icons.door_sliding),
// ];

class FormAddLocationsScreen extends StatefulWidget {
  const FormAddLocationsScreen({super.key});

  @override
  State<FormAddLocationsScreen> createState() => _FormAddLocationsScreenState();
}

class _FormAddLocationsScreenState extends State<FormAddLocationsScreen> {
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
  String dropdownLocationsValue = locationsList.first;
  String dropdownIconValue  = labelIconList.first;

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
        title: const Text("ฟอร์มเพิ่มข้อมูลสถานที่"),
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
                /*** Image Container ***/
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
                const SizedBox(height: 16),
                /*** Row 1 ***/
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
                            errorText: "กรุณากรอกชื่อสถานที่"),
                        onSaved: (String? value) {
                          _locationsNameController.text = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                /*** Row 2 ***/
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
                /*** Row 3 ***/
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField(
                        value: dropdownLocationsValue,
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
                              value: value,
                              child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownLocationsValue = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      flex: 1,
                      child: DropdownButtonFormField(
                        value: dropdownIconValue,
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
                                Icon(getIconData(value), color: kPrimaryColor),
                                const SizedBox(width: 10),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownIconValue = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                /*** Row 4 ***/
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
                /*** Row 5 ***/
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
                          errorText: "กรุณากรอกพิกัด (ละติจูด)",
                        ),
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
                          errorText: "กรุณากรอกพิกัด (ลองจิจูด)",
                        ),
                        onSaved: (String? value) {
                          _locationsLongitudeController.text = value!;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                /*** Row 6 ***/
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
                /*** Row 7 ***/
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                /*** Row 8 ***/
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
                /*** Row 9 ***/
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
                /*** Row 10 ***/
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

  Future<void> _addDataToDB() async {
    final locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String locationsCategory = dropdownLocationsValue;
        String locationsIcon = dropdownIconValue;
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

        print(locationsCategory);
        print(locationsIcon);

        // String currentTime = formattedTime(DateTime.now().toString());

        // Map<String, String> locationsData = {
        //   'locations_id': locationsID,
        //   'locations_name': locationsName,
        //   'locations_anotherName': locationsAnotherName,
        //   'locations_address': locationsAddress,
        //   'locations_category': locationsCategory,
        //   'locations_icon': locationsIcon,
        //   'locations_latitude': locationsLatitude,
        //   'locations_longitude': locationsLongitude,
        //   'locations_website': locationsWebsite,
        //   'locations_workdate': locationsWorkdate,
        //   'locations_timedate': locationsTimedate,
        //   'locations_tel': locationsTel,
        //   'locations_fax': locationsFax,
        //   'locations_email': locationsEmail,
        //   'locations_img': imageUrl,
        //   'create_at': currentTime,
        //   'edit_at': currentTime,
        // };
        // if (locationsName.isNotEmpty &&
        //     locationsCategory.isNotEmpty &&
        //     locationsAddress.isNotEmpty &&
        //     locationsLatitude.isNotEmpty &&
        //     locationsLongitude.isNotEmpty) {
        //   locationsProvider.addLocation(locationsData).then((value) {
        //     Navigator.pop(context);
        //     showSnackBar(
        //       context,
        //       message: "เพิ่มข้อมูลสำเร็จ!",
        //       isSuccessAlert: true,
        //     );
        //     _formKey.currentState!.reset();
        //     setState(() {
        //       _imageFile = null;
        //     });
        //   });
        // }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
