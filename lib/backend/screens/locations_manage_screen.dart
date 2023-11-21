// packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ssru_map/models/dropdown_items_model.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ssru_map/backend/cache_image_manager.dart';
// screens
import 'package:flutter_ssru_map/backend/screens/form_add_data/form_add_locations.dart';
import 'package:flutter_ssru_map/backend/screens/form_edit_data/form_edit_locations.dart';

// model
import 'package:flutter_ssru_map/models/locations_model.dart';

// provider
import 'package:flutter_ssru_map/providers/locations_provider.dart';

// utilities
import 'package:flutter_ssru_map/utils.dart';

// widgets
import 'package:flutter_ssru_map/widgets/detailTextSpanWidget.dart';
import 'package:flutter_ssru_map/widgets/snackbar.dart';

class LocationsManageScreen extends StatefulWidget {
  const LocationsManageScreen({super.key});

  @override
  State<LocationsManageScreen> createState() => _LocationsManageScreenState();
}

class _LocationsManageScreenState extends State<LocationsManageScreen> {
  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationsProvider>(context)
        .locations
        .orderBy('create_at', descending: false);
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text("รายการสถานที่"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.add, size: 36),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormAddLocationsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: locationsProvider.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text("เกิดข้อผิดพลาดบางอย่าง: ${snapshot.error}");
          } else if (snapshot.hasData) {
            // Get the data
            final locations = snapshot.data.docs;
            if (locations.length <= 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      undraw_no_data,
                      width: widthScreen * 0.5,
                    ),
                    const Text(
                      "ไม่พบรายการข้อมูล!",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.separated(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index].data();
                  final docId = locations[index].id;
                  // object
                  final locationsData = Locations(
                      docId: docId,
                      locatId: location['locations_id'],
                      name: location['locations_name'],
                      anotherName: location['locations_anotherName'],
                      category: location['locations_category'],
                      icon: location['locations_icon'],
                      address: location['locations_address'],
                      lat: location['locations_latitude'],
                      lng: location['locations_longitude'],
                      website: location['locations_website'],
                      workdate: location['locations_workdate'],
                      timedate: location['locations_timedate'],
                      tel: location['locations_tel'],
                      fax: location['locations_fax'],
                      email: location['locations_email'],
                      image: location['locations_img'],
                      createAt: location['create_at'],
                      editAt: location['edit_at']);
                  final documentID = locations[index].id;
                  return ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: location.containsKey('locations_img')
                          ? locationsData.image != ""
                              ?
                              // Image.network(
                              //     locationsData.image!,
                              //     fit: BoxFit.fitHeight,
                              //   )
                              CachedNetworkImage(
                                  cacheManager:
                                      CacheNetworkImage.customCacheManager,
                                  key: UniqueKey(),
                                  imageUrl: locationsData.image!,
                                  fit: BoxFit.fitHeight,
                                  placeholder: (context, url) =>
                                      const ShimmerWidget.rectangular(
                                          height: 50),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.black12,
                                    child: const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.asset(noPicture))
                          : Container(),
                    ),
                    title: Visibility(
                      visible: locationsData.locatId != "",
                      child: Text(
                        "อาคาร ${locationsData.locatId}",
                        style: const TextStyle(
                          color: kSecondColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(
                      locationsData.name!,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    trailing: Wrap(
                      spacing: 0, // space between two icons
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormEditLocations(
                                  locationsID: documentID,
                                ),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => confirmDeleteDialog(
                            documentID: documentID,
                          ),
                        ),
                      ],
                    ),
                    onTap: () =>
                        _showLocationsDialog(locationsData: locationsData),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0,
                    color: Colors.grey,
                  );
                },
              );
            }
          } else {
            return Center(child: myProgressIndigator);
          }
        },
      ),
    );
  }

  Future<void> _showLocationsDialog({
    required Locations locationsData,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(16),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: locationsData.image != ""
                      ?
                      // Image.network(
                      //     locationsData.image!,
                      //     fit: BoxFit.cover,
                      //   )
                      CachedNetworkImage(
                          cacheManager: CacheNetworkImage.customCacheManager,
                          key: UniqueKey(),
                          imageUrl: locationsData.image!,
                          fit: BoxFit.fitHeight,
                          placeholder: (context, url) =>
                              const ShimmerWidget.rectangular(height: 50),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.black12,
                            child: const Icon(
                              Icons.error,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Image.asset(noPicture),
                        ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.location_searching_sharp,
                      size: 18,
                      color: kSecondColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "${locationsData.lat}, ${locationsData.lng}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  "เพิ่มเมื่อ ${locationsData.createAt!}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "แก้ไขเมื่อ ${locationsData.editAt!}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: locationsData.locatId != "",
                          child: Text(
                            "อาคาร ${locationsData.locatId}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kSecondColor,
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              getIconData(locationsData.icon.toString()),
                              color: kPrimaryColor,
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: kPrimaryColor,
                              ),
                              child: Text(
                                "ประเภท${locationsData.category}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      locationsData.name != ""
                          ? locationsData.name.toString()
                          : "-",
                      style: const TextStyle(
                        fontSize: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                    Visibility(
                      visible: locationsData.anotherName != "",
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: K2D,
                              color: kPrimaryColor,
                            ),
                            children: [
                              const TextSpan(
                                text: "หรือ ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: locationsData.anotherName,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    DetailTextSpanWidget(
                      icon: Icons.location_pin,
                      text: locationsData.address != ""
                          ? locationsData.address.toString()
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                      icon: Icons.work_history,
                      text: locationsData.workdate != ""
                          ? locationsData.workdate.toString()
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                      icon: Icons.schedule,
                      text: locationsData.timedate != ""
                          ? "${locationsData.timedate} น."
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                      icon: Icons.public,
                      text: locationsData.website != ""
                          ? locationsData.website.toString()
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                      icon: Icons.email,
                      text: locationsData.email != ""
                          ? locationsData.email.toString()
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                      icon: Icons.phone,
                      text: locationsData.tel != ""
                          ? locationsData.tel.toString()
                          : "-",
                    ),
                    const SizedBox(height: 10),
                    DetailTextSpanWidget(
                        icon: Icons.fax_rounded,
                        text: locationsData.fax != ""
                            ? locationsData.fax.toString()
                            : "-"),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'ปิด',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmDeleteDialog({
    required String documentID,
  }) async {
    final locationsProvider =
        Provider.of<LocationsProvider>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          content: const Text(
            "คุณต้องการลบข้อมูลนี้หรือไม่?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              child: const Text(
                'ยกเลิก',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ลบ',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                locationsProvider.deleteLocation(documentID).then(
                  (value) {
                    showSnackBar(
                      context,
                      message: "ลบข้อมูลสำเร็จ",
                      isSuccessAlert: true,
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
