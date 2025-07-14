// import 'package:calenderapp/widgets/bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/consultant/consultant_timesheet_screen.dart';
import 'package:harris_j_system/screens/consultant/widget/claim_detail_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/bottom_sheet_content.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_month_year.dart';
import 'package:harris_j_system/widgets/custom_radio_tile_widget.dart';
import 'package:harris_j_system/widgets/work_log_widget.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  final Function(double) onHeightCalculated;
  final Map<DateTime, dynamic> customData;
  final bool isFromClaimScreen;
  final bool isFromHrScreen;
  final List<dynamic>? claimsDetails;
  final Map<String,dynamic>? backDatedClaims;
  final void Function(int month, int year)? onMonthChanged;
  final VoidCallback? onDataUpdated;
  final int selectedMonth;
  final int selectedYear;

  const CalendarScreen({
    super.key,
    required this.onHeightCalculated,
    required this.customData,
    this.isFromClaimScreen = false,
    this.isFromHrScreen = false,
    this.claimsDetails,
    this.onMonthChanged,
    this.onDataUpdated,
    this.backDatedClaims,
    required this.selectedMonth,
    required this.selectedYear,
  });

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late PageController _pageController;
  DateTime _currentMonth = DateTime.now();

  final List<Map<String, String>> leaveOptions = [
    {'value': 'Full Day', 'label': 'Full Day'},
    {'value': 'HD2', 'label': 'Second half workday (HD2)'},
    {'value': 'HD1', 'label': 'First half workday (HD1)'},
    {'value': 'Custom', 'label': 'Custom'},
  ];
  double startValue = 9 * 60; // 9:00 AM
  double endValue = 18.5 * 60; // 6:30 PM
  String selectedOption = "Custom";
  String selectedPreferenceOption = "Custom";
  String dateRange = "19 / 03 / 2025 - 19 / 03 /2025";

  late double calculatedHeight;

  final DateTime _baseDate = DateTime(2000, 1); // Safe low bound

  @override
  void initState() {
    super.initState();

    _currentMonth = DateTime(widget.selectedYear, widget.selectedMonth);
    int initialPage = _monthDifference(_baseDate, _currentMonth);

    _pageController = PageController(initialPage: initialPage);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentMonth = DateTime(
        _baseDate.year,
        _baseDate.month + index,
        1,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onMonthChanged?.call(_currentMonth.month, _currentMonth.year);
    });
  }

  DateTime parseDate(String dateStr) {
    final parts = dateStr.split(' / ');
    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  void bottomSheetWidget(BuildContext context, dynamic date) async {
    Widget bottomSheetToShow;

    DateTime normalizedDate =
        parseDate(date); // Your helper to convert "dd / MM / yyyy"

    Future<void> showBottomSheetContent(String type) async {
      if (type == 'leave') {
        bottomSheetToShow = LeaveBottomSheetContent(
          startValue: startValue,
          endValue: endValue,
          selectedOption: selectedOption,
          dateRange: date,
          isFromClaimScreen: widget.isFromClaimScreen,
        );
      } else {
        bottomSheetToShow = WorkBottomSheetContent(
          startValue: startValue,
          endValue: endValue,
          selectedOption: selectedOption,
          dateRange: date,
          isFromClaimScreen: widget.isFromClaimScreen,
        );
      }

      final result = await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return bottomSheetToShow;
          });
        },
      );

      if (result != null) {
        // Only update state if result has these keys
        if (mounted && result.containsKey('startValue')) {
          setState(() {
            startValue = result['startValue'] as double;
            endValue = result['endValue'] as double;
            selectedOption = result['selectedOption'] as String;
          });
        }

        print('result claims $result');
        // ✅ Notify parent (like TimeSheetScreen) to refresh data
        if (result['success'] == true && widget.onDataUpdated != null) {
          widget.onDataUpdated!();
        }
      }
    }

    if (widget.isFromClaimScreen) {

      showBottomSheetContent('leave');
    } else {
      await showModalBottomSheet<Map<String, dynamic>>(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerSection(context, date.toString()),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      'Select Preference:',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  CustomRadioTileWidget(
                      title: "Leave",
                      selectedValue: '',
                      onChanged: (value) {
                        // setState(() => _selectedOption = value);
                        Navigator.pop(context); // Close the selector sheet
                        showBottomSheetContent('leave');
                      }),
                  CustomRadioTileWidget(
                      title: "Work",
                      selectedValue: '',
                      onChanged: (value) {
                        // setState(() => _selectedOption = value);
                        Navigator.pop(context); // Close the selector sheet
                        showBottomSheetContent('work');
                      }),
                ],
              ),
            );
          });
        },
      );
    }
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthYearPickerDialog(
        initialDate: _currentMonth,
      ),
    );

    if (selectedDate != null) {
      setState(() {
        _currentMonth = selectedDate;
      });

      // ✅ Sync the page controller
      int newPage = _monthDifference(_baseDate, selectedDate);
      _pageController.jumpToPage(newPage);

      widget.onMonthChanged?.call(_currentMonth.month, _currentMonth.year);
    }
  }

  int _monthDifference(DateTime from, DateTime to) {
    return (to.year - from.year) * 12 + (to.month - from.month);
  }



  @override
  Widget build(BuildContext context) {
    List<DateTime> monthDays = CommonFunction().getDaysInMonth(_currentMonth);
    int weeksInMonth = (monthDays.length / 7).ceil();

    // ✅ Base height for regular rows
    calculatedHeight = weeksInMonth == 6 ? 370.0 : 313.0;

    // ✅ Adjust for claim screen's extra row
    if (widget.isFromClaimScreen && !widget.isFromHrScreen) {
      if (weeksInMonth == 6) {
        calculatedHeight += 85.0; // Add height for extra row (7 items)
      } else if (weeksInMonth == 5) {
        calculatedHeight += 80.0; // Slightly less if only 5 weeks
      }
    } else if (widget.isFromClaimScreen && widget.isFromHrScreen) {
      if (weeksInMonth == 6) {
        calculatedHeight += 0; // Add height for extra row (7 items)
      } else if (weeksInMonth == 5) {
        calculatedHeight += 0; // Slightly less if only 5 weeks
      }
    } else if (!widget.isFromClaimScreen && widget.isFromHrScreen) {
      if (weeksInMonth == 6) {
        calculatedHeight += 15; // Add height for extra row (7 items)
      } else if (weeksInMonth == 5) {
        calculatedHeight += 15; // Slightly less if only 5 weeks
      }
    } else if (!widget.isFromClaimScreen && !widget.isFromHrScreen) {
      if (weeksInMonth == 6) {
        calculatedHeight += 15; // Add height for extra row (7 items)
      } else if (weeksInMonth == 5) {
        calculatedHeight += 15; // Slightly less if only 5 weeks
      }
    }

    widget.onHeightCalculated(calculatedHeight);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 8, bottom: 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => _showMonthYearPicker(context),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/month_calendar_icon.svg',
                      height: 20,
                      width: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("MMMM - y").format(_currentMonth),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff5A5A5A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.isFromHrScreen) const SizedBox(height: 10),
        if (widget.isFromHrScreen)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                svgAsset: 'assets/icons/good_to_go.svg',
                text: 'Good To Go',
                onPressed: () {},
                isOutlined: true,
                width: 100,
                height: 29,
              ),
              const SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/hold.svg',
                text: 'Hold',
                onPressed: () {},
                isOutlined: true,
                width: 65,
                height: 29,
              ),
              const SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/rework.svg',
                text: 'Rework',
                onPressed: () {},
                isOutlined: true,
                width: 85,
                height: 29,
              ),
              const SizedBox(width: 5),
            ],
          ),
        const SizedBox(height: 10),
        calenderView(monthDays),
      ],
    );


  }

  Widget calenderView(List<DateTime> monthDays) {
    print('customDatacalender ${widget.customData}');
    print('backdatedClaim ${widget.backDatedClaims},${widget.selectedMonth}');
    final backdatedClaims = widget.backDatedClaims as Map<String, dynamic>? ?? {};
    print('blk1Map $backdatedClaims');
    return SizedBox(
      height: widget.isFromClaimScreen && !widget.isFromHrScreen
          ? calculatedHeight + 32
          : widget.isFromHrScreen && widget.isFromClaimScreen
              ? calculatedHeight +60
              : calculatedHeight,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWeekdayLabels(),
              _buildMonthlyCalender(monthDays),
              if (widget.isFromClaimScreen)
                Column(
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: const Color(0xffE0E0E0),
                      alignment: Alignment.center,
                      child: Text(
                        'Backdated Claims',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final blockKey = 'Blk ${index + 1}';
                        final blkMap = backdatedClaims[blockKey] as Map<String, dynamic>? ?? {};

                        List<String> valuesList = [];
                        if (blkMap.isNotEmpty) {
                          // Sort keys numerically and get values
                          final sortedKeys = blkMap.keys.toList()
                            ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));
                          valuesList = sortedKeys.map((k) => blkMap[k]?.toString() ?? '0').toList();
                        }

                        return Expanded(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white, // no background color change
                              border: Border(
                                bottom: BorderSide(width: 1, color: Color(0xffE8E8E8)),
                                left: BorderSide(width: 1, color: Color(0xffE8E8E8)),
                                right: BorderSide(width: 1, color: Color(0xffE8E8E8)),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: blkMap.isNotEmpty
                                ? RichText(
                              text: TextSpan(
                                children: List.generate(valuesList.length * 2 - 1, (i) {
                                  if (i.isEven) {
                                    // Number part
                                    final numIndex = i ~/ 2;
                                    final text = valuesList[numIndex];
                                    // Assign colors for each number differently (cycle colors if needed)
                                    final colors = [const Color(0xffB8E6D0), const Color(0xffE9BDBF), const Color(0xffFF9F2D)];
                                    final color = colors[numIndex % colors.length];
                                    return TextSpan(
                                      text: text,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    );
                                  } else {
                                    // Comma separator
                                    return const TextSpan(
                                      text: ' ',
                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                    );
                                  }
                                }),
                              ),
                            )
                                : const Text(
                              '', // empty if no data
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                    ),


                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWeekdayLabels() {
    List<String> weekdays = ["S", "M", "T", "W", "TH", "F", "S"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Row(
        children: weekdays.asMap().entries.map(
          (entry) {
            int index = entry.key;
            String day = entry.value;
            bool isLastColumn =
                index == weekdays.length - 1; // Check if it's the last column
            bool isFirstColumn = index == 0;
            return Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: isFirstColumn
                        ? const Radius.circular(8.0)
                        : Radius.zero,
                    topRight:
                        isLastColumn ? const Radius.circular(8.0) : Radius.zero,
                  ),
                  border: Border(
                    top: const BorderSide(width: 1, color: Color(0xffE8E8E8)),
                    bottom: const BorderSide(
                        width: 1, color: Color(0xffE8E8E8)), // Bottom border
                    left: const BorderSide(
                        width: 1, color: Color(0xffE8E8E8)), // Left border
                    right: isLastColumn
                        ? const BorderSide(width: 1, color: Color(0xffE8E8E8))
                        : BorderSide.none, // Right border only for last column
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: day == 'S'
                          ? const Color(0xff5A5A5A)
                          : const Color(0xff000000),
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  int getCalendarWeekday(DateTime date) {
    if (date.weekday == 1) {
      return 1; // Sunday as 1
    } else if (date.weekday == 7) {
      return 7;
    } // Saturday as 7
    else {
      return date.weekday;
    } // Other days remain same
  }

  Widget _buildMonthlyCalender(List<DateTime> monthDays) {
    final consultantState = ref.watch(consultantProvider);

    /// Ensure calendar starts from Sunday
    final DateTime firstDay = monthDays.first;
    int firstWeekday =
        firstDay.weekday % 7; // Make Sunday = 0, Monday = 1, ..., Saturday = 6
    List<DateTime> paddedMonthDays = [];

    // Add placeholders from previous month
    for (int i = firstWeekday - 1; i >= 0; i--) {
      paddedMonthDays.add(firstDay.subtract(Duration(days: i + 1)));
    }

    // Add actual month days
    paddedMonthDays.addAll(monthDays);

    // Add trailing placeholders to complete the grid (to make length % 7 == 0)
    while (paddedMonthDays.length % 7 != 0) {
      DateTime last = paddedMonthDays.last;
      paddedMonthDays.add(last.add(const Duration(days: 1)));
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0),
        child: GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.9,
          ),
          itemCount: paddedMonthDays.length,
          itemBuilder: (context, index) {
            final DateTime date = paddedMonthDays[index];
            final bool isFromCurrentMonth = monthDays.contains(date);
            final bool isLastColumn = (index + 1) % 7 == 0;
            final int calendarWeekday = getCalendarWeekday(date);

            return GestureDetector(
              onTap: () {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final tappedDate = DateTime(date.year, date.month, date.day);

                if (tappedDate.isAfter(today)) {
                  // Disable tap for future dates
                  print('Future date tapped: $tappedDate');
                  ToastHelper.showError(context, "You can't edit the future data");
                  return;
                }

                print('Tapped date is today or in the past: $tappedDate');
                if (!widget.isFromHrScreen &&
                    consultantState.isEditable &&
                    isFromCurrentMonth) {
                  String dateRange =
                  DateFormat('dd / MM / yyyy').format(date).toString();
                  bottomSheetWidget(context, dateRange);
                } else {
                  popupBottomSheetWidget(context, date,
                      widget.selectedMonth.toString(),
                      widget.selectedYear.toString());
                }
              },

              child: Container(
                padding: const EdgeInsets.only(top: 6, left: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom:
                        const BorderSide(width: 1, color: Color(0xffE8E8E8)),
                    left: const BorderSide(width: 1, color: Color(0xffE8E8E8)),
                    right: isLastColumn
                        ? const BorderSide(width: 1, color: Color(0xffE8E8E8))
                        : BorderSide.none,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date.day.toString().padLeft(2, '0'),
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isFromCurrentMonth
                            ? const Color(0xff969696)
                            : const Color(0xffD0D0D0), // greyed out
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (widget.customData.containsKey(date) &&
                        !widget.isFromClaimScreen &&
                        calendarWeekday != 7 && // Not Sunday
                        calendarWeekday != 6) // Not Saturday
                      widget.customData[date]!.widget,
                    if (widget.customData.containsKey(date) &&
                        widget.isFromClaimScreen)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.customData[date]!.map<Widget>((entry) {
                          return Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: entry['color'],
                              shape: BoxShape.circle,
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
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
              // _onClose();
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

  Widget _buildBackdatedCell(int index, bool isLastColumn) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: const BorderSide(width: 1, color: Color(0xffE8E8E8)),
          left: const BorderSide(width: 1, color: Color(0xffE8E8E8)),
          right: isLastColumn
              ? const BorderSide(width: 1, color: Color(0xffE8E8E8))
              : BorderSide.none,
        ),
      ),
      child: const SizedBox.shrink(), // or placeholder content
    );
  }


  void popupBottomSheetWidget(
      BuildContext context,
      DateTime date,
      String selectedMonth,
      String selectedYear,
      ) {
    print('inside the popup ${widget.claimsDetails}');
    final String dateStr = DateFormat('yyyy-MM-dd').format(date);

    final matchedClaims = widget.claimsDetails
        ?.map((claim) {
      final entries = claim['entries'] as List<dynamic>;
      final filteredEntries = entries
          .where((entry) => entry['date'] == dateStr)
          .toList();

      if (filteredEntries.isNotEmpty) {
        return {
          'claim': claim,
          'entries': filteredEntries,
        };
      }
      return null;
    })
        .whereType<Map<String, dynamic>>()
        .toList();

    if (matchedClaims == null || matchedClaims.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(10),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Claims',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Image.asset('assets/icons/close.png', height: 25),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ...matchedClaims.map((item) {
                  final claim = item['claim'];
                  final entries = item['entries'];

                  final totalAmount = entries.fold<double>(
                    0.0,
                        (double sum, dynamic entry) =>
                    sum + (double.tryParse(entry['amount'].toString()) ?? 0.0),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile + Claim Info
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 24,
                              backgroundImage: AssetImage("assets/images/profile.jpg"),
                              backgroundColor: Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Bruce Lee",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: const Color(0xff2A282F))),
                                  Text("Employee Id : Emp14982",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: const Color(0xffA8A6AC))),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Claim Form",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: const Color(0xff2A282F))),
                                Text(claim['claim_no'],
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: const Color(0xff2A282F))),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Text(
                          "Individual Claims ( ${claim['count'] ?? entries.length} )",
                          style: GoogleFonts.montserrat(
                              color: const Color(0xffFF1901),
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount : ₹${totalAmount.toStringAsFixed(2)}",
                              style: GoogleFonts.montserrat(
                                  color: const Color(0xff1D212D),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 13,
                                    height: 13,
                                    decoration: const BoxDecoration(
                                        color: Color(0xff007BFF),
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(claim['status'] ?? '',
                                      style: const TextStyle(color: Color(0xff007BFF))),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          thickness: 1,
                        ),

                        // Show entry list
                        ExpenseListView(
                          isFromHrScreen:widget.isFromHrScreen,
                          entries: entries,
                          selectedMonth: selectedMonth,
                          selectedYear: selectedYear,
                        ),
                      ],
                    ),
                  );
                }).toList()
              ],
            ),
          ),
        );
      },
    );
  }

}
