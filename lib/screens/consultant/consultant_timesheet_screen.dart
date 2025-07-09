import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/services/api_constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeSheetScreen extends ConsumerStatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  ConsumerState<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends ConsumerState<TimeSheetScreen> {
  int activeIndex = 0;
  double calendarHeight = 350;
  String? token;
  bool isEmployeeDetail = false;
  bool _isEditable = false;

  TextEditingController _corporateEmail = TextEditingController();
  TextEditingController _reportingManagerEmail = TextEditingController();

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  String status = 'Draft';

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon6.svg',
  ];

  final List<String> tabsData = [
    "Timesheet Overview",
    "Extra Time Log",
    "Pay-off Log",
    "Comp-off log",
    "Get Copies"
  ];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _getConsultantTimeSheet();
    });
  }

  Future<void> _getConsultantTimeSheet() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    // Load all data
    await ref.read(consultantProvider.notifier).consultantTimeSheet(
        token!, selectedMonth.toString(), selectedYear.toString());

    await ref.read(consultantProvider.notifier).consultantTimesheetRemarks(
        ApiConstant.getTimesheetRemarks,
        token!,
        selectedMonth.toString(),
        selectedYear.toString());

    await ref.read(consultantProvider.notifier).consultantLeaveWorkLog(
        token!, selectedMonth.toString(), selectedYear.toString());

    // ✅ Now data is guaranteed to be present
    final consultantState = ref.read(consultantProvider);
    final status =
        getStatusForMonth(consultantState, selectedMonth, selectedYear);
    print('Status after fetching: $status');

    if (mounted) {
      setState(() {
        switch (status) {
          case null:
          case 'Draft':
            activeIndex = 0;
            break;
          case 'Submitted':
            activeIndex = 1;
            break;
          case 'Rejected':
            activeIndex = 3;
            break;
          case 'Approved':
            activeIndex = 4;
            break;
          case 'Rework':
            activeIndex = 5;
            break;
          default:
            activeIndex = 1; // Fallback
        }
      });
    }
  }

  Map<DateTime, CalendarData> parseTimelineData(List<dynamic> apiResponse) {
    final Map<DateTime, CalendarData> calendarData = {};

    if ((apiResponse).isNotEmpty) {
      final List dataList = apiResponse;

      // Loop through all items in the data list
      for (var dataItem in dataList) {
        status = dataItem['status'];

        final days = dataItem['days'];
        if (days == null || days is! List) continue;

        for (var dayData in days) {
          final details = dayData['details'] ?? {};
          final dateStr = details['date']; // e.g., "05 / 05 / 2025"
          if (dateStr == null) continue;

          final parts = dateStr.split(' / ');
          if (parts.length != 3) continue;

          final day = int.tryParse(parts[0].trim());
          final month = int.tryParse(parts[1].trim());
          final year = int.tryParse(parts[2].trim());
          if (day == null || month == null || year == null) continue;

          final dateKey = DateTime(year, month, day);
          if (details.containsKey('leaveType') &&
              details['leaveType'] != null) {
            final leaveType = details['leaveType'].toString();
            final leaveHour = details['leaveHour']?.toString();

            bool isCustom = leaveType.startsWith('Custom ');
            String shortLeaveType = isCustom
                ? leaveType.replaceFirst('Custom ', '').toUpperCase()
                : leaveType.toUpperCase();

            String? suffix;

            // Check for HD1/HD2 suffix
            if (leaveHour == 'First half workday (HD1)') {
              suffix = 'HD1';
            } else if (leaveHour == 'Second half workday (HD2)') {
              suffix = 'HD2';
            } else if (isCustom) {
              suffix = 'cust';
            }

            // Show RichText for Custom or ML/AL with HD1/HD2
            if (isCustom ||
                ((shortLeaveType == 'ML' || shortLeaveType == 'AL') &&
                    suffix != null)) {
              calendarData[dateKey] = CalendarData(
                widget: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: shortLeaveType,
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff007BFF),
                        ),
                      ),
                      WidgetSpan(
                        child: Transform.translate(
                          offset: const Offset(-2, -6),
                          child: Text(
                            suffix!,
                            textScaleFactor: 0.7,
                            style: GoogleFonts.montserrat(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xff007BFF),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                type: 'leave',
              );
            } else {
              // Regular leave text
              calendarData[dateKey] = CalendarData(
                widget: Text(
                  shortLeaveType,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff007BFF),
                  ),
                ),
                type: 'leave',
              );
            }
          }

          // Work case
          else if (details.containsKey('workingHours') &&
              details['workingHours'] != null) {
            final workingHours = details['workingHours'].toString();
            calendarData[dateKey] = CalendarData(
              widget: Text(
                workingHours,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: int.parse(workingHours) != 8
                      ? const Color(0xffFF1901)
                      : const Color(0xff000000),
                ),
              ),
              type: 'work',
            );
          }
        }
      }
    }

    return calendarData;
  }

  void _refreshData() async {
    if (token != null) {
      await ref.read(consultantProvider.notifier).consultantTimeSheet(
            token!,
            selectedMonth.toString(),
            selectedYear.toString(),
          );
      await ref.read(consultantProvider.notifier).consultantTimesheetRemarks(
            ApiConstant.getTimesheetRemarks,
            token!,
            selectedMonth.toString(),
            selectedYear.toString(),
          );
      await ref.read(consultantProvider.notifier).consultantLeaveWorkLog(
            token!,
            selectedMonth.toString(),
            selectedYear.toString(),
          );
    }
    setState(() {});
    print('refresh $selectedMonth');
  }

  Future<void> _saveTimesheet(GetConsultantState consultantState) async {
    try {
      // ✅ Start loader
      ref.read(consultantProvider.notifier).setLoading(true);

      String monthName =
          DateFormat.MMMM().format(DateTime(selectedYear, selectedMonth));
      String selectedMonthString = '$monthName $selectedYear';
      List data = consultantState.consultantTimeSheet!['data'];

      Map<String, dynamic>? selectedMonthData = data.firstWhere(
        (monthData) => monthData['month'].toString() == selectedMonthString,
        orElse: () => null,
      );

      List days = selectedMonthData != null ? selectedMonthData['days'] : [];

      final filtered = days.where((day) {
        final details = day['details'];
        return details != null &&
            (details.containsKey('workingHours') ||
                details['leaveType'] == 'PH');
      }).map((day) {
        final details = day['details'];
        return {
          'date': details['date'],
          details.containsKey('workingHours') ? 'workingHours' : 'leaveType':
              details.containsKey('workingHours')
                  ? details['workingHours']
                  : details['leaveType'],
          'applyOnCell': details['applyOnCell'] ?? details['date'],
        };
      }).toList();

      log('filtered ${jsonEncode(filtered)}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');

      const type = 'timesheet';
      const clientId = '1';
      const clientName = "Xenelsoft";
      const status = 'Draft';
      final record = filtered;
      const corporateEmail = "";
      const reportingManagerEmail = "";
      const certificate = null;

      print('Saving timesheet data...');

      final response =
          await ref.read(consultantProvider.notifier).addTimesheetData(
                token!,
                userId.toString(),
                type,
                clientId,
                clientName,
                status,
                record,
                corporateEmail,
                reportingManagerEmail,
                "", // selectMonth is not required for save
                "", // selectYear is not required for save
                certificate,
              );

      if (response['success']) {
        // Optional success UI update
        ToastHelper.showSuccess(context, 'TimeSheet saved successfully!');
        setState(() {});
      }
      print('timesheetaddresponse $response');
    } catch (e) {
      print('❌ Save error: $e');
    } finally {
      // ✅ Stop loader
      ref.read(consultantProvider.notifier).setLoading(false);
    }
  }

  Future<void> _submitTimesheet(GetConsultantState consultantState) async {
    if (_corporateEmail.text.isEmpty || _reportingManagerEmail.text.isEmpty) {
      ToastHelper.showError(
          context, 'Please add corporate email and reporting manager email');
      return;
    }

    try {
      // Start loader
      ref.read(consultantProvider.notifier).setLoading(true);

      String monthName =
          DateFormat.MMMM().format(DateTime(selectedYear, selectedMonth));
      String selectedMonthString = '$monthName $selectedYear';
      List data = consultantState.consultantTimeSheet!['data'];

      Map<String, dynamic>? selectedMonthData = data.firstWhere(
        (monthData) => monthData['month'].toString() == selectedMonthString,
        orElse: () => null,
      );

      List days = selectedMonthData != null ? selectedMonthData['days'] : [];

      final filtered = days.where((day) {
        final details = day['details'];
        return details != null &&
            (details.containsKey('workingHours') ||
                details['leaveType'] == 'PH');
      }).map((day) {
        final details = day['details'];
        return {
          'date': details['date'],
          details.containsKey('workingHours') ? 'workingHours' : 'leaveType':
              details.containsKey('workingHours')
                  ? details['workingHours']
                  : details['leaveType'],
          'applyOnCell': details['applyOnCell'] ?? details['date'],
        };
      }).toList();

      log('filtered ${jsonEncode(filtered)}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');

      const type = 'timesheet';
      const clientId = '1';
      const clientName = "Xenelsoft";
      const status = 'Submitted';
      final record = filtered;
      final corporateEmail = _corporateEmail.text;
      final reportingManagerEmail = _reportingManagerEmail.text;
      const certificate = null;

      print('Submitting timesheet...');
      final response =
          await ref.read(consultantProvider.notifier).addTimesheetData(
                token!,
                userId.toString(),
                type,
                clientId,
                clientName,
                status,
                record,
                corporateEmail,
                reportingManagerEmail,
                selectedMonth.toString(),
                selectedYear.toString(),
                certificate,
              );

      if (response['success']) {
        ToastHelper.showSuccess(context, 'TimeSheet submitted successfully!');

        // ✅ ADDITIONAL LOGIC AFTER SUCCESS
        final consultantState = ref.read(consultantProvider);
        final status = getStatusForMonth(
          consultantState,
          selectedMonth,
          selectedYear,
        );
        print('Status after month change: $status');

        if (mounted) {
          setState(() {
            activeIndex = 1;
          });
        }
      }

      print('timesheetaddresponse $response');
    } catch (e) {
      print('❌ Submit error: $e');
    } finally {
      isEmployeeDetail = false;
      _reportingManagerEmail.clear();
      _corporateEmail.clear();
      ref.read(consultantProvider.notifier).setLoading(false);
    }
  }

  String? getStatusForMonth(
      GetConsultantState consultantState, int month, int year) {
    final targetMonth = DateFormat('MMMM yyyy').format(DateTime(year, month));

    final dataList = consultantState.consultantTimeSheet?['data'];
    if (dataList is List) {
      final matchingEntry = dataList.firstWhere(
        (entry) => entry['month'] == targetMonth,
        orElse: () => null,
      );

      return matchingEntry?['status'];
    }

    return null; // or "Unknown"
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(consultantProvider);

    if (consultantState.isLoading) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CustomLoader(color: Color(0xffFF1901)),
          ),
        ),
      );
    }
    final customData =
        parseTimelineData(consultantState.consultantTimeSheet?['data']);
    print('selecte monhth and year $selectedMonth,$selectedYear');
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomAppBar(
                    showBackButton: false,
                    image: 'assets/icons/cons_logo.png',
                    onProfilePressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      context.pushReplacement(Constant.login);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: _buildHeaderContent(consultantState)),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: FixedHeaderDelegate(
                  height: 80 + calendarHeight,
                  activeIndex: activeIndex,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
                        width: double.infinity,
                        color: const Color(0xffF5F5F5),
                        child: _stepperUI(
                          context,
                          iconData,
                          activeIndex,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 7,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: CalendarScreen(
                          selectedMonth: selectedMonth,
                          selectedYear: selectedYear,
                          onHeightCalculated: _updateCalendarHeight,
                          customData: customData,
                          onMonthChanged: (month, year) async {
                            setState(() {
                              selectedMonth = month;
                              selectedYear = year;
                            });

                            _refreshData();

                            final consultantState =
                                ref.read(consultantProvider);
                            final status = getStatusForMonth(
                                consultantState, selectedMonth, selectedYear);
                            print('Status after month change: $status');

                            if (mounted) {
                              setState(() {
                                switch (status) {
                                  case null:
                                  case 'Draft':
                                    activeIndex = 0;
                                    break;
                                  case 'Submitted':
                                    activeIndex = 1;
                                    break;
                                  case 'Rejected':
                                    activeIndex = 3;
                                    break;
                                  case 'Approved':
                                    activeIndex = 4;
                                    break;
                                  case 'Rework':
                                    activeIndex = 5;
                                    break;
                                  default:
                                    activeIndex = 1; // Fallback
                                }
                              });
                            }
                          },
                          onDataUpdated: _refreshData,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                    height: 180,
                    child: CustomTabView(consultantState: consultantState)),
                const SizedBox(height: 10),
                _buildRemarksSection(consultantState),
                const SizedBox(height: 30),
                _buildBottomTabView(tabsData, consultantState),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(consultantState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderActions(consultantState),
          if (isEmployeeDetail) const SizedBox(height: 15),
          if (isEmployeeDetail) _buildEmployeeInfo(),
          if (isEmployeeDetail) const SizedBox(height: 15),
          if (isEmployeeDetail) _buildManagerInfo(),
        ],
      ),
    );
  }

  Widget _buildHeaderActions(GetConsultantState consultantState) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset('assets/icons/back.svg', height: 15)),
        const Spacer(),

// --- Buttons Row ---
        GestureDetector(
          onTap: activeIndex != 0
              ? null // 👈 disables tap
              : () {
                  setState(() {
                    consultantState.isEditable =
                        !(consultantState.isEditable ?? false);
                  });

                  ToastHelper.showInfo(
                    context,
                    consultantState.isEditable
                        ? "Edit Enabled"
                        : "Edit Disabled",
                  );

                  print('isEdit ${consultantState.isEditable}');
                },
          child: Opacity(
            opacity: activeIndex != 0 ? 0.5 : 1.0, // 👈 visual feedback
            child: SvgPicture.asset('assets/icons/edit_icon.svg'),
          ),
        ),
        const SizedBox(width: 10),
        Opacity(
          opacity: activeIndex != 0 ? 0.5 : 1.0,
          child: CustomButton(
            text: 'Save',
            width: 85,
            height: 36,
            borderRadius: 8,
            onPressed: () {
              activeIndex != 0 ? null : _saveTimesheet(consultantState);
            },
            isOutlined: true,
            svgAsset: 'assets/icons/save.svg',
          ),
        ),
        const SizedBox(width: 7),
        Opacity(
          opacity: activeIndex != 0 ? 0.5 : 1.0,
          child: CustomButton(
            text: 'Submit',
            width: 100,
            height: 36,
            borderRadius: 8,
            onPressed: () {
              activeIndex != 0 ? null : _submitTimesheet(consultantState);
            },
          ),
        ),
        const SizedBox(width: 7),
        GestureDetector(
          onTap: () {
            setState(() {
              isEmployeeDetail = !isEmployeeDetail;
            });
          },
          child: Icon(
            isEmployeeDetail
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoColumn('Employee ID :', 'Emp14982'),
        _buildInfoColumn('Client Name :', 'Encore Films'),
      ],
    );
  }

  Widget _buildManagerInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoColumn(
          'Employee Name : ',
          'Miss. Tiana Calzoni',
        ),
        const SizedBox(height: 10),
        CustomTextField(
            hintText: "Enter your corporate email-id",
            label: 'Corporate email-id',
            controller: _corporateEmail),
        const SizedBox(height: 10),
        CustomTextField(
            hintText: "Enter your reporting manager email-id",
            label: 'Reporting manager email-id',
            controller: _reportingManagerEmail),
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _infoTextStyle(const Color(0xff8D8F92))),
        const SizedBox(height: 1),
        Text(value, style: _infoTextStyle(Colors.black)),
      ],
    );
  }

  TextStyle _infoTextStyle(Color color) {
    return GoogleFonts.montserrat(
        fontSize: 14, fontWeight: FontWeight.w500, color: color);
  }

  Widget _buildRemarksSection(GetConsultantState consultantState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(consultantState: consultantState),
    );
  }

  Widget _buildBottomTabView(tabsData, GetConsultantState consultantState) {
    return Container(
      height: 260,
      decoration: containerBoxDecoration(null, const Offset(2, 4)),
      child: Stack(
        children: [
          BottomTabView(tabsData: tabsData, consultantState: consultantState),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 40.0,
              height: 50,
              color: Colors.white,
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded,
                        size: 20, color: Colors.black),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 20, color: Colors.black)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration containerBoxDecoration(
      [Color? color, Offset shadowOffset = const Offset(0, 2)]) {
    return BoxDecoration(
      color: color, // If color is null, it will be transparent (default)
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4,
          offset: shadowOffset,
        ),
      ],
    );
  }

  Widget _stepperUI(
      BuildContext context, List<String> svgIcons, int activeIndex) {
    print('Rendering stepper with activeIndex: $activeIndex');

    return KeyedSubtree(
      key: ValueKey(activeIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(svgIcons.length, (index) {
          Color backgroundColor = Colors.white;
          Color borderColor = const Color(0xffA1AEBE);
          Color iconColor = Colors.black;

          if (index < activeIndex) {
            // ✅ Completed step
            backgroundColor = const Color(0xFF007BFF); // Blue
            borderColor = const Color(0xFF007BFF);
            iconColor = Colors.white;
          } else if (index == activeIndex) {
            // ✅ Active step
            switch (index) {
              case 1:
              case 4:
                backgroundColor = const Color(0xFFFFC107); // Yellow
                borderColor = const Color(0xFFFFC107);
                iconColor = Colors.white;
                break;
              case 5:
                backgroundColor = const Color(0xFF28A745); // Green
                borderColor = const Color(0xFF28A745);
                iconColor = Colors.white;
                break;
              case 6:
                backgroundColor = const Color(0xFFDA6536); // Orange
                borderColor = const Color(0xFFDA6536);
                iconColor = Colors.white;
                break;
              case 3:
                backgroundColor = Colors.red.shade400; // Red
                borderColor = Colors.red.shade400;
                iconColor = Colors.white;
                break;
              case 0:
                backgroundColor = Colors.blue;
                borderColor = Colors.blue;
                iconColor = Colors.white;
                break;
              default:
                backgroundColor = Colors.blue;
                borderColor = Colors.blue;
                iconColor = Colors.white;
            }
          }
          // else => upcoming step: remains white

          return Row(
            children: [
              if (index != 0)
                SizedBox(
                  width: 38,
                  child: Divider(
                    color: index <= activeIndex
                        ? Colors.blue
                        : const Color(0xffA1AEBE),
                    thickness: 2,
                    endIndent: 2,
                    indent: 2,
                  ),
                ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final int activeIndex;

  FixedHeaderDelegate({
    required this.child,
    required this.height,
    required this.activeIndex,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant FixedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height ||
        activeIndex != oldDelegate.activeIndex ||
        oldDelegate.child.key != child.key;
  }
}

class CalendarData {
  final Widget widget;
  final String type; // e.g., 'leave', 'work', etc.

  CalendarData({required this.widget, required this.type});
}
