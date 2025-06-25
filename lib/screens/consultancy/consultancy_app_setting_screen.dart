import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();
  double _fontSize = 16.0;

  @override
  void dispose() {
    _searchController.dispose();
    _imagePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildSectionHeader("Date Format"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomDropdownField(
                      borderRadius: 8,
                      borderColor: 0xff898FA3,
                      label: "Select Date Format *",
                      items: const [
                        'DD / MM / YYYY',
                        'MM / DD /YYYY',
                        'YYYY / MM / DD'
                      ],
                      value: 'DD / MM / YYYY',
                      onChanged: (value) {
                        setState(() {
                          // Update date format logic here
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildSectionHeader("Time Format"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomDropdownField(
                      borderRadius: 8,
                      borderColor: 0xff898FA3,
                      label: "Select Country *",
                      items: const [
                        'Singapore',
                        'United States',
                        'India',
                        'United Kingdom',
                        'Canada',
                        'Australia',
                      ],
                      value: 'Singapore',
                      onChanged: (String? value) {},
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomDropdownField(
                      borderRadius: 8,
                      borderColor: 0xff898FA3,
                      label: "Select Time Format *",
                      items: const ['HH : MM : SS', 'HH : MM', 'SS : MM : HH'],
                      value: 'HH : MM : SS',
                      onChanged: (value) {
                        setState(() {
                          // Update time format logic here
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomDropdownField(
                      borderRadius: 8,
                      borderColor: 0xff898FA3,
                      label: "Select Hour Format *",
                      items: const ['12 Hours', '24 Hours'],
                      value: '12 Hours',
                      onChanged: (value) {
                        setState(() {
                          // Update time format (12/24) logic here
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),
                  _buildSectionHeader("Login Background Image"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        // Implement image picker logic here
                      },
                      child: Container(
                        height: 45,
                        width: 700,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFEDEDED)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/upload.svg',
                              height: 20,
                              width: 20,
                              fit: BoxFit.contain,
                              color: const Color(0xffFF1901),
                            ),
                            const SizedBox(width: 15),
                            Text(
                              'Choose Login Background Image *',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff828282),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '*Allow to upload file PNG,JPG (Max.file size: 1MB)',
                      style: GoogleFonts.montserrat(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff798AA3),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 390,
                    height: 90,
                    margin: EdgeInsets.only(left: 9),
                    child: CustomTextField(
                      controller: _imagePathController,
                      hintText: '',
                      label: 'Consultancy Logo*',
                      borderRadius: 12,
                      useUnderlineBorder: false,
                      // This is key
                    ),
                  ),
                  const SizedBox(height: 2),
                  const SizedBox(height: 20),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                text: 'Submit',
                onPressed: () {
                  // Add your submit logic here, include _imagePathController.text for image path
                },
                isOutlined: true,
                borderColor: const Color(0xffFF1901),
                borderRadius: 8,
                height: 50,
                svgAsset: 'assets/icons/submitt.svg',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffFF1901),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                text: 'Cancel',
                onPressed: () {
                  // Add your cancel logic here
                },
                isOutlined: true,
                borderColor: const Color(0xffFF1901),
                borderRadius: 8,
                height: 50,
                svgAsset: 'assets/icons/cancel.svg',
                textStyle: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xffFF1901),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFFF1901),
        ),
      ),
    );
  }
}
