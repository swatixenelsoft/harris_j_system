import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_radio_tile_widget.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtraWorkBottomSheetContent extends ConsumerStatefulWidget {
  const ExtraWorkBottomSheetContent({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.dateRange,
    required this.workHour,
  });

  final double startValue;
  final double endValue;
  final String dateRange;
  final String workHour;

  @override
  ConsumerState<ExtraWorkBottomSheetContent> createState() =>
      _ExtraWorkBottomSheetContentState();
}

class _ExtraWorkBottomSheetContentState
    extends ConsumerState<ExtraWorkBottomSheetContent> {
  late String _selectedOption;
  late double _startValue;
  late double _endValue;
  late String _dateRange;
  final List<PlatformFile> _selectedFiles = [];
  int? _overlayIndex;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _expenseTypeController = TextEditingController();
  final TextEditingController _particularController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _locationFromController = TextEditingController();
  final TextEditingController _locationToController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  String selectedLeaveType = 'Comp-off';

  final Map<String, String> leaveOptions = {
    'comp_off': 'Comp-off',
    'pay_off': 'Pay-off',
    'ignore': 'Ignore',
  };

  @override
  void initState() {
    super.initState();
    _startValue = widget.startValue;
    _endValue = _startValue + (int.parse(widget.workHour) * 60);
    _dateRange = widget.dateRange;

    print('_startValue $_startValue,${widget.workHour}');
  }

  // Example function to close the bottom sheet and return updated data:
  void _onClose() {
    // Create a result map or object with the updated values.

    Navigator.pop(context);
  }

  Future<void> _addWorkHours() async {
    if (_remarkController.text.isEmpty) {
      ToastHelper.showError(context, 'Remark is required');

      return;
    } else {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');
      const type = 'timesheet';
      const clientId = '1';
      const clientName = "Xenelsoft";
      const status = 'Draft';
      final record = [
        {
          "date": widget.dateRange,
          "workingHours": widget.workHour,
          "applyOnCell": widget.dateRange,
          "remarks": _remarkController.text,
          "type": selectedLeaveType,
          "extraHours": int.parse(widget.workHour) - 8,
          "time": CommonFunction().getCurrentTimeFormatted(),
          "certificate_path": null
        }
      ];
      const corporateEmail = "";
      const reportingManagerEmail = "";
      const certificate = null;

      print(
          'workhoursdata $token,$userId,$type,$clientId,$clientName,$status,$record,$certificate');

      final response = await ref
          .read(consultantProvider.notifier)
          .addTimesheetData(
              token!,
              userId.toString(),
              type,
              clientId,
              clientName,
              status,
              record,
              corporateEmail,
              reportingManagerEmail,
              "",
              "",
              certificate);

      if (response['success']) {
        context.pop({'success': true});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: selectedLeaveType == "Medical Leave (ML)" ||
              selectedLeaveType == "Custom Leave"
          ? MediaQuery.of(context).size.height * 0.5
          : MediaQuery.of(context).size.height * 0.2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Fix overflow issue
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _headerSection(context, _dateRange),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: GestureDetector(
                      onTap: () async {
                        final String? selectedKey =
                            await showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors
                              .transparent, // Important for rounded corners to show properly
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return Container(
                              decoration: const BoxDecoration(
                                color:
                                    Colors.white, // Set background color here
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: leaveOptions.entries.map((entry) {
                                  return ListTile(
                                      title: Text(
                                        entry.value,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                      onTap: () {
                                        print('${entry.key} ${entry.value}');
                                        Navigator.pop(context, entry.key);
                                      });
                                }).toList(),
                              ),
                            );
                          },
                        );

                        print('selectedKey $selectedKey');
                        if (selectedKey != null) {
                          setState(() {
                            selectedLeaveType = selectedKey;
                          });
                          print('$selectedLeaveType');
                        }
                      },
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Leave type :\u00A0\u00A0\u00A0',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                TextSpan(
                                  text: selectedLeaveType,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffFF1901),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                  _headingText('Select date :'),
                  const SizedBox(height: 10),
                  _borderTextContainer(
                      '$_dateRange - $_dateRange',
                      'assets/icons/calendar_icon.svg',
                      const EdgeInsets.symmetric(horizontal: 30)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _headingText('Extra Hours :'),
                      Text(
                          '${(int.parse(widget.workHour) - 8).toString()} hours'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _headingText('Total Working Hours :'),
                      Text('${widget.workHour} Hours')
                    ],
                  ),
                  const SizedBox(height: 10),
                  _headingText('Select Leave Slot :'),
                  const SizedBox(height: 20),
                  _leaveSlot(false, ['Mid - Night', 'Noon', 'Mid - Night']),
                  _leaveSlot(
                    true,
                    [
                      'assets/icons/mid_night.png',
                      'assets/icons/noon.png',
                      'assets/icons/mid_night.png'
                    ],
                  ),
                  const SizedBox(height: 25),
                  timeRangeSlider(
                    context,
                    _startValue,
                    _endValue,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Write your remarks..',
                    maxLines: 4,
                    controller: _remarkController,
                    // padding: 30.0,
                    label: 'Remarks',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                        width: 140,
                        onPressed: () {},
                        text: 'Cancel',
                        isOutlined: true,
                      ),
                      CustomButton(
                        width: 140,
                        onPressed: () {
                          _addWorkHours();
                        },
                        text: 'Clock It',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context, String dateRange) {
    return Stack(
      children: [
        Container(
          height: 102,
          decoration: const BoxDecoration(
            color: Color(0xffF1F4F6),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 31, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date :\n$dateRange',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff8D91A0),
                    ),
                  ),
                  Text(
                    'Time On Duty :\n${widget.workHour} / 8.30',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff8D91A0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 12,
          right: 10,
          child: GestureDetector(
            onTap: () {
              _onClose();
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.red,
                size: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _headingText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _borderTextContainer(
      String text, String iconPath, EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: const Color(0xff979797)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(iconPath),
            Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xff828282),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leaveSlot(bool isImage, List<String> labels) {
    return isImage
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: labels
                  .map((path) => Flexible(
                        child: Image.asset(path, height: 35, width: 35),
                      ))
                  .toList(),
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels
                  .map((label) => Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
            ),
          );
  }

  Widget timeRangeSlider(
      BuildContext context, double startValue, double endValue) {
    String formatTime(double minutes) {
      int hours = (minutes ~/ 60) % 12 == 0 ? 12 : (minutes ~/ 60) % 12;
      int mins = (minutes % 60).toInt();
      String period = minutes < 720 ? "AM" : "PM";
      return "$hours:${mins.toString().padLeft(2, '0')} $period";
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              FlutterSlider(
                disabled: true,
                values: [startValue, endValue],
                min: 0,
                max: 24 * 60, // 1440 minutes in a day
                handlerHeight: 55,
                handlerWidth: 24,
                rangeSlider: true,
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(
                    color: const Color(0xffD1D1D6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  activeTrackBar: BoxDecoration(
                    color: const Color(0xff037EFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  inactiveTrackBarHeight: 12, // Thinner inactive track
                  activeTrackBarHeight: 12, // Thicker active track
                ),
                handler: FlutterSliderHandler(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent, // Remove default background
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/marker.svg', // Your custom SVG
                    width: 22, // Adjust size as needed
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
                rightHandler: FlutterSliderHandler(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent, // Remove default background
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/marker.svg', // Your custom SVG
                    width: 22, // Adjust size as needed
                    height: 22,
                    fit: BoxFit.contain,
                  ),
                ),
                tooltip: FlutterSliderTooltip(
                  alwaysShowTooltip: true,
                  positionOffset: FlutterSliderTooltipPositionOffset(top: 0),
                  textStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  boxStyle: FlutterSliderTooltipBox(
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  format: (value) => formatTime(double.parse(value)),
                  custom: (value) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          formatTime(value),
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      CustomPaint(
                        size: const Size(15, 10),
                        painter: TrianglePainter(Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 15,
                right: 15,
                bottom: 35,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Ensure equal spacing
                  children: List.generate(49, (index) {
                    bool isMainHour = index % 8 == 0; // Main hour every 8 ticks
                    bool isBig =
                        !isMainHour && index % 2 == 0; // Alternating big-small

                    return Column(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align all ticks at the top
                      children: [
                        Container(
                          width: isMainHour ? 2 : 1,
                          height: 12, // Set a fixed height for alignment
                          decoration: const BoxDecoration(
                            color: Colors
                                .transparent, // Invisible container to maintain alignment
                          ),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: isMainHour ? 2 : 1,
                              height: isMainHour
                                  ? 12
                                  : (isBig ? 8 : 6), // Adjust height
                              decoration: BoxDecoration(
                                color: const Color(0xffD1D1D6),
                                borderRadius:
                                    BorderRadius.circular(2), // Rounded edges
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              /// **Time Labels (Below Main Hour Ticks)**
              Positioned(
                left: 8,
                right: 8,
                bottom: 10,
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // Align labels properly
                  children: List.generate(7, (index) {
                    int hour = index * 4;
                    String hourText = hour == 0
                        ? "12"
                        : hour == 12
                            ? "12"
                            : hour > 12
                                ? "${hour - 12}"
                                : "$hour";
                    String period = (hour < 12) ? "AM" : "PM";

                    return RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          color: const Color(0xffD1D1D6),
                          fontSize: 10,
                        ),
                        children: [
                          TextSpan(
                              text: hourText,
                              style:
                                  const TextStyle(height: 1)), // Reduce space
                          const TextSpan(text: "\n"),
                          TextSpan(
                              text: period,
                              style: const TextStyle(
                                  height: 1.2)), // Reduce space further
                        ],
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    Path path = Path()
      ..moveTo(size.width / 2, size.height) // Bottom center
      ..lineTo(0, 0) // Bottom left
      ..lineTo(size.width, 0) // Bottom right
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
