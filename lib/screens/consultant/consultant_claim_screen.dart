import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/services/api_constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'consultant_timesheet_screen.dart';

class ClaimScreen extends ConsumerStatefulWidget {
  const ClaimScreen({super.key});

  @override
  ConsumerState<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends ConsumerState<ClaimScreen> {
  int activeIndex = 0;
  double calendarHeight = 350;
  String? token;
  int? userId;

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool isEmployeeDetail = false;
  TextEditingController _corporateEmail = TextEditingController();
  TextEditingController _reportingManagerEmail = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _getConsultantTimeSheet();
    });
  }

  Future<void> _getConsultantTimeSheet() async {
    final prefs = await SharedPreferences.getInstance();
    userId=prefs.getInt('userId');
    token = prefs.getString('token');
    await ref.read(consultantProvider.notifier).consultantClaimSheet(token!);
    await ref.read(consultantProvider.notifier).consultantTimesheetRemarks(
          ApiConstant.getClaimRemarks,
          token!,
          selectedMonth.toString(),
          selectedYear.toString(),
        );

    await ref.read(consultantProvider.notifier).consultantClaimAndCopies(
          token!,
          selectedMonth.toString(),
          selectedYear.toString(),
        );

    await ref.read(consultantProvider.notifier).backDatedClaims(
      userId.toString(),
      selectedMonth.toString(),
      selectedYear.toString(),
      token!
    );

    // ✅ Now data is guaranteed to be present
    final consultantState = ref.read(consultantProvider);
    final status =
        getStatusForMonth(consultantState, selectedMonth, selectedYear);

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

  String? getStatusForMonth(
      GetConsultantState consultantState, int month, int year) {
    final targetMonth = DateFormat('MMMM yyyy').format(DateTime(year, month));

    final dataList = consultantState.consultantClaimSheet?['data'];
    if (dataList is List) {
      final matchingEntry = dataList.firstWhere(
        (entry) => entry['month'] == targetMonth,
        orElse: () => null,
      );

      return matchingEntry?['status'];
    }

    return null; // or "Unknown"
  }

  Map<DateTime, List<Map<String, dynamic>>> parseTimelineData(
      List<dynamic> json) {
    final Map<DateTime, List<Map<String, dynamic>>> customData = {};

    final List dataList = json;

    for (var item in dataList) {
      final List days = item['days'] ?? [];

      for (var day in days) {
        final int? dayNum = day['day'];
        final String? type = day['type'];
        final int? id = day['id'];
        final String? expenseType = day['details']?['expenseType'];

        if (dayNum == null || (type != 'claims' && type != 'timesheet'))
          continue;

        // Determine color based on expenseType or type
        Color color;
        switch ((expenseType ?? type)?.toLowerCase()) {
          case 'taxi':
            color = const Color(0xffB8E6D0);
            break;
          case 'dining':
            color = const Color(0xffE9BDBF);
            break;
          case 'others':
            color = const Color(0xffFF9F2D);
            break;
          default:
            color = Colors.grey;
        }

        final dateKey = DateTime(
          DateTime.parse(item['start_date']).year,
          DateTime.parse(item['start_date']).month,
          dayNum,
        );

        customData.putIfAbsent(dateKey, () => []).add({
          'type': (expenseType ?? type)?.toLowerCase(),
          'color': color,
          'id': id,
        });
      }
    }

    return customData;
  }

  final List<String> tabsData = ["Claims", "Get Copies"];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
      }
    });
  }

  _refreshData() async {
    if (token != null) {
      await ref.read(consultantProvider.notifier).backDatedClaims(
          userId.toString(),
          selectedMonth.toString(),
          selectedYear.toString(),
          token!
      );
      await ref.watch(consultantProvider.notifier).consultantClaimSheet(
            token!,
          );

      await ref.read(consultantProvider.notifier).consultantTimesheetRemarks(
            ApiConstant.getClaimRemarks,
            token!,
            selectedMonth.toString(),
            selectedYear.toString(),
          );

      await ref.read(consultantProvider.notifier).consultantClaimAndCopies(
            token!,
            selectedMonth.toString(),
            selectedYear.toString(),
          );


    }
    setState(() {});
  }

  Future<void> _saveClaims(GetConsultantState consultantState) async {
    try {
      // ✅ Start loader
      ref.read(consultantProvider.notifier).setLoading(true);

      String monthName =
          DateFormat.MMMM().format(DateTime(selectedYear, selectedMonth));
      String selectedMonthString = '$monthName $selectedYear';
      List data = consultantState.consultantClaimSheet!['data'];

      Map<String, dynamic>? selectedMonthData = data.firstWhere(
        (monthData) => monthData['month'].toString() == selectedMonthString,
        orElse: () => null,
      );

      List days = selectedMonthData != null ? selectedMonthData['days'] : [];

      final filtered = days.where((day) {
        final details = day['details'];
        return details != null && (details.containsKey('expenseType'));
      }).map((day) {
        final details = day['details'];
        return details;
      }).toList();

      log('filtered ${jsonEncode(filtered)}');

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');

      const type = 'claims';
      const clientId = '6';
      const clientName = "HardikPandyaClient";
      const status = 'Draft';
      final record = filtered;
      const corporateEmail = "";
      const reportingManagerEmail = "";
      const certificate = null;

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
            selectedMonth.toString(), // selectMonth is not required for save
            selectedYear.toString(), // selectYear is not required for save
            certificate,
          );

      if (response['success']) {
        // Optional success UI update
        ToastHelper.showSuccess(context, 'Claims saved successfully!');

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

  Future<void> _submitClaims(GetConsultantState consultantState) async {
    if (_corporateEmail.text.isEmpty || _reportingManagerEmail.text.isEmpty) {
      ToastHelper.showError(
          context, 'Please add corporate email and reporting manager email');
    } else {
      try {
        // Start loader
        ref.read(consultantProvider.notifier).setLoading(true);

        String monthName =
            DateFormat.MMMM().format(DateTime(selectedYear, selectedMonth));
        String selectedMonthString = '$monthName $selectedYear';
        List data = consultantState.consultantClaimSheet!['data'];

        Map<String, dynamic>? selectedMonthData = data.firstWhere(
          (monthData) => monthData['month'].toString() == selectedMonthString,
          orElse: () => null,
        );

        List days = selectedMonthData != null ? selectedMonthData['days'] : [];

        final filtered = days.where((day) {
          final details = day['details'];
          return details != null && (details.containsKey('expenseType'));
        }).map((day) {
          final details = day['details'];
          return details;
        }).toList();

        log('filtered ${jsonEncode(filtered)}');

        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final userId = prefs.getInt('userId');

        const type = 'claims';
        const clientId = '6';
        const clientName = "HardikPandyaClient";
        const status = 'Submitted';
        final record = filtered;
        final corporateEmail = _corporateEmail.text;
        final reportingManagerEmail = _reportingManagerEmail.text;
        const certificate = null;

        print('Submitting claims...');
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
          // Optional success UI update
          ToastHelper.showSuccess(context, 'Claims submitted successfully!');
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
          setState(() {});
        }

        print('Claimsaddresponse $response');
      } catch (e) {
        // ToastHelper.showSuccess(context, e);
        print('❌ Submit error: $e');
      } finally {
        // ✅ Stop loader in all cases
        isEmployeeDetail = false;
        _reportingManagerEmail.clear();
        _corporateEmail.clear();
        ref.read(consultantProvider.notifier).setLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(consultantProvider);
    final List<dynamic> claimsDetails =consultantState.claimList??[];
    print('consultantStatebackdate  ${consultantState.backdatedClaims}');


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
        parseTimelineData(consultantState.consultantClaimSheet!['data']);

    print('customData ${customData}');
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
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeaderContent(consultantState),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: FixedHeaderDelegate(
                  height: 110 + calendarHeight, // Stepper (100) + Calendar
                  activeIndex: activeIndex,
                  backDatedClaims:consultantState.backdatedClaims??{},
                  claimsDetails:claimsDetails,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Stepper UI
                      Container(
                        // margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        width: double.infinity,
                        color: const Color(0xffF5F5F5),
                        child: _stepperUI(context, iconData, activeIndex),
                      ),
                      // Calendar View
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Adjust opacity as needed
                              blurRadius: 7, // Controls the blur effect
                              spreadRadius:
                                  1, // Controls the size of the shadow
                              offset: const Offset(
                                  0, 3), // Moves the shadow downward
                            ),
                          ],
                        ),
                        child: CalendarScreen(

                          selectedMonth: selectedMonth,
                          selectedYear: selectedYear,
                          onHeightCalculated:
                              _updateCalendarHeight, // Update dynamically
                          customData: customData,
                          isFromClaimScreen: true,
                          backDatedClaims:consultantState.backdatedClaims,
                          claimsDetails:claimsDetails,
                          onMonthChanged: (month, year) async {
                            setState(() {
                              selectedMonth = month;
                              selectedYear = year;
                            });

                            await _refreshData();

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
                const SizedBox(height: 30),
                _buildBottomTabView(tabsData, consultantState),
                const SizedBox(height: 10),
                _buildRemarksSection(consultantState),
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
                opacity: activeIndex != 0 ? 0.5 : 1.0,
                child: SvgPicture.asset('assets/icons/edit_icon.svg'))),
        const SizedBox(width: 10),
        Opacity(
          opacity: activeIndex != 0 ? 0.5 : 1.0,
          child: CustomButton(
            text: 'Save',
            width: 85,
            height: 36,
            borderRadius: 8,
            onPressed: () {
              activeIndex != 0 ? null : _saveClaims(consultantState);
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
              activeIndex != 0 ? null : _submitClaims(consultantState);
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
            child: Icon(isEmployeeDetail
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded)),
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
      decoration: _containerBoxDecoration(Colors.white, const Offset(0, 2)),
      child: RemarksSection(
        consultantState: consultantState,
      ),
    );
  }

  Widget _buildBottomTabView(
      List<String> tabsData, GetConsultantState consultantState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 414,
      decoration: _containerBoxDecoration(
        Colors.white,
        const Offset(0, 0),
        Border.all(width: 1, color: const Color(0xffE8E8E8)),
        BorderRadius.circular(12),
      ),
      child: BottomTabView(
          tabsData: tabsData,
          consultantState: consultantState,
          isFromClaimScreen: true,
          selectedMonth: selectedMonth.toString(),
          selectedYear: selectedYear.toString()),
    );
  }

  BoxDecoration _containerBoxDecoration(
      [Color? color,
      Offset shadowOffset = const Offset(0, 0),
      Border? border,
      BorderRadius? borderRadius]) {
    return BoxDecoration(
      color: color, // If color is null, it will be transparent (default)
      borderRadius: borderRadius,
      border: border,
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
      BuildContext context, List<String> svgIcons, int activeIndex)
  {
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
                backgroundColor = const Color(0xFFFFC107); // Yellow
                borderColor = const Color(0xFFFFC107);
                iconColor = Colors.white;
                break;
              case 4:
                backgroundColor = const Color(0xFF28A745); // Green
                borderColor = const Color(0xFF28A745);
                iconColor = Colors.white;
                break;
              case 5:
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
  final Map<String,dynamic> backDatedClaims;
  final List<dynamic> claimsDetails;

  FixedHeaderDelegate({
    required this.child,
    required this.height,
    required this.activeIndex,
    required this.backDatedClaims,
    required this.claimsDetails,
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
        backDatedClaims !=oldDelegate.backDatedClaims ||
        claimsDetails!=oldDelegate.claimsDetails ||
        oldDelegate.child.key != child.key;
  }
}

// class SliverCalendarDelegate extends SliverPersistentHeaderDelegate {
//   final double calendarHeight;
//   final Function(double) onHeightChanged;
//
//   SliverCalendarDelegate(
//       {required this.calendarHeight, required this.onHeightChanged});
//
//   @override
//   double get minExtent => calendarHeight;
//   @override
//   double get maxExtent => calendarHeight;
//
//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       height: calendarHeight,
//       color: Colors.white,
//       child: CalendarScreen(onHeightCalculated: (double newHeight) {
//         onHeightChanged(newHeight);
//       }),
//     );
//   }
//
//   @override
//   bool shouldRebuild(covariant SliverCalendarDelegate oldDelegate) {
//     return calendarHeight != oldDelegate.calendarHeight;
//   }
// }
