// packages
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ssru_map/backend/cache_image_manager.dart';
import 'package:flutter_ssru_map/models/dropdown_items_model.dart';

// functions
import 'package:flutter_ssru_map/myFunction.dart';

// utils
import 'package:flutter_ssru_map/utils.dart';

// widgets
import 'package:flutter_ssru_map/widgets/detailTextSpanWidget.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';

class LocationsDetailScreen extends StatefulWidget {
  const LocationsDetailScreen({Key? key, required this.locationsID})
      : super(key: key);

  final String locationsID;

  @override
  State<LocationsDetailScreen> createState() => _LocationsDetailScreenState();
}

class _LocationsDetailScreenState extends State<LocationsDetailScreen> {
  Future<DocumentSnapshot>? _locationsFuture;

  @override
  void initState() {
    super.initState();
    _locationsFuture = fetchLocationsByID(widget.locationsID);
    _isShowWebsiteBtn = false;
  }

  Future<DocumentSnapshot> fetchLocationsByID(String documentID) async {
    return FirebaseFirestore.instance
        .collection('locations')
        .doc(documentID)
        .get();
  }

  double latitude = 0.0;
  double longitude = 0.0;
  String labelMap = '';

  String linkWebsite = '';
  bool _isShowWebsiteBtn = false;

  @override
  Widget build(BuildContext context) {
    // String? linkWebsite;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: kGradientColor,
          ),
        ),
        title: const Text(
          "รายละเอียด",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<DocumentSnapshot>(
          future: _locationsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
              );
            } else if (snapshot.hasData) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              latitude = double.parse(data['locations_latitude']);
              longitude = double.parse(data['locations_longitude']);
              labelMap = data['locations_name'];
              linkWebsite = data['locations_website'];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width * 0.6,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: data.containsKey('locations_img')
                          ? data['locations_img'] != ""
                              ?
                              // Image.network(
                              //     data['locations_img'],
                              //     fit: BoxFit.cover,
                              //   )
                              CachedNetworkImage(
                                  cacheManager:
                                      CacheNetworkImage.customCacheManager,
                                  key: UniqueKey(),
                                  imageUrl: data['locations_img'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      ShimmerWidget.rectangular(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6),
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
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  child: Image.asset(noPicture),
                                )
                          : Container(),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: data['locations_id'] != "",
                            child: Text(
                              "อาคาร ${data['locations_id'].toString()}",
                              style: const TextStyle(
                                fontSize: 20,
                                color: kSecondColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['locations_name'] != ""
                                ? data['locations_name']
                                : "-",
                            style: TextStyle(
                              fontSize: data['locations_id'] != "" ? 18 : 20,
                              color: kPrimaryColor,
                            ),
                          ),
                          Visibility(
                            visible: data['locations_anotherName'] != "",
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
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text: data['locations_anotherName'],
                                      style: const TextStyle(
                                        fontSize: 18,
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
                          FittedBox(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kPrimaryColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    getIconData(data['locations_icon']),
                                    size: 18,
                                    color: kPrimaryColor,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    data['locations_icon'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: kSecondColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DetailTextSpanWidget(
                            icon: Icons.location_pin,
                            text: data['locations_address'] ?? '-',
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_workdate'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.work_history,
                              text: data['locations_workdate'] != ""
                                  ? data['locations_workdate']
                                  : "-",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_timedate'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.schedule,
                              text: data['locations_timedate'] != ""
                                  ? "${data['locations_timedate']} น."
                                  : "-",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_website'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.public,
                              text: data['locations_website'] != ""
                                  ? data['locations_website']
                                  : "-",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_email'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.email,
                              text: data['locations_email'] != ""
                                  ? data['locations_email']
                                  : "-",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_tel'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.phone,
                              text: data['locations_tel'] != ""
                                  ? data['locations_tel']
                                  : "-",
                            ),
                          ),
                          const SizedBox(height: 10),
                          Visibility(
                            visible: data['locations_fax'] != "",
                            child: DetailTextSpanWidget(
                              icon: Icons.fax_rounded,
                              text: data['locations_fax'] != ""
                                  ? data['locations_fax']
                                  : "-",
                            ),
                          ),
                        ],
                      ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Visibility(
            //   visible: _isShowWebsiteBtn,
            //   child: Flexible(
            //     flex: 2,
            //     child: FloatingActionButton.extended(
            //       heroTag: 'Go to website btn',
            //       backgroundColor: kPrimaryColor,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //       label: const Text("ไปหน้าเว็บไซต์หลัก"),
            //       onPressed: () => openWebsite(websiteLink: linkWebsite!),
            //     ),
            //   ),
            // ),
            Visibility(
              visible: linkWebsite.length != "",
              child: Flexible(
                flex: 2,
                child: FloatingActionButton.extended(
                  heroTag: 'Go to website btn',
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  label: const Text("ไปหน้าเว็บไซต์หลัก"),
                  onPressed: () => openWebsite(websiteLink: linkWebsite),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: FloatingActionButton.extended(
                heroTag: 'Go to route btn',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: kSecondColor,
                icon: const Icon(Icons.navigation),
                label: const Text("เส้นทาง"),
                onPressed: () =>
                    openOnGoogleMapApp(latitude, longitude, labelMap),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
