import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';

class BomStaticSettingsScreen extends StatefulWidget {
  const BomStaticSettingsScreen({super.key});

  @override
  State<BomStaticSettingsScreen> createState() =>
      _BomStaticSettingsScreenState();
}

class _BomStaticSettingsScreenState extends State<BomStaticSettingsScreen> {
  String _loginBackgroundImage = '';
  String _consultancyLogo = '';
  final _picker = ImagePicker();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _pickLoginBackgroundImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _loginBackgroundImage = pickedFile.name;
      });
    }
  }

  Future<void> _pickConsultancyLogo() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _consultancyLogo = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/images/bom/bom_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderContent(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CustomTextField(
                      label: "Search",
                      hintText: "Search ",
                      controller: _searchController,
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            height: 12,
                            width: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                      color: Color.fromRGBO(141, 145, 160, 0.4), thickness: 1),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/app_setting.svg',
                          height: 18,
                          width: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "App Setting",
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFF1901),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader("System Fonts Settings"),
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
                      label: "Select Font Style *",
                      items: const [
                        'Montserrat',
                        'Arial',
                        'Roboto',
                        'Open Sans'
                      ],
                      value: 'Montserrat',

                      onChanged: (value) {},
                      // errorText:
                      // _isSubmitted && _selectedAddressType == "Not Selected"
                      //     ? "Address Type is required"
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Font Size :',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF8D93A3),
                          ),
                        ),
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF898FA3)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    // decrease font size
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff898FA3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 12,
                                        color: Colors.white,
                                      ))),
                              const SizedBox(width: 12),
                              const Text(
                                '16',
                                style: TextStyle(fontSize: 14),
                              ),
                              const SizedBox(width: 12),
                              GestureDetector(
                                  onTap: () {
                                    // decrease font size
                                  },
                                  child: Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff898FA3),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Icon(
                                        Icons.add,
                                        size: 12,
                                        color: Colors.white,
                                      ))),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: CustomDropdownField(
                            borderRadius: 8,
                            borderColor: 0xff898FA3,
                            label: "font weight :",
                            items: const ['Regular', 'Medium', 'Bold'],
                            value: 'Regular',

                            onChanged: (value) {},
                            // errorText:
                            // _isSubmitted && _selectedAddressType == "Not Selected"
                            //     ? "Address Type is required"
                            //     : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSectionHeader("Data Format"),
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
                        'MM / DD / YYYY',
                        'YYYY / MM / DD'
                      ],
                      value: 'DD / MM / YYYY',

                      onChanged: (value) {},
                      // errorText:
                      // _isSubmitted && _selectedAddressType == "Not Selected"
                      //     ? "Address Type is required"
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 15),
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
                      label: "Select Time Format *",
                      items: const ['HH : MM : SS', 'HH : MM', 'SS : MM : HH'],
                      value: 'HH : MM : SS',
                      onChanged: (value) {},
                      // errorText:
                      // _isSubmitted && _selectedAddressType == "Not Selected"
                      //     ? "Address Type is required"
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomDropdownField(
                      borderRadius: 8,
                      borderColor: 0xff898FA3,
                      label: "Select Time Format *",
                      items: const ['12 Hours', '24 Hours'],
                      value: '12 Hours',

                      onChanged: (value) {},
                      // errorText:
                      // _isSubmitted && _selectedAddressType == "Not Selected"
                      //     ? "Address Type is required"
                      //     : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSectionHeader("CTA Button"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Button Active Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#FF1901',
                      const Color(0xFFFF1901),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Button Inactive Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#A8B9CA',
                      const Color(0xFFA8B9CA),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Button Active Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#FFFFFFFF',
                      const Color(0xFFFFFFFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Button Inactive Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#000000',
                      const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSectionHeader("Application Theme"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Primary Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#FF1901',
                      const Color(0xFF898FA3),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      'Secondary Color :',
                      style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: _colorPreview(
                      'hex',
                      '#A8B9CA',
                      const Color(0xFFA8B9CA),
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildSectionHeader("Login Background Image"),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Divider(color: Color(0xffFF1901)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: GestureDetector(
                      child: Container(
                        height: 45,
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
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      '*Allow to upload file PNG,JPG  (Max.file size: 1MB)',
                      style: GoogleFonts.montserrat(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff798AA3)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // if (isLoading)
          //   Positioned.fill(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          //       child: Container(
          //         color: Colors.black.withOpacity(0.2),
          //         alignment: Alignment.center,
          //         child: const CustomLoader(
          //           color: Color(0xffFF1901),
          //           size: 35,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none, // 👈 removes bottom border
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                const SizedBox(width: 3),
                Text(
                  'Settings',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                CustomButton(
                  text: 'Edit/Update',
                  width: 100,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
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

  Widget _colorPreview(label, code, color) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xff898FA3)),
      ),
      child: Row(
        children: [
          // Label (e.g. HEX)
          Container(
            color: const Color.fromRGBO(168, 185, 202, 0.21),
            width: 100,
            child: CustomDropdownField(
              borderRadius: 6,
              borderColor: 0xffFFFFFF,
              label: "",
              items: const ['HEX', 'RGB', 'HSL'],
              value: 'HEX',

              onChanged: (value) {},
              // errorText:
              // _isSubmitted && _selectedAddressType == "Not Selected"
              //     ? "Address Type is required"
              //     : null,
            ),
          ),
          // HEX code text
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                code,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
            ),
          ),

          // Color preview box
          Container(
            width: 92,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
