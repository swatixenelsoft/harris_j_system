import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class CreateHolidayProfileForm extends StatefulWidget {
  const CreateHolidayProfileForm({super.key});

  @override
  State<CreateHolidayProfileForm> createState() =>
      _CreateHolidayProfileFormState();
}

class _CreateHolidayProfileFormState extends State<CreateHolidayProfileForm> {
  final _profileNameController = TextEditingController();
  final _holidayNameController = TextEditingController();
  final _holidayDateController = TextEditingController();
  bool profileStatus = true;
  bool holidayStatus = true;

  @override
  void dispose() {
    _profileNameController.dispose();
    _holidayNameController.dispose();
    _holidayDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _holidayDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // ensure enough height in dialog/popup
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFF1901),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create Holiday Profile',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/icons/closee.svg'),
                ),
              ],
            ),
          ),

          // Scrollable Form
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              thickness: 6,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        // Profile Name
                        CustomTextField(
                          label: "Holiday Profile Name * ",
                          hintText: "Enter profile Five",
                          controller: _profileNameController,
                        ),

                        const SizedBox(height: 16),

                        // Created Date (Disabled)
                        TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: 'Created Date',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                  child:Image.asset(
                                    'assets/icons/calendar.png', // Make sure the path is correct
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xfffA8B9CA)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Profile Status
                        Row(
                          children: [
                            const Text('Status:'),
                            const SizedBox(width: 4),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: profileStatus,
                                onChanged: (val) =>
                                    setState(() => profileStatus = val),
                                activeTrackColor: const Color(0xff008000),
                                inactiveThumbColor: Colors.white,
                              ),
                            ),
                            Text(
                              profileStatus ? 'Active' : 'Inactive',
                              style: GoogleFonts.montserrat(
                                color: profileStatus ? Colors.black : Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Add Holiday Title
                        Text(
                          'Add Holiday',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFFF1901),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(color: Colors.red),
                        const SizedBox(height: 16),

                        // Holiday Name
                        CustomTextField(
                          label: "Holiday Name",
                          hintText: "New Year",
                          controller: _holidayNameController,
                        ),

                        const SizedBox(height: 16),

                        // Holiday Date Picker
                        CustomTextField(
                          label: "Holiday Date",
                          hintText: "Select date",
                          controller: _holidayDateController,
                          readOnly: true,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                child: Image.asset(
                                  'assets/icons/red_calendar.png', // Make sure the path is correct
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),

                        const SizedBox(height: 16),

                        // Holiday Status
                        Row(
                          children: [
                            const Text('Status:'),
                            const SizedBox(width: 5),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: holidayStatus,
                                onChanged: (val) =>
                                    setState(() => holidayStatus = val),
                                activeTrackColor: const Color(0xff008000),
                                inactiveThumbColor: Colors.white,
                              ),
                            ),
                            Text(
                              holidayStatus ? 'Active' : 'Inactive',
                              style: GoogleFonts.montserrat(
                                color: holidayStatus ? Colors.black : Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Buttons Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Clear
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFF1901),
                                  side: const BorderSide(color: Color(0xFFFF1901)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  _profileNameController.clear();
                                  _holidayNameController.clear();
                                  _holidayDateController.clear();
                                },
                                child: Text(
                                  'Clear',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: const Color(0xFFFF1901),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Save
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF1901),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Save & Add
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF1901),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: () {
                                  // TODO: Save and reset logic
                                },
                                child: Text(
                                  'Save & Add',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
