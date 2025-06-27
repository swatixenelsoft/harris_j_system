import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';

class FinanceAddGroupScreen extends StatefulWidget {
  const FinanceAddGroupScreen({super.key});

  @override
  State<FinanceAddGroupScreen> createState() => _FinanceAddGroupScreenState();
}

class _FinanceAddGroupScreenState extends State<FinanceAddGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  final List<String> clientList = ['Encore Films', 'Star Studios', 'XYZ Corp'];
  final List<String> consultantList = ['John Doe', 'Jane Smith', 'Alice Patel'];

  String? selectedClient;
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
          Navigator.pushReplacementNamed(context,'/login');
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
                      context.pop();
                    },
                    child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                  ),
                  const SizedBox(width: 90),
                  Text(
                    'Add Group',
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
              CustomDropdownField(
                label: "Encore Films",
                items: clientList,
                value: selectedClient,
                onChanged: (val) => setState(() => selectedClient = val),
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

              // Consultant Dropdown
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
                        side: BorderSide(color: Color(0xffFF1901)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: Text(
                        "Delete Group",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Color(0xffFF1901),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SvgPicture.asset(
                      'assets/icons/clearr.svg',
                      width: 36.0,
                      height: 36.0,
                    ),
                  ),
                  Expanded(
                    child: SvgPicture.asset(
                      'assets/icons/savee.svg',
                      width: 36.0,
                      height: 36.0,
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