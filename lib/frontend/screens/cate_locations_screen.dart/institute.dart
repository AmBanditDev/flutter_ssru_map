import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/frontend/screens/detail_screen/locations_detail_screen.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/buildShimmerLoading.dart';
import 'package:flutter_ssru_map/widgets/listTile_custom_widget.dart';
import 'package:provider/provider.dart';

class InstitudeScreen extends StatefulWidget {
  const InstitudeScreen({super.key});

  @override
  State<InstitudeScreen> createState() => _InstitudeScreenState();
}

class _InstitudeScreenState extends State<InstitudeScreen> {
  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationsProvider>(context).locations;
    // find locations category = institude
    final facultyData = locationsProvider
        .where('locations_category', isEqualTo: 'หน่วยงาน')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: facultyData,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildlocationsShimmer();
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
          );
        } else if (snapshot.hasData) {
          final locations = snapshot.data.docs;
          if (locations.length <= 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icons/not_found.png",
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ไม่พบรายการข้อมูล!",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations[index].data();
                final documentID = locations[index].id;
                return buildListTileCustom(
                  context: context,
                  locationsImg: location['locations_img'],
                  locationsId: location['locations_id'],
                  locationsName: location['locations_name'],
                  documentID: documentID,
                );
              },
            );
          }
        } else {
          return Center(child: myProgressIndigator);
        }
      },
    );
  }
}
