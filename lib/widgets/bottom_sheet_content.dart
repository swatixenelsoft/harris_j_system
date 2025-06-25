import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:go_router/go_router.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_radio_tile_widget.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveBottomSheetContent extends ConsumerStatefulWidget {
  const LeaveBottomSheetContent({
    super.key,
    required this.startValue,
    required this.endValue,
    required this.selectedOption,
    required this.dateRange,
    required this.isFromClaimScreen,
    this.expense,
  });

  final double startValue;
  final double endValue;
  final String selectedOption;
  final String dateRange;
  final bool isFromClaimScreen;
  final Map<String, dynamic>? expense;

  @override
  ConsumerState<LeaveBottomSheetContent> createState() =>
      _LeaveBottomSheetContentState();
}

class _LeaveBottomSheetContentState
    extends ConsumerState<LeaveBottomSheetContent> {
  late String _selectedLeaveOption = 'Full Day';
  String _selectedLeaveOptionId = 'fullDay';
  late String _selectedClaimOption = 'Full Day';
  String _selectedClaimsOptionId = 'fHalfDay';
  late double _startValue;
  late double _endValue;
  late String _dateRange;
  final List<PlatformFile> _selectedFiles = [];
  int? _overlayIndex;
  bool _isSliderEnabled = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _expenseTypeController = TextEditingController();
  final TextEditingController _writeExpenseController = TextEditingController();
  final TextEditingController _particularController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _locationFromController = TextEditingController();
  final TextEditingController _locationToController = TextEditingController();
  final TextEditingController _remarkController = TextEditingController();

  String selectedLeaveType = 'Select Leave Type';
  String selectedClaimType = 'Select Claim Type';
  String? selectedCustomLeaveType;
  String claimNumber = 'CF${Random().nextInt(9000) + 1000}';

  final Map<String, String> leaveOptions = {
    'NA': 'Select Leave Type',
    'ML': 'ML',
    'PDO': 'PDO',
    'AL': 'AL',
    'PH': 'PH',
    'Custom': 'Custom',
  };

  final Map<String, String> customLeaveType = {
    'Custom AL': 'AL',
    'Custom UL': 'UL',
    'Custom PDO': 'PDO',
    'Custom COMP-OFF': 'Comp-off',
  };

  final Map<String, String> claimType = {
    'NA': 'Select Claim Type',
    'Taxi': 'Taxi',
    'Dining': 'Dining',
    'Others': 'Others',
  };

  bool _isCustomLeaveVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedLeaveOption = widget.selectedOption; // Initialize mutable variable
    _startValue = widget.startValue;
    _endValue = widget.endValue;
    _dateRange = widget.dateRange;
    _dateController.text = widget.dateRange;

    if (widget.expense != null) {
      selectedClaimType = widget.expense!['expenseType'];
      _expenseTypeController.text = widget.expense!['expenseType'];
      _amountController.text = widget.expense!['amount'];
      _particularController.text = widget.expense!['particulars'];
      _locationToController.text = widget.expense!['locationTo'];
      _locationFromController.text = widget.expense!['locationFrom'];
      _writeExpenseController.text = widget.expense!['otherExpense'] ?? '';
      _remarkController.text = widget.expense!['remarks'];
      claimNumber = widget.expense!['claim_no'];
    }
  }

  // Example function to close the bottom sheet and return updated data:
  void _onClose() {
    // Create a result map or object with the updated values.
    final result = {
      'startValue': _startValue,
      'endValue': _endValue,
      'selectedOption': _selectedLeaveOption,
    };
    Navigator.pop(context, result);
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    // Default fallback dates
    DateTime initialStart = DateTime.now();
    DateTime initialEnd = DateTime.now().add(const Duration(days: 1));

    // Try to parse single date string
    if (widget.dateRange.isNotEmpty) {
      try {
        final format = DateFormat('dd / MM / yyyy');
        initialStart = format.parse(widget.dateRange.trim());
        initialEnd = format.parse(widget.dateRange.trim());
      } catch (e) {
        debugPrint('Failed to parse date: $e');
      }
    }
    print('initialStart $initialStart , $initialEnd');
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: initialStart,
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: initialStart, end: initialEnd),
    );

    if (picked != null) {
      setState(() {
        final String formattedStart =
            DateFormat('dd / MM / yyyy').format(picked.start);
        final String formattedEnd =
            DateFormat('dd / MM / yyyy').format(picked.end);
        controller.text = '$formattedStart - $formattedEnd';
        _dateRange = '$formattedStart - $formattedEnd';
        _isSliderEnabled = false;
      });
    }
  }

  Future<void> _addWorkHours(date, applyOnCell, leaveType, leaveHour,
      leaveHourId, selectedFile) async {
    final formattedDate = convertDateRange(date);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    const type = 'timesheet';
    const clientId = '1';
    const clientName = "Xenelsoft";
    const status = 'Draft';
    final record = [
      {
        "date": formattedDate,
        "applyOnCell": applyOnCell,
        "leaveType": leaveType,
        "leaveHour": leaveHour,
        "leaveHourId": leaveHourId,
        "remarks": _remarkController.text,
        "time": CommonFunction().getCurrentTimeFormatted(),
        "certificate_path": null,
        if (!formattedDate.contains('to')) ...{
          "rangeMin": formatHourToTime(_startValue / 60),
          "rangeMax": formatHourToTime(_endValue / 60),
        }
      }
    ];
    const corporateEmail = "";
    const reportingManagerEmail = "";
    var certificate = _selectedFiles.isNotEmpty ? _selectedFiles[0].path : null;
    print("Certificate path: $certificate");

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

    print('timesheetaddresponse $response');
  }

  Future<void> _addClaim(
    date,
    expenseType,
    applyOnCell,
    particulars,
    amount,
    remarks,
    locationFrom,
    locationTo,
    otherExpense,
    selectedFile,
    claimId,
  ) async {
    final formattedDate = widget.expense != null ? date : convertDate(date);
    final formattedApplyDate =
        widget.expense != null ? convertDisplayDate(date) : date;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');
    const type = 'claims';
    const clientId = '1';
    const clientName = "Xenelsoft";
    const status = 'Draft';
    final record = {
      "date": formattedDate,
      "expenseType": expenseType,
      "applyOnCell": formattedApplyDate,
      "particulars": particulars,
      "amount": amount,
      "remarks": remarks,
      "locationFrom": locationFrom,
      "locationTo": locationTo,
      "otherExpense": otherExpense,
      "certificate_path": null,
      "time": CommonFunction().getCurrentTimeFormatted(),
    };
    const corporateEmail = "";
    const reportingManagerEmail = "";
    var certificate = _selectedFiles.isNotEmpty ? _selectedFiles[0].path : null;

    print("Certificate path: $certificate");

    print(
        'workhoursdata $token,$userId,$type,$clientId,$clientName,$status,$record,$certificate,$claimId');

    final response = await ref.read(consultantProvider.notifier).addClaimData(
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
        certificate,
        claimId.toString());

    if (response['success']) {
      context.pop({'success': true});
    }

    print('timesheetaddresponse $response');
  }

  String convertDateRange(String date) {
    if (date.contains('-')) {
      final parts = date.split('-');
      return "${parts[0].trim()} to ${parts[1].trim()}";
    }
    return date;
  }

  String convertDate(String inputDate) {
    // Remove spaces from the date
    String cleanedDate = inputDate.replaceAll(' ', '');

    // Parse using the input format: dd/MM/yyyy
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(cleanedDate);

    // Format to the desired output: yyyy-MM-dd
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String convertDisplayDate(String inputDate) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
    return DateFormat('dd / MM / yyyy').format(parsedDate);
  }

  String formatHourToTime(double hourDecimal) {
    int hour = hourDecimal.floor(); // integer hour part
    int minutes = ((hourDecimal - hour) * 60).round(); // minutes part

    final DateTime time = DateTime(0, 0, 0, hour, minutes);
    final String formattedTime =
        "${(time.hour % 12 == 0) ? 12 : time.hour % 12}:${time.minute.toString().padLeft(2, '0')} ${time.hour < 12 ? 'AM' : 'PM'}";
    return formattedTime;
  }

  void _showPopup(BuildContext context, leaveType) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              Center(
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.7,
                      ),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Header
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Enter Remark",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 150, 27, 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_outlined,
                                      size: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // TextField
                          CustomTextField(
                              hintText: 'Enter Remark',
                              label: 'Enter Remark',
                              maxLines: 3,
                              controller: _remarkController),
                          const SizedBox(height: 20),

                          // Submit button
                          CustomButton(
                              text: 'Clock It',
                              onPressed: () {
                                context.pop();
                                _addWorkHours(
                                    widget.dateRange,
                                    widget.dateRange,
                                    leaveType,
                                    "Full Day",
                                    "fullDay",
                                    null);
                              })
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: selectedLeaveType == "ML" ||
              selectedLeaveType == "Custom" ||
              widget.isFromClaimScreen
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
              child: widget.isFromClaimScreen
                  ? Column(
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
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .white, // Set background color here
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: claimType.entries.map((entry) {
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
                                              print('${entry.key}');
                                              Navigator.pop(context, entry.key);
                                            });
                                      }).toList(),
                                    ),
                                  );
                                },
                              );

                              if (selectedKey != null) {
                                setState(() {
                                  selectedClaimType = claimType[selectedKey]!;
                                  _expenseTypeController.text =
                                      selectedClaimType;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Select type :\u00A0\u00A0\u00A0',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff000000),
                                        ),
                                      ),
                                      TextSpan(
                                        text: selectedClaimType,
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

                        // 👇 Date Heading and TextField wrapped together with tighter spacing
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            readOnly:
                                selectedClaimType == "Others" ? false : true,
                            label: "Expense Type",
                            hintText: "",
                            controller: _expenseTypeController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        if (selectedClaimType == "Others")
                          const SizedBox(height: 15),
                        if (selectedClaimType == "Others")
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              label: "Write your expense",
                              hintText: "",
                              controller: _writeExpenseController,
                              useUnderlineBorder: true,
                            ),
                          ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Particulars",
                            hintText: "Invoice number",
                            controller: _particularController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: CustomTextField(
                            label: "Amount ",
                            hintText: "",
                            controller: _amountController,
                            useUnderlineBorder: true,
                          ),
                        ),
                        if (selectedClaimType == "Others")
                          const SizedBox(height: 15),
                        if (selectedClaimType == "Others")
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              label: "Location From",
                              hintText: "",
                              controller: _locationFromController,
                              useUnderlineBorder: true,
                            ),
                          ),
                        if (selectedClaimType == "Others")
                          const SizedBox(height: 15),
                        if (selectedClaimType == "Others")
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: CustomTextField(
                              label: "Location To",
                              hintText: "",
                              controller: _locationToController,
                              useUnderlineBorder: true,
                            ),
                          ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            'Remarks*',
                            style: GoogleFonts.montserrat(
                              color: const Color(0xff1D212D),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
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
                                  onPressed: () {
                                    context.pop();
                                  },
                                  isOutlined: true),
                              CustomButton(
                                  width: 80,
                                  height: 30,
                                  text: 'Save',
                                  onPressed: () {
                                    print('eghfd $claimNumber');
                                    if (widget.expense != null) {
                                      _addClaim(
                                        widget.dateRange,
                                        selectedClaimType,
                                        widget.dateRange,
                                        _particularController.text,
                                        _amountController.text,
                                        _remarkController.text,
                                        _locationFromController.text,
                                        _locationToController.text,
                                        _writeExpenseController.text,
                                        _selectedFiles,
                                        widget.expense!['id'],
                                      );
                                    } else {
                                      _addClaim(
                                        widget.dateRange,
                                        selectedClaimType,
                                        widget.dateRange,
                                        _particularController.text,
                                        _amountController.text,
                                        _remarkController.text,
                                        _locationFromController.text,
                                        _locationToController.text,
                                        _writeExpenseController.text,
                                        _selectedFiles,
                                        "",
                                      );
                                    }
                                  },
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
                          child: GestureDetector(
                            onTap: () async {
                              final String? selectedKey =
                                  await showModalBottomSheet<String>(
                                context: context,
                                backgroundColor: Colors
                                    .transparent, // Important for rounded corners to show properly
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors
                                          .white, // Set background color here
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          leaveOptions.entries.map((entry) {
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
                                              print('${entry.key}');
                                              if (entry.key == 'AL') {
                                                _addWorkHours(
                                                    widget.dateRange,
                                                    widget.dateRange,
                                                    entry.key,
                                                    "Full Day",
                                                    "fullDay",
                                                    null);
                                              } else if (entry.key == 'PDO') {
                                                _addWorkHours(
                                                    widget.dateRange,
                                                    widget.dateRange,
                                                    entry.key,
                                                    "Full Day",
                                                    "fullDay",
                                                    null);
                                              } else if (entry.key == 'PH') {
                                                _showPopup(context, entry.key);
                                              } else if (entry.key ==
                                                  'Custom') {
                                                setState(() {
                                                  _isCustomLeaveVisible = true;
                                                });
                                              }
                                              Navigator.pop(context, entry.key);
                                            });
                                      }).toList(),
                                    ),
                                  );
                                },
                              );

                              if (selectedKey != null) {
                                setState(() {
                                  selectedLeaveType =
                                      leaveOptions[selectedKey]!;
                                });
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
                        if (_isCustomLeaveVisible)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: customLeaveType.entries.map((entry) {
                                final isSelected =
                                    selectedCustomLeaveType == entry.key;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCustomLeaveType = entry.key;
                                    });
                                    print(
                                        'selectedCustomLeaveType $selectedCustomLeaveType');
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      entry.value,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        if (selectedLeaveType == "ML" ||
                            selectedLeaveType == "Custom") ...[
                          _headingText('$selectedLeaveType leave hours :'),
                          CustomRadioTileWidget(
                              title: "Full Day",
                              selectedValue: _selectedLeaveOption,
                              onChanged: (value) {
                                print('value $value');
                                setState(() {
                                  _selectedLeaveOption = value;
                                  _selectedLeaveOptionId = 'fullDay';
                                  _startValue = 9 * 60;
                                  _endValue = 18.5 * 60;
                                  _isSliderEnabled = false;
                                });
                              }),
                          CustomRadioTileWidget(
                              title: "Second half workday (HD2)",
                              selectedValue: _selectedLeaveOption,
                              onChanged: (value) {
                                print('value $value');
                                setState(() {
                                  _selectedLeaveOption = value;
                                  _selectedLeaveOptionId = 'sHalfDay';
                                  _startValue = 13 * 60;
                                  _endValue = 18.5 * 60;
                                  _isSliderEnabled = false;
                                });
                              }),
                          CustomRadioTileWidget(
                              title: "First half workday (HD1)",
                              selectedValue: _selectedLeaveOption,
                              onChanged: (value) {
                                print('value $value');
                                setState(() {
                                  _selectedLeaveOption = value;
                                  _selectedLeaveOptionId = 'fHalfDay';
                                  _startValue = 9 * 60;
                                  _endValue = 13 * 60;
                                  _isSliderEnabled = false;
                                });
                              }),
                          CustomRadioTileWidget(
                              title: "Custom",
                              selectedValue: _selectedLeaveOption,
                              onChanged: (value) {
                                print('value $value');
                                setState(() {
                                  _selectedLeaveOption = value;
                                  _selectedLeaveOptionId = 'customDay';
                                  _isSliderEnabled = true;
                                });
                              }),
                          const SizedBox(height: 10),
                          _headingText('Select date :'),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              print('dfv');
                              FocusScope.of(context).unfocus();
                              _selectDate(context, _dateController);
                            },
                            child: _borderTextContainer(
                                _dateRange,
                                'assets/icons/calendar_icon.svg',
                                const EdgeInsets.symmetric(horizontal: 30)),
                          ),
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
                          }, _isSliderEnabled),
                          const SizedBox(height: 25),
                          if (selectedLeaveType == "ML") ...[
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children: _selectedFiles
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    PlatformFile file = entry.value;
                                    Widget fileWidget;
                                    if (file.extension != null &&
                                        ['png', 'jpg', 'jpeg'].contains(
                                            file.extension!.toLowerCase()) &&
                                        file.path != null) {
                                      fileWidget = Container(
                                        width: 51,
                                        height: 49,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                          borderRadius:
                                              BorderRadius.circular(4),
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
                                          _overlayIndex = _overlayIndex == index
                                              ? null
                                              : index;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          fileWidget,
                                          if (_overlayIndex == index)
                                            Positioned.fill(
                                              child: Container(
                                                color: Colors.black
                                                    .withOpacity(0.5),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  '*Allow to upload file PNG,JPG,PDF\n (Max.file size: 1MB)',
                                  style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff798AA3)),
                                )),
                          ],
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
                                onPressed: () {
                                  context.pop();
                                },
                                text: 'Cancel',
                                isOutlined: true,
                              ),
                              CustomButton(
                                width: 140,
                                onPressed: () {
                                  _addWorkHours(
                                      _dateRange,
                                      widget.dateRange,
                                      selectedLeaveType == "ML"
                                          ? 'ML'
                                          : selectedCustomLeaveType,
                                      _selectedLeaveOption,
                                      _selectedLeaveOptionId,
                                      _selectedFiles);
                                },
                                text: 'Clock It',
                              ),
                            ],
                          ),
                        ],
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
                    'Date :\n${widget.dateRange}',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff8D91A0),
                    ),
                  ),
                  widget.isFromClaimScreen
                      ? Text(
                          'Claim Form # :\n$claimNumber',
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(iconPath),
            const SizedBox(width: 10),
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
      double endValue, Function(double, double) onChanged, bool isSlider) {
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
                disabled: isSlider ? false : true,
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
