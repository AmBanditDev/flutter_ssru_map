import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/models/locations_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationsProvider extends ChangeNotifier {
  final CollectionReference _locations =
      FirebaseFirestore.instance.collection('locations');
  List<Locations> _locationsList = []; // รายการสถานที่ที่ตรงกับการค้นหา
  List<Locations> _searchResults = [];

  final List<LatLng> _pointsSSRU = const [
    LatLng(13.773553, 100.506182),
    LatLng(13.778189, 100.508390),
    LatLng(13.778245, 100.508668),
    LatLng(13.777519, 100.510278),
    LatLng(13.775424, 100.509131),
    LatLng(13.774729, 100.508902),
    LatLng(13.774356, 100.508266),
    LatLng(13.773968, 100.508125),
    LatLng(13.773733, 100.508094),
    LatLng(13.773495, 100.508153),
    LatLng(13.773303, 100.508267),
    LatLng(13.773243, 100.508353),
    LatLng(13.773153, 100.508538),
    LatLng(13.772608, 100.508270),
    LatLng(13.773554, 100.506180),
  ];

  CollectionReference get locations => _locations;
  List<Locations> get locationsList => _locationsList;
  List<Locations> get searchResults => _searchResults;
  List<LatLng> get pointsSSRU => _pointsSSRU;

  void searchLocations(String query) {
    _locations.get().then((querySnapshot) {
      _locationsList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Locations(
          docId: doc.id,
          locatId: data['locations_id'],
          name: data['locations_name'],
          anotherName: data['locations_anotherName'],
          category: data['locations_category'],
          icon: data['locations_icon'],
          address: data['locations_address'],
          lat: data['locations_latitude'],
          lng: data['locations_longitude'],
          website: data['locations_website'],
          workdate: data['locations_workdate'],
          timedate: data['locations_timedate'],
          tel: data['locations_tel'],
          fax: data['locations_fax'],
          email: data['locations_email'],
          image: data['locations_img'],
          createAt: data['create_at'],
          editAt: data['edit_at'],
        );
      }).toList();

      if (query.isEmpty) {
        _searchResults.clear();
      } else {
        // ค้นหาด้วย หมายเลขอาคาร, ชื่ออาคาร, ชื่ออื่นๆ
        _searchResults = _locationsList
            .where((locations) =>
                locations.locatId!.contains(query) ||
                locations.name!.toLowerCase().contains(query) ||
                locations.anotherName!.toLowerCase().contains(query))
            .toList();

        _searchResults.sort((a, b) => a.locatId!.compareTo(b.locatId!));
      }

      notifyListeners();
    }).catchError((error) {
      print('Error searching products: $error');
    });
  }

  Stream<int> getCountLocationsStream() {
    return _locations.snapshots().map(
          (snapshot) => snapshot.size,
        );
  }

  Future<void> addLocation(Map<String, dynamic> data) async {
    await _locations.add(data);
    notifyListeners();
  }

  Future<void> updateLocation(
      String documentID, Map<String, dynamic> data) async {
    await _locations.doc(documentID).update(data);
    notifyListeners();
  }

  Future<void> deleteLocation(String documentID) async {
    try {
      var firestore = FirebaseFirestore.instance;
      var locationsDocRef = firestore.collection('locations').doc(documentID);
      var locationsDocSnap = await locationsDocRef.get();

      if (locationsDocSnap.exists) {
        // Get image path from Firestore document
        var imagePath = locationsDocSnap.data()!['locations_img'];

        if (imagePath != null && imagePath.isNotEmpty) {
          // Delete Image from Firebase Storage
          var storage = FirebaseStorage.instance;
          var imageRef = storage.refFromURL(imagePath);
          await imageRef.delete();
        }
        // Delete Data from Firebase Firestore
        await locationsDocRef.delete();
        print('Locations data deleted successfully');
      } else {
        print('Locations document does not exist');
      }
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }
}
