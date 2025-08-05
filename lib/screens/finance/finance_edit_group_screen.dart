import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';

class FinanceEditGroupScreen extends StatefulWidget {
  const FinanceEditGroupScreen({super.key, required groupName, required Map<String, dynamic> groupData});

  @override
  State<FinanceEditGroupScreen> createState() => _FinanceEditGroupScreenState();
}

class _FinanceEditGroupScreenState extends State<FinanceEditGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();

  final List<Map<String, dynamic>> clientList = [
    {
      'id': 1,
      'serving_client': 'Encore Films',
      'initials': 'EF',
      'inactive': 2,
      'active': 5,
      'notice': 1,
      'all': 8,
    },
    {
      'id': 2,
      'serving_client': 'Star Studios',
      'initials': 'SS',
      'inactive': 3,
      'active': 4,
      'notice': 0,
      'all': 7,
    },
    {
      'id': 3,
      'serving_client': 'XYZ Corp',
      'initials': 'XC',
      'inactive': 1,
      'active': 6,
      'notice': 2,
      'all': 9,
    },
  ];

  // Remaining unchanged
  final List<String> consultantList = ['John Doe', 'Jane Smith', 'Alice Patel'];

  String? selectedClientName;
  String? selectedClientId;
  String? selectedConsultant;

  final Color brandRed = const Color(0xFFFF1901);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
        onProfilePressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(color: Color(0xffE8E8E8)),
            left: BorderSide(color: Color(0xffE8E8E8)),
            right: BorderSide(color: Color(0xffE8E8E8)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Row
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                  ),
                  const SizedBox(width: 90),
                  Text(
                    'Edit Group',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Heading Divider
              Row(
                children: [
                  Text(
                    "New / modify Group Billing",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xffFF1901),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.black26,
                      indent: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Client Dropdown
              Text(
                "Client Name",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xffFF1901),
                ),
              ),
              const SizedBox(height: 6),
              // --- Use the new CustomClientDropdown ---
              CustomClientDropdown(
                clients: clientList,
                initialClientName: selectedClientName,
                onChanged: (String name, String? id) {
                  setState(() {
                    selectedClientName = name;
                    selectedClientId = id;
                  });
                },
              ),
              const SizedBox(height: 20),
              // Group Name Text Field
              CustomTextField(
                hintText: "Group Name*",
                controller: groupNameController,
                useUnderlineBorder: false,
                padding: 0,
                borderRadius: 12,
              ),
              const SizedBox(height: 20),

              // Consultant Dropdown (unchanged)
              CustomDropdownField(
                label: "Select Consultants",
                items: consultantList,
                value: selectedConsultant,
                onChanged: (val) => setState(() => selectedConsultant = val),
              ),
              const Spacer(), // Replaces large SizedBox for flexible spacing
              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xffFF1901)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        // Delete logic here
                      },
                      child: Text(
                        "Delete Group",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xffFF1901),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: SvgPicture.asset(
                      'assets/icons/edit_button_finance.svg',
                      width: 36.0,
                      height: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
