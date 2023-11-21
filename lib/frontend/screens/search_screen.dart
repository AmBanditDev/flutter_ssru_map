import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/models/locations_model.dart';
import 'package:flutter_ssru_map/providers/locations_provider.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/listTile_custom_widget.dart';
import 'package:provider/provider.dart';

import '../../utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // This controller will store the value of the search bar
  final TextEditingController _searchController = TextEditingController();
  bool _showCloseIcon = false;

  @override
  void initState() {
    _searchController.addListener(_searchControllerListener);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _searchControllerListener() {
    setState(() {
      _showCloseIcon = _searchController.text.isNotEmpty;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _showCloseIcon = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationsProvider = Provider.of<LocationsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text(
          "ค้นหาสถานที่ภายในมหาวิทยาลัยฯ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: 'กรอกเลขสถานที่/ชื่อสถานที่/ชื่อเรียกอื่น',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kPrimaryColor, width: 2),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Visibility(
                  visible: _showCloseIcon,
                  child: GestureDetector(
                    child: const Icon(Icons.close),
                    onTap: () {
                      setState(() {
                        _searchController.clear();
                        _clearSearch();
                      });
                      // reset search results at locations provider
                      locationsProvider.searchLocations(_searchController.text);
                    },
                  ),
                ),
              ),
              onChanged: (value) {
                if (_searchController.text.isNotEmpty) {
                  setState(() {
                    _showCloseIcon = !_showCloseIcon;
                    _searchController.text = value;
                  });
                }

                // Change the cursor position
                _searchController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _searchController.text.length));
                locationsProvider.searchLocations(value);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Consumer<LocationsProvider>(
              builder: (context, locationsSearchProvider, child) {
                final searchResults = locationsSearchProvider.searchResults;
                return RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: kSecondColor,
                      fontFamily: K2D,
                      fontSize: 18,
                    ),
                    children: [
                      const TextSpan(text: "พบข้อมูลสถานที่ "),
                      TextSpan(
                        text: "${searchResults.length}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: " รายการ"),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          locationsProvider.searchResults.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/icons/location.png",
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "คุณกำลังมองหาสถานที่ใดอยู่?",
                          style: TextStyle(
                            fontSize: 20,
                            color: kSecondColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: locationsProvider.searchResults.length,
                    itemBuilder: (context, index) {
                      final locations = locationsProvider.searchResults[index];

                      return buildListTileCustom(
                        context: context,
                        locationsImg: locations.image.toString(),
                        locationsId: locations.locatId.toString(),
                        locationsName: locations.name.toString(),
                        documentID: locations.docId.toString(),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
