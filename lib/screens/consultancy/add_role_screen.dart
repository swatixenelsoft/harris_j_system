import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class CustomAddRoleDialog extends StatefulWidget {
  final Function(Map<String, dynamic>)?
      onSubmit; // Optional callback for submitting data

  const CustomAddRoleDialog({super.key, this.onSubmit});

  @override
  _CustomAddRoleDialogState createState() => _CustomAddRoleDialogState();
}

class _CustomAddRoleDialogState extends State<CustomAddRoleDialog> {
  String? selectedTag;
  final TextEditingController _addController = TextEditingController();
  bool roleStatus = true; // Added status toggle like AddHolidayForm

  @override
  void dispose() {
    _addController.dispose();
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
        width: screenWidth, // Full width to span screen
        decoration: BoxDecoration(
          color: Colors.grey[100], // Subtle background like AddHolidayForm
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                    'Add Role',
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
                    label: 'Role Name*',
                    hintText: 'Enter role name',
                    controller: _addController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a role name';
                      }
                      return null;
                    },
                    borderRadius: 10,
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
                    borderColor: 0xffE8E6EA,
                  ),
                  SizedBox(height: screenHeight * 0.01),

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
                            if (_addController.text.isNotEmpty) {
                              final result = {
                                'designation': _addController.text,
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
