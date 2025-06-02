import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class AddLookupPopup extends StatelessWidget {
  final TextEditingController propertyNameCtrl = TextEditingController();
  final TextEditingController propertyDescCtrl = TextEditingController();
  final TextEditingController hexCtrl = TextEditingController();
  final TextEditingController optionValueCtrl = TextEditingController();
  final TextEditingController optionNameCtrl = TextEditingController();

  AddLookupPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      insetPadding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
      backgroundColor: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: screenHeight * 0.75),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF1901),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'System Properties / Add Lookup',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(), // Optional: close dialog
                      child: SvgPicture.asset(
                        'assets/icons/closee.svg',
                        width: 30,
                        height: 30,
                         // Optional: apply white color to SVG
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Lookup Header"),
                      const SizedBox(height: 10),

                      CustomTextField(
                        label: "Property Name *",
                        hintText: "Claim Type",
                        controller: propertyNameCtrl,
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        label: "Property Description *",
                        hintText: "Claim Category",
                        controller: propertyDescCtrl,
                      ),
                      const SizedBox(height: 10),

                      // HEX + Pick Color Box styled same as others
                      const Text(
                        "Color Code",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 250,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color.fromRGBO(168, 185, 202, 1), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  controller: hexCtrl,
                                  decoration: const InputDecoration(
                                    hintText: "Hex : (#ffffff)",
                                    border: InputBorder.none,
                                  ),
                                  style: const TextStyle(fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: const Color.fromRGBO(168, 185, 202, 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: TextButton(
                                onPressed: () {
                                  // Color picker
                                },
                                child: const Text(
                                  "Pick Color Code",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          const Text(
                            "Status :",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              color: Colors.black, // Green
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Active",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              color: Colors.black // Green
                            ),
                          ),
                          const SizedBox(width: 6),
                          Switch(
                            value: true,
                            onChanged: (bool value) {
                              // handle toggle here if needed
                            },
                            activeColor: Colors.white, // thumb (white ball)
                            activeTrackColor: Color(0xFF008000), // green background/track
                          ),
                        ],
                      ),


                      const SizedBox(height: 20),
                      sectionTitle("Lookup Options"),
                      const SizedBox(height: 10),

                      CustomTextField(
                        label: "Property Name *",
                        hintText: "Claim Type",
                        controller: propertyNameCtrl,
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        label: "Option Value",
                        hintText: "",
                        controller: optionValueCtrl,

                      ),
                      const SizedBox(height: 10),

                      CustomTextField(
                        label: "Option Name *",
                        hintText: "Sequence Number",
                        controller: optionNameCtrl,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Sequence Number *",
                        hintText: "Sequence Number",
                        controller: optionNameCtrl,
                      ),
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

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFFF1901),
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        const Divider(color: Color(0xFFFF1901), thickness: 1),
      ],
    );
  }
}
