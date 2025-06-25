import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

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

  final Color redColor = const Color(0xffFF1901);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top App Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "Consultancy.",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w800,
                          color: redColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "LOGO",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: redColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.notifications, color: redColor),
                      const SizedBox(width: 12),
                      Icon(Icons.person, color: redColor),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Container Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back + Title
                      Row(
                        children: [
                          const Icon(Icons.arrow_back, size: 20),
                          const SizedBox(width: 8),
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
                              color: redColor,
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
                          color: redColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomDropdownField(
                        label: "Encore Films",
                        items: clientList,
                        value: selectedClient,
                        onChanged: (val) =>
                            setState(() => selectedClient = val),
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
                        onChanged: (val) =>
                            setState(() => selectedConsultant = val),
                      ),

                      const Spacer(),

                      // Bottom Buttons Row
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: redColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Delete Group",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: redColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.clear, size: 18),
                              label: Text(
                                "Clear",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: redColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.save, size: 18),
                              label: Text(
                                "Save",
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: redColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
