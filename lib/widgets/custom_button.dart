import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Color color;
  final double borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final Color borderColor;
  final bool isOutlined; // New flag for choosing button type
  final String? svgAsset;
  final bool loading;
  final double leftPadding;
  final bool container;
  final bool containerIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 40,
    this.width = double.infinity,
    this.color = const Color(0xffFF1901),
    this.borderRadius = 5,
    this.textStyle,
    this.icon,
    this.borderColor = const Color(0xffFF1901),
    this.isOutlined = false, // Default to ElevatedButton
    this.svgAsset,
    this.loading = false,
    this.leftPadding = 5.0,
    this.container = false,
    this.containerIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: isOutlined ? _buildOutlinedButton() : _buildElevatedButton(),
    );
  }

  Widget _buildElevatedButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.only(left: leftPadding),
      ),
      onPressed: loading ? null : onPressed,
      child: loading
          ? const CustomLoader(
              color: Colors.white,
              size: 20,
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (svgAsset != null) ...[
                  SvgPicture.asset(
                    svgAsset!,
                    height: 15,
                    width: 15,
                  ),
                ],
                if (container)
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: containerIcon
                        ? Icon(
                            Icons.check,
                            size: 15,
                            color: Colors.red,
                          )
                        : null,
                  ),
                const SizedBox(width: 5),
                Text(
                  text,
                  style: textStyle ??
                      GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                ),
              ],
            ),
    );
  }

  Widget _buildOutlinedButton() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.only(left: 2), // Removes default padding
      ),
      onPressed: loading ? null : onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (svgAsset != null) ...[
            SvgPicture.asset(
              svgAsset!,
              height: 25,
              width: 25,
            ),
            const SizedBox(width: 5), // Space between icon and text
          ],
          loading
              ? const CustomLoader(
                  color: Colors.white,
                  size: 20,
                )
              : Text(
                  text,
                  style: textStyle ??
                      GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: borderColor,
                      ),
                ),
          if (icon != null) ...[
            const SizedBox(width: 5),
            Icon(
              icon,
              color: borderColor,
              size: 18,
            ),
          ]
        ],
      ),
    );
  }
}
