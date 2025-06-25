import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class ScheduleInvoiceDialog extends StatefulWidget {
  const ScheduleInvoiceDialog({super.key});

  @override
  State<ScheduleInvoiceDialog> createState() => _ScheduleInvoiceDialogState();
}

class _ScheduleInvoiceDialogState extends State<ScheduleInvoiceDialog> {
  final TextEditingController groupNameController = TextEditingController();
  final List<String> dropdownItems = ['Encore Films', 'Alpha Corp', 'Beta LLC'];
  String selectedClient = 'Encore Films';

  final List<String> frequencies = ['One time', 'Daily', 'Weekly', 'Monthly'];
  String selectedFrequency = 'One time';

  bool syncAcrossTimeZone = false;
  bool delayTask = false;
  bool enableTask = true;

  String selectedDelay = '1 hour';
  String selectedInvoiceRaised = 'Manually';
  String selectedStopAfter = '2 days';

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 600,
          minWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF1901),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Row(
                      children: [
                        Text(
                          'Schedule',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            'assets/icons/closee.svg',
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        sectionDivider("Schedule Invoice"),
                        sectionDivider("Client Name"),
                        CustomDropdownField(
                          label: 'Client',
                          items: dropdownItems,
                          value: selectedClient,
                          onChanged: (val) {
                            setState(
                                () => selectedClient = val ?? selectedClient);
                          },
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          label: 'Group Name (If any)',
                          hintText: 'Group Name (If any)',
                          controller: groupNameController,
                          readOnly: true,
                        ),
                        const SizedBox(height: 16),
                        sectionDivider("Settings"),
                        Wrap(
                          spacing: 30,
                          runSpacing: 8,
                          children: frequencies.map((freq) {
                            final isSelected = selectedFrequency == freq;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedFrequency = freq),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/circle_dot.svg',
                                    width: 16,
                                    height: 16,
                                    color: isSelected
                                        ? const Color(0xFFFF1901)
                                        : Colors.grey,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(freq,
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        dateTile(
                          "Start Date",
                          selectedDate != null
                              ? "${selectedDate!.day} ${_monthName(selectedDate!.month)}, ${selectedDate!.year}"
                              : "Monday, 5th Aug, 2024",
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate ?? DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => selectedDate = picked);
                            }
                          },
                        ),
                        dateTile(
                          "Time",
                          selectedTime != null
                              ? selectedTime!.format(context)
                              : "12:30 AM",
                          onTap: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() => selectedTime = picked);
                            }
                          },
                        ),
                        iconCheckboxTile(
                            "Synchronize across time zones",
                            syncAcrossTimeZone,
                            (val) => setState(() => syncAcrossTimeZone = val)),
                        const SizedBox(height: 12),
                        sectionDivider("Advanced Settings"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => delayTask = !delayTask),
                              child: SvgPicture.asset(
                                'assets/icons/Rectangle.svg',
                                color: delayTask
                                    ? const Color(0xFFFF1901)
                                    : Colors.grey,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Delay task for upto (random delay)",
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12),
                                    ),
                                  ),
                                  DropdownButton<String>(
                                    value: selectedDelay,
                                    items: ['1 hour', '2 hours', '3 hours']
                                        .map((e) => DropdownMenuItem(
                                            value: e, child: Text(e)))
                                        .toList(),
                                    onChanged: (val) =>
                                        setState(() => selectedDelay = val!),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const SizedBox(width: 28),
                            SvgPicture.asset(
                              'assets/icons/circle_dot.svg',
                              color: Colors.grey,
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "Do not run when a specific event is logged",
                                style: GoogleFonts.spaceGrotesk(
                                    fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        customDropdownRow(
                            "Invoice raised",
                            selectedInvoiceRaised,
                            ['Manually', 'Automatically'], (val) {
                          setState(() => selectedInvoiceRaised = val);
                        }),
                        customDropdownRow(
                            "Stop task if it runs longer than",
                            selectedStopAfter,
                            ['1 day', '2 days', '3 days'], (val) {
                          setState(() => selectedStopAfter = val);
                        }),
                        expiryRow("Expiry", "20/04/2025", "1:41:14 AM"),
                        iconCheckboxTile(
                            "Synchronize across time zones", false, (_) {}),
                        GestureDetector(
                          onTap: () => setState(() => enableTask = !enableTask),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/Rectangle.svg',
                                    colorFilter: const ColorFilter.mode(
                                        Colors.white, BlendMode.srcIn),
                                    width: 20,
                                    height: 20,
                                  ),
                                  if (enableTask)
                                    SvgPicture.asset(
                                      'assets/icons/Tick.svg',
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                      width: 16,
                                      height: 16,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text("Enabled",
                                    style:
                                        GoogleFonts.spaceGrotesk(fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomButton(
                              text: 'Save & Close',
                              svgAsset: 'assets/icons/save_icon.svg',
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              width: 150,
                              height: 40,
                              borderRadius: 8,
                            ),
                            const SizedBox(width: 10),
                            CustomButton(
                              text: 'Cancel',
                              onPressed: () => Navigator.of(context).pop(),
                              isOutlined: true,
                              width: 100,
                              height: 40,
                              borderRadius: 8,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionDivider(String title,
          {Color color = const Color(0xFFFF1901)}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(child: Divider(color: Color(0xFF000000))),
          ],
        ),
      );

  Widget dateTile(String label, String value, {VoidCallback? onTap}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.montserrat(fontSize: 12)),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: onTap,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/calendarr.png',
                    height: 18,
                    width: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(value, style: GoogleFonts.montserrat(fontSize: 13)),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );

  Widget iconCheckboxTile(
          String label, bool value, ValueChanged<bool> onChanged,
          {bool withLabel = true}) =>
      GestureDetector(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/Rectangle.svg',
                color: value ? const Color(0xFFFF1901) : Colors.grey,
                width: 20,
                height: 20,
              ),
              if (withLabel) const SizedBox(width: 8),
              if (withLabel)
                Expanded(
                  child:
                      Text(label, style: GoogleFonts.montserrat(fontSize: 12)),
                ),
            ],
          ),
        ),
      );

  Widget customDropdownRow(String label, String value, List<String> options,
          ValueChanged<String> onChanged) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Rectangle.svg',
              color: Colors.grey,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(label, style: GoogleFonts.montserrat(fontSize: 12))),
            DropdownButton<String>(
              value: value,
              items: options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => onChanged(val!),
            ),
          ],
        ),
      );

  Widget expiryRow(String label, String date, String time) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Rectangle.svg',
              color: Colors.grey,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(label, style: GoogleFonts.montserrat(fontSize: 12))),
            Text(date, style: GoogleFonts.montserrat(fontSize: 12)),
            const SizedBox(width: 8),
            Text(time, style: GoogleFonts.montserrat(fontSize: 12)),
          ],
        ),
      );

  String _monthName(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }
}
