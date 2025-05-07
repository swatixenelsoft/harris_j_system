import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconContainer extends StatelessWidget {
  final Color bgColor;
  final String path;



  const CustomIconContainer({
    super.key,
    this.bgColor = const Color.fromRGBO(255, 150, 27, 0.3),
    required this.path
  });


@override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(path, height: 12, width: 12),
      ),
    );
  }
}
