// import 'package:calenderapp/widgets/bottom_sheet_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/timesheet_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/widgets/bottom_sheet_content.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  final Function(double) onHeightCalculated;
 final Map<DateTime, dynamic> customData;
 final bool isFromClaimScreen;

  const CalendarScreen({super.key,required this.onHeightCalculated,required this.customData,  this.isFromClaimScreen = false,});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
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
  String dateRange="19 / 03 / 2025 - 19 / 03 /2025";

  late double calculatedHeight;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage: 500);// Large value for infinite scrolling effect

    // WidgetsBinding.instance.addPostFrameCallback((_) => _calculateAndSendHeight());
  }

  void _onPageChanged(int index) {
    setState(() {
      int monthDifference = index - 500;
      _currentMonth = DateTime(
          DateTime.now().year, DateTime.now().month + monthDifference, 1);
    });
    // List<DateTime> monthDays = CommonFunction().getDaysInMonth(_currentMonth);
    // int weeksInMonth = (monthDays.length / 7).ceil();
    // print('weeksInMonth $weeksInMonth');
    // calculatedHeight= weeksInMonth == 6 ? 390.0 : 330.0;
  }

  void bottomSheetWidget(BuildContext context,date) async{
    Widget bottomSheetToShow;

    final CalendarData? data = widget.customData[date];

    if (data != null) {
      switch (data.type.toLowerCase()) {
        case 'leave':
          bottomSheetToShow = LeaveBottomSheetContent(
            startValue: startValue,
            endValue: endValue,
            selectedOption: selectedOption,
            dateRange:date,
              isFromClaimScreen: widget.isFromClaimScreen,
          );
          break;
        case 'work':
          bottomSheetToShow = LeaveBottomSheetContent(
            startValue: startValue,
            endValue: endValue,
            selectedOption: selectedOption,
            dateRange:date,
            isFromClaimScreen: widget.isFromClaimScreen,
          );
          break;

        default:
          bottomSheetToShow = LeaveBottomSheetContent(
            startValue: startValue,
            endValue: endValue,
            selectedOption: selectedOption,
            dateRange:date,
            isFromClaimScreen: widget.isFromClaimScreen,
          );
      }
    } else {
      bottomSheetToShow = Container(

      );
    }


    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true, // Ensures modal can expand properly
      isDismissible: true,
      enableDrag: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return bottomSheetToShow;

        });
      },
    );
    if (result != null) {
      print('result $result');
      setState(() {
        startValue = result['startValue'] as double;
        endValue = result['endValue'] as double;
        selectedOption = result['selectedOption'] as String;

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> monthDays = CommonFunction().getDaysInMonth(_currentMonth);
    int weeksInMonth = (monthDays.length / 7).ceil();

    // ✅ Base height for regular rows
    calculatedHeight = weeksInMonth == 6 ? 390.0 : 330.0;

    // ✅ Adjust for claim screen's extra row
    if (widget.isFromClaimScreen) {
      if (weeksInMonth == 6) {
        calculatedHeight += 65.0; // Add height for extra row (7 items)
      } else if (weeksInMonth == 5) {
        calculatedHeight += 60.0; // Slightly less if only 5 weeks
      }
    }

    widget.onHeightCalculated(calculatedHeight);
    print('calculatedHeight333 $calculatedHeight');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
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
        const SizedBox(height: 10),
        calenderView(monthDays),
      ],
    );
  }


  Widget calenderView(List<DateTime> monthDays) {
    // int weeksInMonth = (monthDays.length / 7).ceil();
    // double calendarHeight = weeksInMonth == 6 ? 400 : 330; // Adjust as needed

    return SizedBox(
      height: calculatedHeight,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildWeekdayLabels(),
              _buildMonthlyCalender(monthDays),

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


  Widget _buildMonthlyCalender(List<DateTime> monthDays) {
    bool hasShownBackdatedLabel = false;

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
          itemCount: () {
            int baseCount = (monthDays.length % 7 == 0)
                ? monthDays.length
                : monthDays.length + (7 - (monthDays.length % 7));
            return widget.isFromClaimScreen ? baseCount + 7 : baseCount;
          }(),
          itemBuilder: (context, index) {
            DateTime? date;
            bool isPlaceholder = false;

            int baseCount = (monthDays.length % 7 == 0)
                ? monthDays.length
                : monthDays.length + (7 - (monthDays.length % 7));
            bool isBackdatedRow = widget.isFromClaimScreen && index >= baseCount;

            if (index < monthDays.length) {
              date = monthDays[index];
            } else if (!isBackdatedRow) {
              int extraDayIndex = index - monthDays.length + 1;
              date = DateTime(
                monthDays.last.year,
                monthDays.last.month + 1,
                extraDayIndex,
              );
              isPlaceholder = true;
            }

            bool isLastColumn = (index + 1) % 7 == 0;

            if (isBackdatedRow) {
              Widget labelWidget = const SizedBox.shrink();

              if (!hasShownBackdatedLabel) {
                hasShownBackdatedLabel = true;
                labelWidget = Container(
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
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  labelWidget,
                  _buildBackdatedCell(index, isLastColumn),
                ],
              );
            }

            Color containerColor = widget.isFromClaimScreen
                ? getClaimColorForDate(date!)
                : Colors.white;

            return GestureDetector(
              onTap: () {
                dateRange = DateFormat('dd / MM / yyyy').format(date!).toString();
                bottomSheetWidget(context, dateRange);
              },
              child: Container(
                padding: const EdgeInsets.only(top: 6, left: 10),
                decoration: BoxDecoration(
                  // color: containerColor,
                  border: Border(
                    bottom: const BorderSide(width: 1, color: Color(0xffE8E8E8)),
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
                      date!.day.toString().padLeft(2, '0'),
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff969696),
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (widget.customData.containsKey(date) &&
                        !widget.isFromClaimScreen)
                      widget.customData[date]!.widget,
                    if (widget.customData.containsKey(date) &&
                        widget.isFromClaimScreen)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: widget.customData[date]!.map<Widget>((entry) {
                          return Container(
                            width: 8,
                            height: 8,
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




  Color getClaimColorForDate(DateTime date) {
    final list = widget.customData[date];
    if (list != null && list.isNotEmpty) {
      return list.first['color'] ?? Colors.white; // You can customize logic here
    }
    return Colors.white;
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