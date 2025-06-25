import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

// import 'package:lucide_icons/lucide_icons.dart';
final TextEditingController _searchController = TextEditingController();

class FinanceChartCard extends StatelessWidget {
  const FinanceChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title and "View All" Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Finances',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomButton(
                  isOutlined: true,
                  height: 34,
                  width: 91,
                  text: "View All",
                  icon: Icons.remove_red_eye_outlined,
                  onPressed: () {}),
            ],
          ),
          const SizedBox(height: 16),

          /// Search and Dropdown
          Row(
            children: [
              Expanded(
                  child: CustomTextField(
                label: "Search",
                hintText: "Search...",
                controller: _searchController,
              )),
              const SizedBox(width: 12),
              Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE8E6EA)),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: 'Monthly',
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded, // Custom dropdown icon
                      color: Color(0xff8D91A0),
                      size: 25,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Monthly',
                        child: Text(
                          'Monthly',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8D91A0),
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Weekly',
                        child: Text(
                          'Weekly',
                          style: GoogleFonts.montserrat(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8D91A0),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          /// Chart Placeholder (replace with actual chart)
          AspectRatio(
            aspectRatio: 1.6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Chart Placeholder',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
