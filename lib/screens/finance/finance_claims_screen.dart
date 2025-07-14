import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_timesheet_detail_popup.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/operator/action_click.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../providers/consultant_provider.dart';

class FinanceClaimScreen extends ConsumerStatefulWidget {
  const FinanceClaimScreen({super.key});

  @override
  ConsumerState<FinanceClaimScreen> createState() =>
      _OperatorClaimScreenState();
}

class _OperatorClaimScreenState extends ConsumerState<FinanceClaimScreen> {
  int activeIndex = 0;
  int? _selectedRowIndex;
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
  final List<String> tabsData = ["Claims", "Get Copies"];
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
      BuildContext context, Map<String, dynamic> consultancy)
  {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: operatorActionPopup(
                consultant: consultancy,
                isFromClaims: true,
                onDelete: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  Map<DateTime, List<Map<String, dynamic>>> customData = {
    DateTime(DateTime.now().year, DateTime.now().month, 5): [
      {
        'type': 'taxi',
        'color': Colors.orange,
      },
    ],
    DateTime(DateTime.now().year, DateTime.now().month, 6): [
      {
        'type': 'food',
        'color': Colors.red,
      },
    ],
    DateTime(DateTime.now().year, DateTime.now().month, 9): [
      {
        'type': 'meeting',
        'color': Colors.blue,
      },
      {
        'type': 'food',
        'color': Colors.red,
      },
      {
        'type': 'taxi',
        'color': Colors.orange,
      },
      {
        'type': 'taxi1',
        'color': Colors.grey,
      },
      {
        'type': 'taxi2',
        'color': Colors.green,
      },
      {
        'type': 'taxi3',
        'color': Colors.yellow,
      },
    ],
  };
  @override
  Widget build(BuildContext context) {
    final consultancies = consultanciesData ?? [];

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
                  height: 80 + calendarHeight,
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
                          isFromClaimScreen: true,
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
                const SizedBox(height: 10),
                _buildBottomTabView(tabsData),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(List<Map<String, dynamic>> consultancies) {
    // Get screen width using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;

    // Define proportional column widths based on screen width
    final double nameWidth = screenWidth * 0.25; // 25% of screen width
    final double queueWidth = screenWidth * 0.20; // 15% of screen width
    final double submittedWidth = screenWidth * 0.25; // 20% of screen width
    final double claimNoWidth = screenWidth * 0.20; // 20% of screen width
    final double numClaimsWidth = screenWidth * 0.35; // 25% of screen width
    final double totalAmountWidth = screenWidth * 0.30; // 20% of screen width
    final double actionWidth = screenWidth * 0.15; // 15% of screen width

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
          const SizedBox(height: 15),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: screenWidth),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: DataTable(
                  columnSpacing: 16,
                  headingRowHeight: 40,
                  dataRowHeight: 60,
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color(0xFFF5F5F5),
                  ),
                  columns: [
                    DataColumn(
                      label: SizedBox(
                        width: nameWidth,
                        child: Row(
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 30),
                            SvgPicture.asset(
                              'assets/icons/search_o.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: queueWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Queue',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/queue.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: submittedWidth,
                        child: Row(
                          children: [
                            Text(
                              'Submitted',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: claimNoWidth,
                        child: Row(
                          children: [
                            Text(
                              'Claim No',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: numClaimsWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Number of Claims',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: totalAmountWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Amount',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SvgPicture.asset(
                              'assets/icons/hrs.svg',
                              width: 18,
                              height: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: actionWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Action',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      color: MaterialStateColor.resolveWith(
                        (states) => _selectedRowIndex == 0
                            ? const Color.fromRGBO(250, 250, 250, 1)
                            : Colors.transparent,
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: nameWidth,
                            child: Text(
                              'Bruce Lee',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: queueWidth,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(0, 123, 255, 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: submittedWidth,
                            child: Text(
                              '12/08/2024',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: claimNoWidth,
                            child: Text(
                              'CL09892F12',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: numClaimsWidth,
                            child: Text(
                              '2',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: totalAmountWidth,
                            child: Text(
                              '\$300',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: actionWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRowIndex = 0;
                                });
                                _showConsultancyPopup(context, {
                                  'name': 'Bruce Lee',
                                  'queueColor': Color.fromRGBO(0, 123, 255, 1),
                                  'submitted': '12/08/2024',
                                  'claimNo': 'CL09892F12',
                                  'numClaims': '2',
                                  'totalAmount': '\$300',
                                });
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/action.svg',
                                  width: 29,
                                  height: 29,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: MaterialStateColor.resolveWith(
                        (states) => _selectedRowIndex == 1
                            ? const Color.fromRGBO(250, 250, 250, 1)
                            : Colors.transparent,
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: nameWidth,
                            child: Text(
                              'Allison Schleifer',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: queueWidth,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 193, 7, 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: submittedWidth,
                            child: Text(
                              '13/08/2024',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: claimNoWidth,
                            child: Text(
                              'CL09893G45',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: numClaimsWidth,
                            child: Text(
                              '2',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: totalAmountWidth,
                            child: Text(
                              '\$500',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: actionWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRowIndex = 1;
                                });
                                _showConsultancyPopup(context, {
                                  'name': 'Allison Schleifer',
                                  'queueColor': Color.fromRGBO(255, 193, 7, 1),
                                  'submitted': '13/08/2024',
                                  'claimNo': 'CL09893G45',
                                  'numClaims': '2',
                                  'totalAmount': '\$500',
                                });
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/action.svg',
                                  width: 29,
                                  height: 29,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: MaterialStateColor.resolveWith(
                        (states) => _selectedRowIndex == 2
                            ? const Color.fromRGBO(250, 250, 250, 1)
                            : Colors.transparent,
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: nameWidth,
                            child: Text(
                              'Charlie Vetrovs',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: queueWidth,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(40, 167, 69, 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: submittedWidth,
                            child: Text(
                              '14/08/2024',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: claimNoWidth,
                            child: Text(
                              'CL09894H78',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: numClaimsWidth,
                            child: Text(
                              '3',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: totalAmountWidth,
                            child: Text(
                              '\$600',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: actionWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRowIndex = 2;
                                });
                                _showConsultancyPopup(context, {
                                  'name': 'Charlie Vetrovs',
                                  'queueColor': Color.fromRGBO(40, 167, 69, 1),
                                  'submitted': '14/08/2024',
                                  'claimNo': 'CL09894H78',
                                  'numClaims': '3',
                                  'totalAmount': '\$600',
                                });
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/action.svg',
                                  width: 29,
                                  height: 29,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      color: MaterialStateColor.resolveWith(
                        (states) => _selectedRowIndex == 3
                            ? const Color.fromRGBO(250, 250, 250, 1)
                            : Colors.transparent,
                      ),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: nameWidth,
                            child: Text(
                              'Lincoln Geidt',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: queueWidth,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 25, 1, 1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: submittedWidth,
                            child: Text(
                              '15/08/2024',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: claimNoWidth,
                            child: Text(
                              'CL09895J12',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: numClaimsWidth,
                            child: Text(
                              '2',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: totalAmountWidth,
                            child: Text(
                              '\$800',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: actionWidth,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRowIndex = 3;
                                });
                                _showConsultancyPopup(context, {
                                  'name': 'Lincoln Geidt',
                                  'queueColor': Color.fromRGBO(255, 25, 1, 1),
                                  'submitted': '15/08/2024',
                                  'claimNo': 'CL09895J12',
                                  'numClaims': '2',
                                  'totalAmount': '\$800',
                                });
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/action.svg',
                                  width: 29,
                                  height: 29,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
        Row(
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset('assets/icons/back.svg', height: 15),
            ),
            const SizedBox(width: 10),
            Text(
              'Claims list',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xffFF1901),
              ),
            ),
          ],
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/icons/search_icon.svg',
          height: 15,
          width: 15,
        ),
      ],
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(),
    );
  }

  Widget _buildBottomTabView(List<String> tabsData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 414,
      decoration: _containerBoxDecoration(
        Colors.white,
        const Offset(0, 0),
        Border.all(width: 1, color: const Color(0xffE8E8E8)),
        BorderRadius.circular(12),
      ),
      child: BottomTabView(tabsData: tabsData, isFromClaimScreen: true),
    );
  }

  BoxDecoration _containerBoxDecoration([
    Color? color,
    Offset shadowOffset = const Offset(0, 0),
    Border? border,
    BorderRadius? borderRadius,
  ]) {
    return BoxDecoration(
      color: color,
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
