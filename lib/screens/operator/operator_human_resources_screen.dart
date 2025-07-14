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
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'package:harris_j_system/widgets/bottom_tab_view.dart';

class HumanResourcesScreen extends ConsumerStatefulWidget {
  const HumanResourcesScreen({super.key});

  @override
  ConsumerState<HumanResourcesScreen> createState() =>
      _HumanResourcesScreenState();
}

class _HumanResourcesScreenState extends ConsumerState<HumanResourcesScreen> {
  int activeIndex = -1;
  double calendarHeight = 350;
  String? token;
  TextEditingController _searchController = TextEditingController();
  int? _selectedRowIndex; // Added for DataTable row selection

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];

  Map<DateTime, CalendarData> customData = {
    DateTime(DateTime.now().year, DateTime.now().month, 5): CalendarData(
      widget: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'ML',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xff007BFF),
              ),
            ),
            WidgetSpan(
              child: Transform.translate(
                offset: const Offset(-2, -6),
                child: Text(
                  'HL1',
                  textScaleFactor: 0.7,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
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
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 1): CalendarData(
      widget: Text(
        "PDO",
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: const Color(0xff007BFF),
        ),
      ),
      type: 'leave',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 9): CalendarData(
        widget: Text(
          "PH",
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: const Color(0xff007BFF),
          ),
        ),
        type: 'leave'),
    DateTime(DateTime.now().year, DateTime.now().month, 2): CalendarData(
        widget: Text(
          "8",
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xff000000),
          ),
        ),
        type: 'work'),
    DateTime(DateTime.now().year, DateTime.now().month, 6): CalendarData(
      widget: Text(
        "6",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xffFF1901),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 7): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 8): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 12): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 13): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 14): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
    DateTime(DateTime.now().year, DateTime.now().month, 15): CalendarData(
      widget: Text(
        "8",
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: const Color(0xff000000),
        ),
      ),
      type: 'work',
    ),
  };

  final List<String> tabsData = [
    "Timesheet Overview",
    "Extra Time Log",
    "Pay-off Log",
    "Comp-off log",
    "Get Copies"
  ];

  List<Map<String, dynamic>> consultanciesData = [
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Allison Schleifer', 'loggedHours': '100/160', 'actions': {}},
    {'name': 'Charlie Vetrovs', 'loggedHours': '160/160', 'actions': {}},
    {'name': 'Lincoln Geidt', 'loggedHours': '0/160', 'actions': {}},
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
              isFromClaims: false,
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
      // _getConsultantTimeSheet();
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
        final dateStr = details['date'];
        if (dateStr == null) continue;

        final parts = dateStr.split(' / ');
        final day = int.tryParse(parts[0] ?? '');
        final month = int.tryParse(parts[1] ?? '');
        final year = int.tryParse(parts[2] ?? '');
        if (day == null || month == null || year == null) continue;

        final dateKey = DateTime(year, month, day);

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
        } else if (details.containsKey('workingHours') &&
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

  // Helper method to assign queue colors
  Color _getQueueColor(int index) {
    const colors = [
      Color.fromRGBO(0, 123, 255, 1),
      Color.fromRGBO(255, 193, 7, 1),
      Color.fromRGBO(40, 167, 69, 1),
      Color.fromRGBO(255, 25, 1, 1),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(consultantProvider);
    final consultancies = consultanciesData;

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
                  height: 120 + calendarHeight,
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
                      const SizedBox(height: 5),
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
                          selectedMonth: 05,
                          selectedYear: 2025,
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
                padding: const EdgeInsets.all(14.0),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setTableState) {
                  return DataTable(
                    columnSpacing: 20,
                    headingRowHeight: 40,
                    dataRowHeight: 60,
                    headingRowColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xFFF5F5F5)),
                    columns: [
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 60),
                            SvgPicture.asset(
                              'assets/icons/search_o.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'Queue',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/queue.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'Hrs LGD/FCst',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'Logged Time Off',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'AL OVERVIEW',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'ML OVERVIEW',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'PDO OVERVIEW',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                      DataColumn(
                        label: Row(
                          children: [
                            Text(
                              'UL OVERVIEW',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                    rows: List.generate(consultancies.length, (index) {
                      final consultancy = consultancies[index];
                      return DataRow.byIndex(
                        index: index,
                        color: MaterialStateColor.resolveWith((states) =>
                            _selectedRowIndex == index
                                ? const Color.fromRGBO(255, 238, 218, 1)
                                : Colors.transparent),
                        cells: [
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  consultancy['name'] ?? '',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: _getQueueColor(index),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  consultancy['loggedHours'] ?? '0/160',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '5/3/4', // Placeholder, update with actual data
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '12/2', // Placeholder, update with actual data
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '8/2', // Placeholder, update with actual data
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '3/2', // Placeholder, update with actual data
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            InkWell(
                              onTap: () {
                                setTableState(() {
                                  _selectedRowIndex =
                                      _selectedRowIndex == index ? null : index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '15', // Placeholder, update with actual data
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  );
                },
              ),
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
      color: color,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(svgIcons.length, (index) {
        bool isSelected = index == activeIndex;

        return Row(
          children: [
            if (index != 0)
              const SizedBox(
                width: 28,
                child: Divider(
                  color: Color(0xffA1AEBE),
                  thickness: 2,
                  endIndent: 2,
                  indent: 2,
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  activeIndex = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : const Color(0xffA1AEBE),
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black,
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
  final String type;

  CalendarData({required this.widget, required this.type});
}
