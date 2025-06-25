import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class CustomAddDesignationDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)? onSubmit;

  const CustomAddDesignationDialog({super.key, this.onSubmit});

  @override
  _CustomAddDesignationDialogState createState() =>
      _CustomAddDesignationDialogState();
}

class _CustomAddDesignationDialogState
    extends State<CustomAddDesignationDialog> {
  String? selectedTag;
  final TextEditingController _designationController = TextEditingController();
  bool designationStatus = true; // Added status toggle like CustomAddRoleDialog

  @override
  void dispose() {
    _designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.03;
    final double fontSize = screenWidth * 0.035;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
      child: Container(
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white, // Updated to #A8B9CA
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: screenWidth,
              padding: EdgeInsets.symmetric(
                  horizontal: padding * 2, vertical: padding * 2),
              decoration: const BoxDecoration(
                color: Color(0xFFFF1901),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Designation',
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: fontSize * 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset(
                      'assets/icons/closee.svg',
                      width: 25,
                      height: 25,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            // Content
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: padding * 2, vertical: padding),
              child: Column(
                children: [
                  // Custom Designation Name TextField
                  CustomTextField(
                    label: 'Designation Name*',
                    hintText: 'Enter designation name',
                    controller: _designationController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a designation name';
                      }
                      return null;
                    },

                    // Updated to #A8B9CA
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Custom Add Tag Dropdown
                  CustomDropdownField(
                    label: 'Add Tag',
                    items: ['Tag 1', 'Tag 2', 'Tag 3'],
                    value: selectedTag,
                    onChanged: (value) {
                      setState(() {
                        selectedTag = value;
                      });
                    },
                    borderRadius: 10,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Status Switch

                  SizedBox(height: screenHeight * 0.13),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Cancel Button
                      SizedBox(
                        width: screenWidth * 0.30, // Reduced width
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF1901),
                            side: const BorderSide(color: Color(0xFFFF1901)),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenHeight * 0.005,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: fontSize * 0.9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: padding),
                      // Save Button
                      SizedBox(
                        width: screenWidth * 0.30, // Reduced width
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF1901),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenHeight * 0.005,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_designationController.text.isNotEmpty) {
                              final result = {
                                'designation': _designationController.text,
                                'tag': selectedTag ?? 'No Tag',
                              };
                              if (widget.onSubmit != null) {
                                widget.onSubmit!(result);
                              }
                              Navigator.pop(context, result);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please fill in the designation name'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Save',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: fontSize * 0.9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
