import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddLookupPopup extends ConsumerStatefulWidget {

  const AddLookupPopup({super.key});

  @override
  ConsumerState<AddLookupPopup> createState() => _AddLookupPopupState();
}

class _AddLookupPopupState extends ConsumerState<AddLookupPopup> {
  final TextEditingController propertyNameCtrl = TextEditingController();
  final TextEditingController propertyDescCtrl = TextEditingController();
  final TextEditingController propertyHexCode = TextEditingController(text: "#000000");
  final TextEditingController optionHexCode = TextEditingController(text: "#000000");
  final TextEditingController optionValueCtrl = TextEditingController();
  final TextEditingController optionNameCtrl = TextEditingController();
  final TextEditingController optionSequenceCtrl = TextEditingController();
  final TextEditingController optionDescriptionCtrl = TextEditingController();

  Color propertySelectedColor = const Color(0x00000000); // Default white
  Color optionSelectedColor = const Color(0x00000000); // Default white
  bool propertyStatus=false;
  bool optionStatus=false;
  bool optionVisibility=false;

  void _showPropertyColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: propertySelectedColor,
              onColorChanged: (color) {
                final fullColor = color.withOpacity(1.0); // Force full opacity

                print('Selected color: $fullColor');

                setState(() {
                  propertySelectedColor = fullColor;
                  propertyHexCode.text = '#${fullColor.value.toRadixString(16).substring(2).toUpperCase()}';
                });
              },

              enableAlpha: false,
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
  void _showOptionColorPicker() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: optionSelectedColor,
              onColorChanged: (color) {
                final fullColor = color.withOpacity(1.0); // Force full opacity

                print('Selected color: $fullColor');
                setState(() {
                  optionSelectedColor = fullColor;
                  optionHexCode.text = '#${fullColor.value.toRadixString(16).substring(2).toUpperCase()}';
                });
              },
              enableAlpha: false,
              showLabel: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final consultancyId = prefs.getInt('userId') ?? '';
    final token = prefs.getString('token') ?? '';
    FocusScope.of(context).unfocus();
    print('consultancyIdddd $consultancyId');

    // Validate form
    // if (!_formKey.currentState!.validate()) return;

    final propertyName = propertyNameCtrl.text.trim();
    final propertyDescription = propertyDescCtrl.text.trim();
    final status = propertyStatus; // this should be a boolean from your switch
    final hexColor = propertyHexCode.text; // without '#' e.g. FF0000
    final optionName= optionNameCtrl.text;
    final optionValue=optionValueCtrl.text;
    final optionSequenceNumber=optionSequenceCtrl.text;
    final optionDescription=optionDescriptionCtrl.text;
    final optionStatusValue = optionStatus; // this should be a boolean from your switch
    final optionHexColor = optionHexCode.text;
    final optionVisibilityValue =optionVisibility;

    final List<Map<String, dynamic>> lookupOptions = [
      {
        "option_name": optionName,
        "option_value": optionValue,
        "option_description": optionDescription,
        "sequence": optionSequenceNumber,
        "status": optionStatusValue?'1':'0',
        "visibility": optionVisibilityValue?'1':'0',
        "hex_color": optionHexColor
      }
    ];


    print('''
======== Lookup Form Submission ========
consultancyId       :$consultancyId
propertyName        : $propertyName
propertyDescription : $propertyDescription
status              : $status
hexColor            : $hexColor
options             : ${lookupOptions}
========================================
''');

    try {
      final response = await ref.read(staticSettingProvider.notifier).addLookup(
        consultancyId.toString(),
        propertyName,
        propertyDescription,
        status,
        hexColor,
        lookupOptions,
        token,
      );

      final bool success = response['success'] == true;

      if (!mounted) return;

      if (success) {
        context.pop(true);
        ToastHelper.showSuccess(
          context,
          response['message'] ?? 'Lookup created successfully!',
        );
      } else {
        ToastHelper.showError(context, response['message'] ?? 'Failed to save lookup');
      }
    } catch (e) {
      if (!mounted) return;
      ToastHelper.showError(context, 'Something went wrong: $e');
    }
  }



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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'System Properties / Add Lookup',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.of(context).pop(), // Optional: close dialog
                      child: SvgPicture.asset(
                        'assets/icons/closee.svg',
                        width: 20,
                        height: 20,
                        // Optional: apply white color to SVG
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sectionTitle("Lookup Header"),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Property Name *",
                        hintText: "Claim Type",
                        controller: propertyNameCtrl,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Property Description *",
                        hintText: "Claim Category",
                        controller: propertyDescCtrl,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 250,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffE8E6EA), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                    readOnly: true,
                                    controller: propertyHexCode,
                                    decoration: InputDecoration(
                                      hintText: "Hex : (#ffffff)",
                                      hintStyle: GoogleFonts.spaceGrotesk(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff798AA3)),
                                      border: InputBorder.none,
                                    ),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(int.parse(propertyHexCode.text.replaceFirst('#', '0xff'))),
                                    )
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: const Color(0xffE8E6EA),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: TextButton(
                                onPressed: () {
                                  _showPropertyColorPicker();
                                },
                                child: Text("Pick Color Code",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff798AA3))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            "Status :",
                            style: GoogleFonts.lato(
                              color: const Color(0xff1D212D),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            child: Transform.scale(
                              scale: 0.5,
                              child: Switch(
                                value: propertyStatus,
                                onChanged: (bool value) {
                                  setState(() {
                                    propertyStatus = value;
                                  });
                                },
                                activeColor: Colors.white, // thumb
                                activeTrackColor: const Color(0xFF008000),
                                inactiveTrackColor: const Color(0xffE8E6EA),
                              ),

                            ),
                          ),
                           Text(
                            "Active",
                            style: GoogleFonts.lato(
                                color: const Color(0xff1D212D),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      sectionTitle("Lookup Options"),
                      const SizedBox(height: 10),
                      CustomTextField(
                        label: "Property Name *",
                        hintText: "Claim Type",
                        controller: propertyNameCtrl,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.55,
                        child: CustomTextField(
                          label: "Option Value",
                          hintText: "",
                          controller: optionValueCtrl,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        label: "Option Name *",
                        hintText: "Option Name",
                        controller: optionNameCtrl,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.55,
                        child: CustomTextField(
                          label: "Sequence Number *",
                          hintText: "Sequence Number",
                          controller: optionSequenceCtrl,
                          borderRadius: 10,
                        ),
                      ),
                      const SizedBox(height: 25),
                      CustomTextField(
                        label: "Option Description *",
                        hintText: "Description",
                        controller: optionDescriptionCtrl,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 250,
                        height: 46,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xffE8E6EA), width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                                child: TextField(
                                  readOnly: true,
                                  controller: optionHexCode,
                                  decoration: InputDecoration(
                                    hintText: "Hex : (#ffffff)",
                                    hintStyle: GoogleFonts.spaceGrotesk(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff798AA3)),
                                    border: InputBorder.none,
                                  ),
                                  style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    color: Color(int.parse(optionHexCode.text.replaceFirst('#', '0xff'))),

                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: const Color(0xffE8E6EA),
                            ),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 12),
                              child: TextButton(
                                onPressed: () {
                                _showOptionColorPicker();
                                },
                                child: Text("Pick Color Code",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff798AA3))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(

                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              "Status :",
                              style: GoogleFonts.lato(
                                color: const Color(0xff1D212D),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 45,
                              child: Transform.scale(
                                scale: 0.5,
                                child: Switch(
                                  value: optionStatus,
                                  onChanged: (bool value) {
                                    setState(() {
                                      optionStatus = value;
                                    });
                                  },
                                  activeColor: Colors.white, // thumb (white ball)
                                  activeTrackColor: const Color(
                                      0xFF008000),
                                    inactiveTrackColor:const Color(0xffE8E6EA)
                                ),
                              ),
                            ),
                            Text(
                              "Active",
                              style: GoogleFonts.lato(
                                color: const Color(0xff1D212D),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Visibility :",
                              style: GoogleFonts.lato(
                                color: const Color(0xff1D212D),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(
                              width: 45,
                              child: Transform.scale(
                                scale: 0.5, // Change to 0.7, 1.2, etc. as needed
                                child: Switch(
                                  value: optionVisibility,
                                  onChanged: (bool value) {
                                setState(() {
                                  optionVisibility=value;
                                });
                                  },
                                  activeColor: Colors.white, // thumb
                                  activeTrackColor: const Color(0xFF008000), 
                                  inactiveTrackColor: const Color(0xffE8E6EA),                                ),
                              ),
                            ),

                            Text(
                              "Show",
                              style: GoogleFonts.lato(
                                color: const Color(0xff1D212D),
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(text: 'Cancel', onPressed: (){},width: 100,height: 32,borderRadius: 10,leftPadding: 0,),
                          CustomButton(text: 'Save', onPressed: (){},width: 80,height: 32,borderRadius: 10,leftPadding: 0,),
                          CustomButton(text: 'Save & Add', onPressed: (){
                            _submitForm();
                          },width: 110,height: 32,borderRadius: 10,leftPadding: 0,)
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

  Widget sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            color: const Color(0xFFFF1901),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
        const Divider(
          color: Color(0xFFFF1901),
          thickness: 1,
          height: 7,
        ),
      ],
    );
  }
}
