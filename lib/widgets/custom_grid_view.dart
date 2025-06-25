// widgets/custom_grid_view.dart
import 'package:flutter/material.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';

class CustomGridView extends StatelessWidget {
  final List<String> titles;
  final List<String> images;
  final List<Color> bgColors;
  final List<Color> textColors;
  final List<VoidCallback?> onTapList;
  final List<bool> whiteFlags;
  final List<bool> lightRedFlags;
  final List<bool> orangeFlags;

  const CustomGridView({
    super.key,
    required this.titles,
    required this.images,
    required this.bgColors,
    required this.textColors,
    required this.onTapList,
    required this.whiteFlags,
    required this.lightRedFlags,
    required this.orangeFlags,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: titles.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        Widget card = GestureDetector(
          onTap: onTapList[index],
          child: BottomCard(
            title: titles[index],
            image: images[index],
            bgColor: bgColors[index],
            textColor: textColors[index],
            white: whiteFlags[index],
            lightRed: lightRedFlags[index],
            orange: orangeFlags[index],
            index: index,
          ),
        );

        if (index == 1) {
          return Container(
            margin: const EdgeInsets.only(top: 20),
            child: card,
          );
        }

        return card;
      },
    );
  }
}
