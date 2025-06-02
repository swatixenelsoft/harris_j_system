import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class AddHolidayForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const AddHolidayForm({super.key, required this.onSubmit});

  @override
  State<AddHolidayForm> createState() => _AddHolidayFormState();
}

class _AddHolidayFormState extends State<AddHolidayForm> {
  final _holidayNameController = TextEditingController();
  final _holidayDateController = TextEditingController();
  bool holidayStatus = true;

  @override
  void dispose() {
    _holidayNameController.dispose();
    _holidayDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(const Duration(days: 1)),
      ),
    );

    if (picked != null) {
      setState(() {
        _holidayDateController.text =
        "${picked.start.day.toString().padLeft(2, '0')}/${picked.start.month.toString().padLeft(2, '0')}/${picked.start.year} - ${picked.end.day.toString().padLeft(2, '0')}/${picked.end.month.toString().padLeft(2, '0')}/${picked.end.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double padding = screenWidth * 0.02;
    final double fontSize = screenWidth * 0.035;

    return Container(
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: screenWidth,
            padding: EdgeInsets.symmetric(horizontal: padding * 2, vertical: padding * 2),
            decoration: const BoxDecoration(
              color: Color(0xFFFF1901),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Holiday / Profile One',
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
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: padding * 2),
              child: Column(
                children: [
                  // Holiday Name Field
                  CustomTextField(
                    label: 'Holiday Name',
                    hintText: 'Enter holiday name',
                    controller: _holidayNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a holiday name';
                      }
                      return null;
                    },
                    borderRadius: 10,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Holiday Date Field
                  CustomTextField(
                    label: 'Holiday Date',
                    hintText: 'DD / MM / YYYY - DD / MM / YYYY',
                    controller: _holidayDateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        'assets/icons/red_calendar.png', // Make sure the path is correct
                        width: 24,
                        height: 24,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please select a date range';
                      }
                      return null;
                    },
                    borderRadius: 10,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Status Switch
                  Row(
                    children: [
                      Text(
                        'Status:',
                        style: GoogleFonts.montserrat(fontSize: fontSize * 0.9),
                      ),
                      SizedBox(width: padding),
                      Switch(
                        value: holidayStatus,
                        onChanged: (val) => setState(() => holidayStatus = val),
                        activeTrackColor: const Color(0xff008000),
                        inactiveThumbColor: Colors.white,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      Text(
                        holidayStatus ? 'Active' : 'Inactive',
                        style: GoogleFonts.montserrat(
                          fontSize: fontSize * 0.9,
                          fontWeight: FontWeight.w500,
                          color: holidayStatus ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.14),
                  // Buttons
                  Row(
                    children: [
                      // Cancel
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF1901),
                            side: const BorderSide(color: Color(0xFFFF1901)),
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
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
                      // Add Holiday
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF1901),
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_holidayNameController.text.isNotEmpty &&
                                _holidayDateController.text.isNotEmpty) {
                              widget.onSubmit({
                                'name': _holidayNameController.text,
                                'date': _holidayDateController.text,
                                'status': holidayStatus ? 'Active' : 'Inactive',
                              });
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields'),
                                ),
                              );
                            }
                          },
                          child: Text(
                            'Add Holiday',
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
          ),
        ],
      ),
    );
  }
}
