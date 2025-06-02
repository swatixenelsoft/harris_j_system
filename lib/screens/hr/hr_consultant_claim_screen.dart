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

class HrConsultantClaimScreen extends ConsumerStatefulWidget {
  const HrConsultantClaimScreen({super.key});

  @override
  ConsumerState<HrConsultantClaimScreen> createState() =>
      _HrConsultantClaimScreenState();
}

class _HrConsultantClaimScreenState
    extends ConsumerState<HrConsultantClaimScreen> {
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
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: HrConsultantTimesheetDetailPopup(
              consultant: consultancy,
                isFromClaims:true,
              onDelete: () {},
            ),
          ),
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
                const SizedBox(height: 30),
                _buildBottomTabView(tabsData),
                const SizedBox(height: 10),
                _buildRemarksSection(),
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
          const SizedBox(height: 15
          ),
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
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset('assets/icons/back.svg', height: 15)),
          const SizedBox(width: 10),
            Text('Claims list', style: GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: const Color(0xffFF1901)),),
          ],
        ),
        const Spacer(),
SvgPicture.asset('assets/icons/search_icon.svg',height: 15,width: 15,)
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
      height:  414,
      decoration: _containerBoxDecoration(
        Colors.white,
        const Offset(0, 0),
        Border.all(width: 1, color: const Color(0xffE8E8E8)),
        BorderRadius.circular(12),
      ),
      child: BottomTabView(tabsData: tabsData, isFromClaimScreen: true),
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
