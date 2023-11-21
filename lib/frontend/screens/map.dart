// packages
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/models/dropdown_items_model.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:custom_map_markers/custom_map_markers.dart';

import 'package:flutter_ssru_map/myFunction.dart';

import '../../backend/cache_image_manager.dart';
import '../../widgets/shimmer_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  List<MarkerData> markers = [];
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  LocationData? _currentLocation;
  bool _isChangeMapType = false;

  _customMarker({required String locationNum, required String locationIcon}) {
    return Stack(
      children: [
        const Icon(
          Icons.add_location,
          color: kPrimaryColor,
          size: 60,
          shadows: [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 4,
              blurRadius: 20,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        Positioned(
          left: 18,
          top: 10,
          child: Container(
            width: 25,
            height: 25,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: locationNum.isNotEmpty & locationIcon.isNotEmpty
                ? Center(
                    child: Text(
                      locationNum,
                      style: const TextStyle(
                        color: kSecondColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : Center(
                    child: Icon(
                      getIconData(locationIcon),
                      color: kSecondColor,
                      size: 18,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Location service is not enabled, handle it accordingly
        print('Location service is not enabled');
        return;
      }
    }

    // Check if location permission is granted
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Location permission is not granted, handle it accordingly
        print('Location permission is not granted');
        return;
      }
    }

    // Get current location
    try {
      _currentLocation = await location.getLocation();
      setState(() {
        // Update UI with the current location
      });
    } catch (e) {
      // Handle any errors that occur during location retrieval
      print('Failed to get the current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationsProvider>(context).locations;
    final pointsSSRU = Provider.of<LocationsProvider>(context).pointsSSRU;
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
          "แผนที่มหาวิทยาลัยฯ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: locationsProvider.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
            );
          } else if (snapshot.hasData) {
            markers.clear();
            final locations = snapshot.data!.docs;
            for (var location in locations) {
              final locationData = location.data() as Map<String, dynamic>;
              final double lat =
                  double.parse(locationData['locations_latitude']);
              final double lng =
                  double.parse(locationData['locations_longitude']);
              final String imageUrl = locationData['locations_img'];

              final MarkerData marker = MarkerData(
                marker: Marker(
                  markerId: MarkerId(location.id),
                  position: LatLng(lat, lng),
                  onTap: () {
                    _customInfoWindowController.addInfoWindow!(
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Container(
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  cacheManager:
                                      CacheNetworkImage.customCacheManager,
                                  key: UniqueKey(),
                                  imageUrl: locationData['locations_img'],
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.medium,
                                  placeholder: (context, url) {
                                    return const ShimmerWidget.rectangular(
                                      height: double.infinity,
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Image.asset(noPicture);
                                  },
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Visibility(
                                            visible:
                                                locationData['locations_id'] !=
                                                    "",
                                            child: Text(
                                              "อาคาร ${locationData['locations_id'].toString()}",
                                              style: const TextStyle(
                                                color: kSecondColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            locationData['locations_name'],
                                            style: const TextStyle(
                                              color: kPrimaryColor,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: GestureDetector(
                                        child: Container(
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                kSecondColor.withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              Icon(
                                                Icons.navigation,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                "เส้นทาง",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: () => openOnGoogleMapApp(
                                            lat,
                                            lng,
                                            locationData['locations_name']),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      LatLng(lat, lng),
                    );
                  },
                ),
                child: _customMarker(
                  locationNum: locationData['locations_id'],
                  locationIcon: locationData['locations_icon'],
                ),
              );
              markers.add(marker);
            }
          }

          return Stack(
            children: [
              CustomGoogleMapMarkerBuilder(
                customMarkers: markers,
                builder: (BuildContext context, Set<Marker>? markers) {
                  if (markers == null) {
                    return Center(child: myProgressIndigator);
                  }
                  return GoogleMap(
                    mapType: _isChangeMapType == false
                        ? MapType.normal
                        : MapType.satellite,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(13.776426, 100.508720),
                      zoom: 17.5,
                    ),
                    //   polygons: {
                    polygons: {
                      Polygon(
                        polygonId: const PolygonId('p1'),
                        strokeColor: Colors.red.shade300,
                        fillColor: Colors.pink.withOpacity(0.05),
                        strokeWidth: 2,
                        points: pointsSSRU,
                      ),
                    },
                    markers: markers,
                    onMapCreated: (GoogleMapController controller) {
                      _customInfoWindowController.googleMapController =
                          controller;
                    },
                    onTap: (position) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    onCameraMove: (position) {
                      _customInfoWindowController.onCameraMove!();
                    },
                  );
                },
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                width: widthScreen * 0.9,
                height: widthScreen * 0.65,
                offset: 40,
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 80),
        child: FloatingActionButton(
          heroTag: "Switch Map Mode",
          elevation: 0,
          backgroundColor: kPrimaryColor.withOpacity(0.8),
          child: const Icon(
            Icons.layers,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _isChangeMapType = !_isChangeMapType;
            });
          },
        ),
      ),
    );
  }
}
