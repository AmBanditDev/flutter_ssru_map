import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/widgets/shimmer_widget.dart';

Widget buildlocationsShimmer() {
  return ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ShimmerWidget.circular(
              width: 120,
              height: 80,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ShimmerWidget.rectangular(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const ShimmerWidget.rectangular(height: 14),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
