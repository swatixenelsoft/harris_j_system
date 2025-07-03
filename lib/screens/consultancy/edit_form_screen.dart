import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class EditHolidayForm extends ConsumerStatefulWidget {
  final Map<String, dynamic> holidayData;
  final Function(Map<String, dynamic>) onSubmit;
  final String token;
  final String id;

  const EditHolidayForm({
    super.key,
    required this.holidayData,
    required this.onSubmit,
    required this.token,
    required this.id,
  });

  @override
  ConsumerState<EditHolidayForm> createState() => _EditHolidayFormState();
}

class _EditHolidayFormState extends ConsumerState<EditHolidayForm> {
  final _holidayNameController = TextEditingController();
  final _holidayDateController = TextEditingController();
  DateTimeRange? selectedRange;
  bool holidayStatus = true;
  int daysCount = 0;

  @override
  void initState() {
    super.initState();

    final data = widget.holidayData;
    _holidayNameController.text = data['name'] ?? '';
    holidayStatus = (data['status'] == 'Active' || data['status'] == 1);

    if (data['startDate'] != null && data['endDate'] != null) {
      try {
        DateTime start = DateTime.parse(data['startDate'].toString());
        DateTime end = DateTime.parse(data['endDate'].toString());
        selectedRange = DateTimeRange(start: start, end: end);
        daysCount = end.difference(start).inDays + 1;
        _holidayDateController.text =
        "${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')} to "
            "${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}";
      } catch (e) {
        debugPrint('Invalid date format in holidayData');
      }
    }
  }

  @override
  void dispose() {
    _holidayNameController.dispose();
    _holidayDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: selectedRange ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
    );
    if (picked != null) {
      setState(() {
        selectedRange = picked;
        daysCount = picked.end.difference(picked.start).inDays + 1;
        _holidayDateController.text =
        "${picked.start.year}-${picked.start.month.toString().padLeft(2, '0')}-${picked.start.day.toString().padLeft(2, '0')} to "
            "${picked.end.year}-${picked.end.month.toString().padLeft(2, '0')}-${picked.end.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitHoliday() async {
    final holidayName = _holidayNameController.text.trim();
    final holidayDateRange = _holidayDateController.text.trim();
    final holidayStatusValue = holidayStatus ? 1 : 0;

    if (holidayName.isEmpty || selectedRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final response = await ref.read(staticSettingProvider.notifier).editHoliday(
        id: widget.holidayData['id'].toString(),
        holidayProfileName: holidayName,
        holidayProfileDate: holidayDateRange,
        daysCount: daysCount,
        validUpto: selectedRange!.end.year.toString(),
        holidayProfileStatus: holidayStatusValue,
        token: widget.token,
      );

      if (response['success'] == true) {
        widget.onSubmit({
          'name': holidayName,
          'status': holidayStatus ? 'Active' : 'Inactive',
          'startDate': selectedRange!.start,
          'endDate': selectedRange!.end,
          'daysCount': daysCount,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Holiday "$holidayName" updated successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to update holiday')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final padding = w * 0.02;
    final fontSize = w * 0.035;

    return Container(
      width: w,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w,
            padding: EdgeInsets.symmetric(horizontal: padding * 2, vertical: padding * 2),
            decoration: const BoxDecoration(
              color: Color(0xFFFF1901),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Holiday',
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
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding * 2),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Holiday Name',
                  hintText: 'Enter holiday name',
                  controller: _holidayNameController,
                  borderRadius: 10,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: 'Holiday Date',
                  hintText: 'Select date range',
                  controller: _holidayDateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      'assets/icons/red_calendar.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  borderRadius: 10,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Status:', style: GoogleFonts.montserrat(fontSize: fontSize * 0.9)),
                    const SizedBox(width: 8),
                    Switch(
                      value: holidayStatus,
                      onChanged: (val) => setState(() => holidayStatus = val),
                      activeTrackColor: const Color(0xff008000),
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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFFF1901),
                          side: const BorderSide(color: Color(0xFFFF1901)),
                          padding: EdgeInsets.symmetric(vertical: h * 0.01),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.spaceGrotesk(fontSize: fontSize * 0.9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitHoliday,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1901),
                          padding: EdgeInsets.symmetric(vertical: h * 0.01),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          'Save & Add',
                          style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: fontSize * 0.9, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
