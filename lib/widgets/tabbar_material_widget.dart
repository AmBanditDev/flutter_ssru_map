import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_ssru_map/utils.dart';

class TabBarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabBarMaterialWidget({
    super.key,
    required this.index,
    required this.onChangedTab,
  });

  @override
  _TabBarMaterialWidgetState createState() => _TabBarMaterialWidgetState();
}

class _TabBarMaterialWidgetState extends State<TabBarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    const placeholder = Opacity(
      opacity: 0,
      child: IconButton(
        icon: Icon(Icons.no_cell),
        onPressed: null,
      ),
    );

    return SizedBox(
      height: 60,
      child: BottomAppBar(
        color: kPrimaryColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildTabItem(
              index: 0,
              icon: const Icon(
                IconlyBold.home,
                size: 30,
              ),
            ),
            buildTabItem(
              index: 1,
              icon: const Icon(
                Icons.location_city,
                size: 30,
              ),
            ),
            placeholder,
            buildTabItem(
              index: 2,
              icon: const Icon(
                IconlyLight.search,
                size: 30,
              ),
            ),
            buildTabItem(
              index: 3,
              icon: const Icon(
                IconlyBold.profile,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;

    return IconTheme(
      data: IconThemeData(
        color: isSelected ? kSecondColor : Colors.white,
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => widget.onChangedTab(index),
      ),
    );
  }
}
