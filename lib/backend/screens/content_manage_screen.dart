// packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ssru_map/backend/cache_image_manager.dart';
import 'package:flutter_ssru_map/widgets/appbarGradient.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';
import 'package:provider/provider.dart';

// screens
import 'package:flutter_ssru_map/backend/screens/form_add_data/form_add_content.dart';
import 'package:flutter_ssru_map/backend/screens/form_edit_data/form_edit_content.dart';

// functions

// providers
import 'package:flutter_ssru_map/providers/content_provider.dart';

// utilities
import 'package:flutter_ssru_map/utils.dart';

// widgets
import 'package:flutter_ssru_map/widgets/snackbar.dart';

class ContentManageScreen extends StatefulWidget {
  const ContentManageScreen({super.key});

  @override
  State<ContentManageScreen> createState() => _ContentManageScreenState();
}

class _ContentManageScreenState extends State<ContentManageScreen> {
  @override
  Widget build(BuildContext context) {
    final contentProvider = Provider.of<ContentProvider>(context)
        .contents
        .orderBy('create_at', descending: false);
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: appbarGradientColor(),
        title: const Text("รายการเนื้อหามหาวิทยาลัยฯ"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.add, size: 36),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FormAddContentScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: contentProvider.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("เกิดข้อผิดพลาดบางอย่าง: ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            // Get the data
            final contents = snapshot.data.docs;
            if (contents.length <= 0) {
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
                itemCount: contents.length,
                itemBuilder: (context, index) {
                  // Get the item at this index
                  final content = contents[index].data();
                  final documentID = contents[index].id;
                  return ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: content.containsKey('content_img')
                          ?
                          // Image.network(
                          //     '${content['content_img']}',
                          //     fit: BoxFit.fitHeight,
                          //   )
                          CachedNetworkImage(
                              cacheManager:
                                  CacheNetworkImage.customCacheManager,
                              key: UniqueKey(),
                              imageUrl: content['content_img'],
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
                          : Image.asset(
                              noPicture,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      "${content['content_title']}",
                      style: const TextStyle(
                        color: kSecondColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: Colors.amber,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormEditContentScreen(
                                  contentID: documentID,
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
                    onTap: () {
                      _showContentDialog(
                        title: content['content_title'],
                        image: content['content_img'],
                        detail: content['content_detail'],
                        createAt: content['create_at'],
                        editAt: content['edit_at'],
                      );
                    },
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

  Future<void> _showContentDialog({
    required String title,
    required String detail,
    required String image,
    required String createAt,
    required String editAt,
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
                  height: MediaQuery.of(context).size.width * 0.5,
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
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "เพิ่มเมื่อ $createAt",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "แก้ไขเมื่อ $editAt",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kSecondColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  detail.replaceAll('\\n', '\n'),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
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
    final contentProvider =
        Provider.of<ContentProvider>(context, listen: false);
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
                contentProvider.deleteContent(documentID).then((value) {
                  showSnackBar(
                    context,
                    message: "ลบข้อมูลสำเร็จ",
                    isSuccessAlert: true,
                  );
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
