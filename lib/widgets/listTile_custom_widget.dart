import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';

import '../backend/cache_image_manager.dart';
import '../frontend/screens/detail_screen/locations_detail_screen.dart';

Widget buildListTileCustom({
  required BuildContext context,
  required String locationsImg,
  required String locationsId,
  required String locationsName,
  required String documentID,
}) {
  return Material(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 80,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: locationsImg != ""
                  ?
                  // Image.network(
                  //     '$locationsImg',
                  //     fit: BoxFit.cover,
                  //   )
                  CachedNetworkImage(
                      cacheManager: CacheNetworkImage.customCacheManager,
                      key: UniqueKey(),
                      imageUrl: locationsImg,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ShimmerWidget.rectangular(height: 80),
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
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: Image.asset(noPicture),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: locationsId != "",
                    child: Text(
                      "อาคาร ${locationsId.toString()}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kSecondColor,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: locationsName != "",
                    child: Text(
                      locationsName,
                      style: const TextStyle(
                        color: kPrimaryColor,
                        fontSize: 15,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LocationsDetailScreen(
              locationsID: documentID,
            ),
          ),
        );
      },
    ),
  );
}
