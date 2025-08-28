import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRedButtonTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final double borderRadius;
  final bool readOnly;

  const CustomRedButtonTextField({
    super.key,
    this.label = "",
    required this.hintText,
    required this.controller,
    this.onTap,
    this.prefixIcon,
    this.borderRadius = 12,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFFF1901), // Red background like the button
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            if (prefixIcon != null) ...[
              prefixIcon!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: TextFormField(
                controller: controller,
                readOnly: readOnly,
                onTap: onTap,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white, // White text like the image
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: label.isNotEmpty ? label : null,
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  hintText: hintText,
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
