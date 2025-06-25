import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';

class ClaimPopup extends StatelessWidget {
  const ClaimPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Claim",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context), // Close the bottom sheet
                child: const Icon(Icons.close, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/.png'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bruce Lee",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Employee Id : Emp14982",
                      style: GoogleFonts.montserrat(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Claim Form",
                    style: GoogleFonts.montserrat(fontSize: 12),
                  ),
                  Text(
                    "#CLF08982",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "Individual Claims ( 03 )",
            style: GoogleFonts.montserrat(
              color: Color(0xffFF1901),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Amount : \$ 800.38",
                style: GoogleFonts.montserrat(fontSize: 14),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Draft",
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1.5),
          _claimItem(
            date: "Saturday, 4th Aug, 2024",
            type: "Food",
            code: "PA082073NU678",
          ),
          const SizedBox(height: 16),
          _claimItem(
            date: "Saturday, 4th Aug, 2024",
            type: "Medical",
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomButton(
                svgAsset: 'assets/icons/good_to_go.svg',
                text: 'Good To Go',
                onPressed: () {},
                isOutlined: true,
                width: 100,
                height: 29,
              ),
              const SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/hold.svg',
                text: 'Hold',
                onPressed: () {},
                isOutlined: true,
                width: 65,
                height: 29,
              ),
              const SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/rework.svg',
                text: 'Rework',
                onPressed: () {},
                isOutlined: true,
                width: 85,
                height: 29,
              ),
              const SizedBox(width: 5),
            ],
          ),
          // Removed the extra SizedBox(height: 16) to reduce bottom gap
        ],
      ),
    );
  }

  Widget _claimItem(
      {required String date, required String type, String? code}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date & Time",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  date,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Expense Type",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
                Text(
                  type,
                  style: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (code != null) ...[
          const SizedBox(height: 8),
          Text(
            "Particulars",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            code,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              color: Colors.black87,
            ),
          ),
        ],
      ],
    );
  }
}
