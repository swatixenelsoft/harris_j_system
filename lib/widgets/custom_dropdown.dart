import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDropdownField extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? errorText;
  final int borderColor;
  final double borderRadius;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.errorText,
    this.borderColor = 0xffE8E6EA,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.montserrat(
          color: const Color.fromRGBO(0, 0, 0, 0.4), // Light black with opacity
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Color(borderColor)), // Light grey
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Color(borderColor)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Color(borderColor)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: Colors.red.shade900),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
        errorText: errorText,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded, // Custom dropdown icon
            color: Color(0xff8D91A0),
            size: 25,
          ),
          isExpanded: true,
          menuMaxHeight: 200, // Limits menu height
          dropdownColor: Colors.white, // Dropdown background color
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for dropdown
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: Colors.black, // Dropdown text color
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10), // Spacing between items
                child: Text(
                  item,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
