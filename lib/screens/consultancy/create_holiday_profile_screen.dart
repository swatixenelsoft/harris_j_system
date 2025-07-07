import 'dart:ui'; // For BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class CreateHolidayProfileForm extends ConsumerStatefulWidget {
  final Function(Map<String, dynamic>) onHolidayAdded;
  final String token;
  final String userId;

  const CreateHolidayProfileForm({
    super.key,
    required this.onHolidayAdded,
    required this.token,
    required this.userId,
  });

  @override
  ConsumerState<CreateHolidayProfileForm> createState() =>
      _CreateHolidayProfileFormState();
}

class _CreateHolidayProfileFormState extends ConsumerState<CreateHolidayProfileForm> {
  final _profileNameController = TextEditingController();
  final _holidayNameController = TextEditingController();
  final _holidayDateController = TextEditingController();
  final _createdDateController = TextEditingController();
  bool profileStatus = true;
  DateTimeRange? selectedRange;
  bool holidayStatus = true;
  int daysCount = 0;
  bool _isLoading = false; // Loading state to prevent multiple submissions

  @override
  void initState() {
    super.initState();
    _createdDateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _holidayNameController.dispose();
    _holidayDateController.dispose();
    _createdDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDateRangePicker(
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
        daysCount = picked.end.difference(picked.start).inDays + 1; // Inclusive of start & end
        _holidayDateController.text =
        "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')}"
            " to "
            "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveHoliday({required bool isSaveAndAdd}) async {
    if (_isLoading) return; // Prevent multiple submissions

    setState(() {
      _isLoading = true; // Set loading state
    });

    final holidayName = _holidayNameController.text.trim();
    final profileName = _profileNameController.text.trim();
    final createdDate = _createdDateController.text.trim();
    final holidayProfileStatus = profileStatus ? 1 : 0;
    final holidayDateRange = _holidayDateController.text.trim();
    final holidayStatusValue = holidayStatus ? 1 : 0;

    // Validate required fields
    if (holidayName.isEmpty || holidayDateRange.isEmpty || profileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (widget.token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token is missing')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }
    if (widget.userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Consultancy ID is missing')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      print('''
======== Holiday Form Submission ========
Holiday Name           : $holidayName
Profile Name           : $profileName
Created Date           : $createdDate
Day Count              : $daysCount
Profile Status         : $holidayProfileStatus
Holiday Date Range     : $holidayDateRange
Holiday Status Value   : $holidayStatusValue
========================================
''');

      final holiday = await ref.read(staticSettingProvider.notifier).createHoliday(
        consultancyId: widget.userId,
        holidayProfileName: profileName,
        holidayProfileDate: createdDate,
        daysCount: daysCount,
        validUpto: '2025',
        holidayProfileStatus: holidayProfileStatus,
        childHolidayName: holidayName,
        childHolidayDate: holidayDateRange,
        childHolidayDayCount: daysCount,
        childHolidayValidUpto: '2025',
        childHolidayStatus: holidayStatusValue,
        token: widget.token,
      );

      print('createHoliday response: $holiday');
      if (holiday['success'] == true) {
        // Notify parent widget
        widget.onHolidayAdded({
          'name': holiday['data']['holiday_name'],
          'status': holidayStatus ? 'Active' : 'Inactive',
          'isSaveAndAdd': isSaveAndAdd,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Holiday $holidayName created successfully')),
        );

        // Handle Save & Add or Save
        if (isSaveAndAdd) {
          // Small delay for smooth UX before resetting form
          await Future.delayed(const Duration(milliseconds: 0));
          setState(() {
            _profileNameController.clear();
            _holidayNameController.clear();
            _holidayDateController.clear();
            profileStatus = true;
            holidayStatus = true;
            daysCount = 0;
            _createdDateController.text = "${DateTime.now().toLocal()}".split(' ')[0];
          });
        } else {
          // Close the dialog for Save
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('createHoliday error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
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
                        CustomTextField(
                          label: "Holiday Profile Name *",
                          hintText: "Enter profile name",
                          controller: _profileNameController,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          enabled: false,
                          controller: _createdDateController,
                          decoration: InputDecoration(
                            labelText: 'Created Date',
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                  child: Image.asset(
                                    'assets/icons/calendar.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Color(0xffA8B9CA)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Status:'),
                            const SizedBox(width: 4),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: profileStatus,
                                onChanged: (val) => setState(() => profileStatus = val),
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
                        Text(
                          'Add Holiday',
                          style: GoogleFonts.montserrat(
                            color: const Color(0xFFFF1901),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(color: Colors.red),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: "Holiday Name",
                          hintText: "New Year",
                          controller: _holidayNameController,
                        ),
                        const SizedBox(height: 16),
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
                                  'assets/icons/red_calendar.png',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Text('Status:'),
                            const SizedBox(width: 5),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: holidayStatus,
                                onChanged: (val) => setState(() => holidayStatus = val),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFFF1901),
                                  side: const BorderSide(color: Color(0xFFFF1901)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _isLoading
                                    ? null // Disable button when loading
                                    : () {
                                  _profileNameController.clear();
                                  _holidayNameController.clear();
                                  _holidayDateController.clear();
                                  setState(() {
                                    profileStatus = true;
                                    holidayStatus = true;
                                    daysCount = 0;
                                    _createdDateController.text =
                                    "${DateTime.now().toLocal()}".split(' ')[0];
                                  });
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
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF1901),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _isLoading
                                    ? null // Disable button when loading
                                    : () => _saveHoliday(isSaveAndAdd: false),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
                                  'Save',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF1901),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                                onPressed: _isLoading
                                    ? null // Disable button when loading
                                    : () => _saveHoliday(isSaveAndAdd: true),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Text(
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