import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoader extends StatelessWidget {
  final Color color;
  final double size;

  const CustomLoader({
    super.key,
    this.color = Colors.white,
    this.size = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.hexagonDots(
      color: color,
      size: size,
    );
  }
}
