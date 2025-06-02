import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRadioTileWidget extends StatelessWidget {
  String title;
  String selectedValue;
  Function(String) onChanged;
  CustomRadioTileWidget(
      {super.key,
      required this.title,
      required this.selectedValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      value: title,
      groupValue: selectedValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      title: Row(
        mainAxisSize: MainAxisSize.min, // Minimize space usage
        children: [
          SvgPicture.asset(
            title == "Custom"
                ? 'assets/icons/custom_leave_icon.svg'
                : 'assets/icons/leave_icon.svg',
            height: 16, // Reduced icon height
            width: 16, // Reduced icon width
          ),
          const SizedBox(width: 10), // Decreased spacing
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xff2C2C2E),
            ),
          ),
        ],
      ),
      activeColor: const Color(0xff00C2A8),
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity:
          const VisualDensity(horizontal: -4, vertical: -4), // Reduce spacing
      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap, // Shrink tap area
    );
  }
}
