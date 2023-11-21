import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/providers/content_provider.dart';
import 'package:flutter_ssru_map/utils.dart';
import 'package:flutter_ssru_map/widgets/buildShimmerLoading.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../backend/cache_image_manager.dart';

class ContentListWidget extends StatefulWidget {
  const ContentListWidget({super.key});

  @override
  State<ContentListWidget> createState() => _ContentListWidgetState();
}

class _ContentListWidgetState extends State<ContentListWidget> {
  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    final contentProvider = Provider.of<ContentProvider>(context)
        .contents
        .orderBy('create_at', descending: false);
    return StreamBuilder<QuerySnapshot>(
      stream: contentProvider.snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("เกิดข้อผิดพลาดในการเรียกข้อมูล"),
          );
        } else if (snapshot.hasData) {
          final contents = snapshot.data.docs;
          if (contents.length <= 0) {
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
              physics: const BouncingScrollPhysics(),
              itemCount: contents.length,
              itemBuilder: (context, index) {
                final content = contents[index].data();

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    elevation: 1,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      child: Row(
                        children: [
                          SizedBox(
                            width: widthScreen * 0.3,
                            height: widthScreen * 0.24,
                            child: content.containsKey('content_img')
                                ?

                                // Image.network(
                                //     content['content_img'],
                                //     fit: BoxFit.fitHeight,
                                //   )

                                CachedNetworkImage(
                                    cacheManager:
                                        CacheNetworkImage.customCacheManager,
                                    key: UniqueKey(),
                                    imageUrl: content['content_img'],
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
                                : Container(),
                          ),
                          // const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content['content_title'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: kSecondColor,
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 14),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "รายละเอียด",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      onTap: () => _showContentsDialog(
                        title: content['content_title'],
                        detail: content['content_detail'],
                        image: content['content_img'],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        } else {
          // return Center(child: myProgressIndigator);
          return buildlocationsShimmer();
        }
      },
    );
  }

  Future<void> _showContentsDialog({
    required String title,
    required String detail,
    required String image,
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
                Container(
                    width: double.infinity,
                    height: 200,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // child: Image.network(
                    //   image,
                    //   fit: BoxFit.fitHeight,
                    // ),
                    child: CachedNetworkImage(
                      cacheManager: CacheNetworkImage.customCacheManager,
                      key: UniqueKey(),
                      imageUrl: image,
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
                    )),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kSecondColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  detail.replaceAll('\\n', '\n'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
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
}
