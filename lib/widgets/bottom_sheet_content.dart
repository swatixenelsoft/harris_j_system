import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';

class LeaveBottomSheetContent extends StatefulWidget {
  const LeaveBottomSheetContent({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.selectedOption,
    required this.dateRange,
    required this.isFromClaimScreen,
  });

  final double startValue;
  final double endValue;
  final String selectedOption;
  final String dateRange;
  final bool isFromClaimScreen;

  @override
  State<LeaveBottomSheetContent> createState() => _LeaveBottomSheetContentState();
}

class _LeaveBottomSheetContentState extends State<LeaveBottomSheetContent> {
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

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption; // Initialize mutable variable
    _startValue = widget.startValue;
    _endValue = widget.endValue;
    _dateRange = widget.dateRange;
  }

  // Example function to close the bottom sheet and return updated data:
  void _onClose() {
    // Create a result map or object with the updated values.
    final result = {
      'startValue': _startValue,
      'endValue': _endValue,
      'selectedOption': _selectedOption,
    };
    Navigator.pop(context, result);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime lastSelectableDate =
        DateTime(now.year, now.month, now.day, 23, 59, 59);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: lastSelectableDate,
    );
    if (pickedDate != null) {
      // Compare pickedDate with today's date
      if (pickedDate.year == now.year &&
          pickedDate.month == now.month &&
          pickedDate.day == now.day) {
      } else {
        // Format selected date as DD/MM/YYYY and update the TextEditingController
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate.toLocal());
      }
    }
    print('Selected date: ${controller.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
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
              child: widget.isFromClaimScreen
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      'Select expense type :\u00A0\u00A0\u00A0',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                TextSpan(
                                  text: 'Taxi',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffFF1901),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 👇 Date Heading and TextField wrapped together with tighter spacing
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _selectDate(context, _dateController);
                            },
                            child: AbsorbPointer(
                              child: CustomTextField(
                                readOnly: true,
                                label: "Date",
                                hintText: "",
                                controller: _dateController,
                                useUnderlineBorder: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(
                                      12), // adjust as needed
                                  child: SvgPicture.asset(
                                    'assets/icons/calendar_icon.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Expense Type",
                            hintText: "",
                            controller: _remarkController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Particulars",
                            hintText: "",
                            controller: _remarkController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Amount ",
                            hintText: "",
                            controller: _remarkController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Location From",
                            hintText: "",
                            controller: _remarkController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Location To",
                            hintText: "",
                            controller: _remarkController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'Remarks*',
                        style:     GoogleFonts.montserrat(
                              color:const Color(0xff1D212D),
                              fontSize: 12,
                              fontWeight:FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: CustomTextField(
                            hintText: 'Max 200 words are allowed',
                            maxLines: 4,
                            controller: _remarkController,
                          ),
                        ),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () async {
                            PlatformFile? file = await CommonFunction()
                                .pickFileOrCapture(context);
                            if (file != null) {
                              // Process the file (e.g., upload it or display its details)
                              setState(() {
                                _selectedFiles.add(file);
                              });
                              print(
                                  'Picked file: ${file.name}, size: ${file.size}');
                            }
                          },
                          child: _borderTextContainer(
                              'Upload Invoice / Receipt',
                              'assets/icons/upload.svg',
                              const EdgeInsets.symmetric(horizontal: 25)),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Text(
                              '*Allow to upload file PNG,JPG,PDF (Max.file size: 1MB)',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff798AA3)),
                            )),

                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomButton(
                                  width: 80,
                                  height: 30,
                                  text: 'Close',
                                  onPressed: () {},
                                  isOutlined: true),
                              CustomButton(
                                  width: 80,
                                  height: 30,
                                  text: 'Save',
                                  onPressed: () {},
                                  isOutlined: true),
                              CustomButton(
                                  width: 90,
                                  height: 30,
                                  text: 'Save & Add',
                                  onPressed: () {},
                                  isOutlined: true),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: RichText(
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
                                  text: 'Medical Leave (ML)',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xffFF1901),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _headingText('ML leave hours :'),
                        buildRadioTile("Full Day", _selectedOption, (value) {
                          setState(() => _selectedOption = value);
                        }),
                        buildRadioTile(
                            "Second half workday (HD2)", _selectedOption,
                            (value) {
                          setState(() => _selectedOption = value);
                        }),
                        buildRadioTile(
                            "First half workday (HD1)", _selectedOption,
                            (value) {
                          setState(() => _selectedOption = value);
                        }),
                        buildRadioTile("Custom", _selectedOption, (value) {
                          setState(() => _selectedOption = value);
                        }),
                        const SizedBox(height: 10),
                        _headingText('Select date :'),
                        const SizedBox(height: 10),
                        _borderTextContainer(
                            '$_dateRange - $_dateRange',
                            'assets/icons/calendar_icon.svg',
                            const EdgeInsets.symmetric(horizontal: 30)),
                        const SizedBox(height: 20),
                        _headingText('Select Leave Slot :'),
                        const SizedBox(height: 20),
                        _leaveSlot(
                            false, ['Mid - Night', 'Noon', 'Mid - Night']),
                        _leaveSlot(
                          true,
                          [
                            'assets/icons/mid_night.png',
                            'assets/icons/noon.png',
                            'assets/icons/mid_night.png'
                          ],
                        ),
                        const SizedBox(height: 25),
                        timeRangeSlider(context, _startValue, _endValue,
                            (start, end) {
                          _startValue = start;
                          _endValue = end;
                        }),
                        const SizedBox(height: 25),
                        GestureDetector(
                          onTap: () async {
                            PlatformFile? file = await CommonFunction()
                                .pickFileOrCapture(context);
                            if (file != null) {
                              // Process the file (e.g., upload it or display its details)
                              setState(() {
                                _selectedFiles.add(file);
                              });
                              print(
                                  'Picked file: ${file.name}, size: ${file.size}');
                            }
                          },
                          child: _borderTextContainer(
                              'Upload Medical Leave Certificate',
                              'assets/icons/upload.svg',
                              const EdgeInsets.symmetric(horizontal: 30)),
                        ),
                        const SizedBox(height: 10),
                        if (_selectedFiles.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children:
                                  _selectedFiles.asMap().entries.map((entry) {
                                int index = entry.key;
                                PlatformFile file = entry.value;
                                Widget fileWidget;
                                if (file.extension != null &&
                                    [
                                      'png',
                                      'jpg',
                                      'jpeg'
                                    ].contains(file.extension!.toLowerCase()) &&
                                    file.path != null) {
                                  fileWidget = Container(
                                    width: 51,
                                    height: 49,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      image: DecorationImage(
                                        image: FileImage(File(file.path!)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                } else {
                                  fileWidget = Container(
                                    width: 51,
                                    height: 49,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 4),
                                        SvgPicture.asset(
                                            'assets/icons/marker.svg'),
                                      ],
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Toggle overlay visibility for this file.
                                      _overlayIndex =
                                          _overlayIndex == index ? null : index;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      fileWidget,
                                      if (_overlayIndex == index)
                                        Positioned.fill(
                                          child: Container(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _selectedFiles
                                                        .removeAt(index);
                                                    _overlayIndex = null;
                                                  });
                                                },
                                                child: Image.asset(
                                                    'assets/icons/delete_icon.png',
                                                    height: 18,
                                                    width: 23),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (_selectedFiles.isNotEmpty)
                          const SizedBox(height: 5),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              '*Allow to upload file PNG,JPG,PDF\n (Max.file size: 1MB)',
                              style: GoogleFonts.spaceGrotesk(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff798AA3)),
                            )),
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
                              onPressed: () {},
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
                  widget.isFromClaimScreen
                      ? Text(
                          'Claim Form # :\nCF0982',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff8D91A0),
                          ),
                        )
                      : Text(
                          'Time On Duty :\n-- / 8.30',
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

  Widget buildRadioTile(
      String title, String selectedValue, Function(String) onChanged) {
    return RadioListTile<String>(
      value: title,
      groupValue: selectedValue,
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
      title: Row(
        mainAxisSize: MainAxisSize.min, // Minimize space usage
        children: [
          SvgPicture.asset(
            title == "Custom"
                ? 'assets/icons/custom_leave_icon.svg'
                : 'assets/icons/leave_icon.svg',
            height: 16, // Reduced icon height
            width: 16, // Reduced icon width
          ),
          const SizedBox(width: 10), // Decreased spacing
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xff2C2C2E),
            ),
          ),
        ],
      ),
      activeColor: const Color(0xff00C2A8),
      controlAffinity: ListTileControlAffinity.leading,
      visualDensity:
          const VisualDensity(horizontal: -4, vertical: -4), // Reduce spacing
      materialTapTargetSize:
          MaterialTapTargetSize.shrinkWrap, // Shrink tap area
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

  Widget timeRangeSlider(BuildContext context, double startValue,
      double endValue, Function(double, double) onChanged) {
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
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  onChanged(lowerValue, upperValue);
                },
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
