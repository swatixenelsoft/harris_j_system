// import 'package:calenderapp/widgets/bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/consultant/consultant_timesheet_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
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
    this.onMonthChanged,
    this.onDataUpdated,
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
      print('rehjdshfj');
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
              SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/hold.svg',
                text: 'Hold',
                onPressed: () {},
                isOutlined: true,
                width: 65,
                height: 29,
              ),
              SizedBox(width: 5),
              CustomButton(
                svgAsset: 'assets/icons/rework.svg',
                text: 'Rework',
                onPressed: () {},
                isOutlined: true,
                width: 85,
                height: 29,
              ),
              SizedBox(width: 5),
            ],
          ),
        const SizedBox(height: 10),
        calenderView(monthDays),
      ],
    );
  }

  Widget calenderView(List<DateTime> monthDays) {
    print('customDatacalender ${widget.customData}');
    return SizedBox(
      height: widget.isFromClaimScreen
          ? calculatedHeight + 15
          : !widget.isFromHrScreen
              ? calculatedHeight
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
              if (widget.isFromClaimScreen && !widget.isFromHrScreen)
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
                        return Expanded(
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              // BorderSide(width: 1, color: Color(0xffE8E8E8)),
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffE8E8E8)),
                                  left: BorderSide(
                                      width: 1, color: Color(0xffE8E8E8)),
                                  right: BorderSide(
                                      width: 1, color: Color(0xffE8E8E8))),
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
                print('ghfj ${widget.customData[date]}');
                if (!widget.isFromHrScreen &&
                    consultantState.isEditable &&
                    isFromCurrentMonth) {
                  String dateRange =
                      DateFormat('dd / MM / yyyy').format(date).toString();

                  bottomSheetWidget(context, dateRange);
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
}
