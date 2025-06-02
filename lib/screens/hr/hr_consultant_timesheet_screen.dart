import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_timesheet_detail_popup.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HrConsultantTimeSheetScreen extends ConsumerStatefulWidget {
  const HrConsultantTimeSheetScreen({super.key});

  @override
  ConsumerState<HrConsultantTimeSheetScreen> createState() =>
      _HrConsultantTimeSheetScreenState();
}

class _HrConsultantTimeSheetScreenState
    extends ConsumerState<HrConsultantTimeSheetScreen> {
  int activeIndex = 0;
  double calendarHeight = 350;
  String? token;
  TextEditingController _searchController = TextEditingController();

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];

  // Map<DateTime, CalendarData> customData = {
  //   DateTime(DateTime.now().year, DateTime.now().month, 5): CalendarData(
  //     widget: RichText(
  //       text: TextSpan(
  //         children: [
  //           TextSpan(
  //             text: 'ML',
  //             style: GoogleFonts.montserrat(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w800,
  //               color: const Color(0xff007BFF),
  //             ),
  //           ),
  //           WidgetSpan(
  //             child: Transform.translate(
  //               offset: const Offset(-2, -6), // Adjust positioning
  //               child: Text(
  //                 'HL1',
  //                 textScaleFactor: 0.7,
  //                 style: GoogleFonts.montserrat(
  //                   fontSize: 10,
  //                   fontWeight: FontWeight.w800,
  //                   color: const Color(0xff007BFF),
  //                   // fontFeatures: [const FontFeature.superscripts()],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //     type: 'leave',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 1): CalendarData(
  //     widget: Text(
  //       "PDO",
  //       style: GoogleFonts.montserrat(
  //         fontSize: 14,
  //         fontWeight: FontWeight.w800,
  //         color: const Color(0xff007BFF),
  //       ),
  //     ),
  //     type: 'leave',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 9): CalendarData(
  //       widget: Text(
  //         "PH",
  //         style: GoogleFonts.montserrat(
  //           fontSize: 14,
  //           fontWeight: FontWeight.w800,
  //           color: const Color(0xff007BFF),
  //         ),
  //       ),
  //       type: 'leave'),
  //   DateTime(DateTime.now().year, DateTime.now().month, 2): CalendarData(
  //       widget: Text(
  //         "8",
  //         style: GoogleFonts.montserrat(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: const Color(0xff000000),
  //         ),
  //       ),
  //       type: 'work'),
  //   DateTime(DateTime.now().year, DateTime.now().month, 6): CalendarData(
  //     widget: Text(
  //       "6",
  //       style: GoogleFonts.montserrat(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: const Color(0xffFF1901),
  //       ),
  //     ),
  //     type: 'work',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 7): CalendarData(
  //     widget: Text(
  //       "8",
  //       style: GoogleFonts.montserrat(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: const Color(0xff000000),
  //       ),
  //     ),
  //     type: 'work',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 8): CalendarData(
  //     widget: Text(
  //       "8",
  //       style: GoogleFonts.montserrat(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: const Color(0xff000000),
  //       ),
  //     ),
  //     type: 'work',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 12): CalendarData(
  //     widget: Text(
  //       "8",
  //       style: GoogleFonts.montserrat(
  //         fontSize: 16,
  //         fontWeight: FontWeight.w600,
  //         color: const Color(0xff000000),
  //       ),
  //     ),
  //     type: 'work',
  //   ),
  //   DateTime(DateTime.now().year, DateTime.now().month, 13): CalendarData(widget: Text(
  //     "8",
  //     style: GoogleFonts.montserrat(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //       color: const Color(0xff000000),
  //     ),
  //   ),  type: 'work',),
  //   DateTime(DateTime.now().year, DateTime.now().month, 14): CalendarData(widget: Text(
  //     "8",
  //     style: GoogleFonts.montserrat(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //       color: const Color(0xff000000),
  //     ),
  //   ),  type: 'work',),
  //   DateTime(DateTime.now().year, DateTime.now().month, 15): CalendarData(widget: Text(
  //     "8",
  //     style: GoogleFonts.montserrat(
  //       fontSize: 16,
  //       fontWeight: FontWeight.w600,
  //       color: const Color(0xff000000),
  //     ),
  //   ),  type: 'work',),
  // };

  final List<String> tabsData = [
    "Timesheet Overview",
    "Extra Time Log",
    "Pay-off Log",
    "Comp-off log",
    "Get Copies"
  ];

  List<Map<String, dynamic>> consultanciesData = [
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
  ];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
        print('calendarHeight $calendarHeight');
      }
    });
  }

  void _showConsultancyPopup(
      BuildContext context, Map<String, dynamic> consultancy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.65,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: HrConsultantTimesheetDetailPopup(
              consultant: consultancy,
              isFromClaims:false,
              onDelete: () {},
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _getConsultantTimeSheet();
    });
  }

  Future<void> _getConsultantTimeSheet() async {
    print('ghkjhk');

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await ref
        .read(consultantProvider.notifier)
        .consultantTimeSheet(token!, '5', '2025');
  }

  Map<DateTime, CalendarData> parseTimelineData(
      Map<String, dynamic> apiResponse) {
    final Map<DateTime, CalendarData> calendarData = {};

    if (apiResponse['success'] == true &&
        apiResponse['data'] != null &&
        apiResponse['data'] is List &&
        (apiResponse['data'] as List).isNotEmpty) {
      final days = apiResponse['data'][0]['days'];

      for (var dayData in days) {
        final details = dayData['details'] ?? {};
        final dateStr = details['date']; // e.g., "05 / 05 / 2025"
        if (dateStr == null) continue;

        final parts = dateStr.split(' / ');
        final day = int.tryParse(parts[0] ?? '');
        final month = int.tryParse(parts[1] ?? '');
        final year = int.tryParse(parts[2] ?? '');
        if (day == null || month == null || year == null) continue;

        final dateKey = DateTime(year, month, day);

        // Leave case
        if (details.containsKey('leaveType') && details['leaveType'] != null) {
          final leaveType = details['leaveType'];
          calendarData[dateKey] = CalendarData(
            widget: Text(
              leaveType,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xff007BFF),
              ),
            ),
            type: 'leave',
          );
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
                color: const Color(0xff000000),
              ),
            ),
            type: 'work',
          );
        }
      }
    }

    return calendarData;
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(consultantProvider);
    final consultancies = consultanciesData ?? [];
    print('loader is ${consultantState.isLoading}');

    if (consultantState.isLoading ||
        consultantState.consultantTimeSheet == null) {
      return const Scaffold(
        body: SafeArea(
          child: Center(
            child: CustomLoader(color: Color(0xffFF1901)),
          ),
        ),
      );
    }

    final customData = parseTimelineData(consultantState.consultantTimeSheet!);

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
              SliverToBoxAdapter(child: _buildHeaderContent(consultancies)),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: FixedHeaderDelegate(
                  height: 110 + calendarHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        width: double.infinity,
                        color: const Color(0xffF5F5F5),
                        child: _stepperUI(context, iconData, activeIndex),
                      ),
                      const SizedBox(height:5 ),
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
                          onHeightCalculated: _updateCalendarHeight,
                          customData: customData,
                          isFromHrScreen: true,
                          onMonthChanged: (month, year) {
                            print('onMonthChanged $month,$year');
                            ref
                                .read(consultantProvider.notifier)
                                .consultantTimeSheet(
                                  token!,
                                  month.toString(),
                                  year.toString(),
                                );
                          },
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
                _buildRemarksSection(),
                const SizedBox(height: 30),
                _buildBottomTabView(tabsData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(consultancies) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildHeaderActions(),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomTextField(
              label: 'Search',
              hintText: 'Search by client/consultant name',
              controller: _searchController,
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.all(14.0), // optional padding for spacing
                child: SizedBox(
                  height: 10,
                  width: 10,
                  child: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                  ),
                ),
              ),
              suffixIcon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 30,
                color: Color(0xff8D91A0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            // width: double.infinity,
            child: SfDataGrid(
              source: GenericDataSource(
                data: consultancies,
                columns: ['name', 'loggedHours', 'actions'],
                onZoomTap: (consultancy) {
                  print('Zoom on consultancy: $consultancy');
                  _showConsultancyPopup(context,
                      consultancy); // Use context from the parent scope
                },
              ),
              columnWidthMode: ColumnWidthMode.fill,
              headerRowHeight: 38,
              rowHeight: 52,
              columns: [
                GridColumn(
                  columnName: 'name',
                  width: 120,
                  label: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFFF2F2F2),
                    child: Text(
                      'Name',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'loggedHours',
                  width: 120, // 👈 Increase this width
                  label: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    color: const Color(0xFFF2F2F2),
                    child: Text(
                      'Hours Logged',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'actions',
                  // width: 120,
                  label: Container(
                    alignment: Alignment.center,
                    color: const Color(0xFFF2F2F2),
                    child: Text(
                      'Actions',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset('assets/icons/back.svg', height: 15)),
        const Spacer(),
        Text(
          'Total Timesheet:\n90/100',
          style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff5A5A5A)),
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(),
    );
  }

  Widget _buildBottomTabView(tabsData) {
    return Container(
      height: 260,
      decoration: containerBoxDecoration(null, const Offset(2, 4)),
      child: Stack(
        children: [
          BottomTabView(tabsData: tabsData),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Align items in the center
      children: List.generate(svgIcons.length, (index) {
        bool isSelected = index == activeIndex;

        return Row(
          children: [
            // Add a divider before each step except the first one
            if (index != 0)
              const SizedBox(
                width: 28, // Adjust width as needed
                child: Divider(
                  color: Color(0xffA1AEBE),
                  thickness: 2,
                  endIndent: 2,
                  indent: 2,
                ),
              ),
            GestureDetector(
              onTap: () {
// setState(() {
//   isSelected=index==activeIndex;
// });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5), // Padding inside the circle
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : Colors.white, // Change background color if selected
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : const Color(
                            0xffA1AEBE), // Change border color if selected
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? Colors.white
                        : Colors.black, // Change icon color if selected
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  FixedHeaderDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant FixedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height;
  }
}

class CalendarData {
  final Widget widget;
  final String type; // e.g., 'leave', 'work', etc.

  CalendarData({required this.widget, required this.type});
}
