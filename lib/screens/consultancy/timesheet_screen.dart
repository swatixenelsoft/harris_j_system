import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';

class TimeSheetScreen extends StatefulWidget {
  const TimeSheetScreen({super.key});

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  int activeIndex = 0;
  double calendarHeight = 350;

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
                offset: const Offset(-2, -6), // Adjust positioning
                child: Text(
                  'HL1',
                  textScaleFactor: 0.7,
                  style: GoogleFonts.montserrat(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff007BFF),
                    // fontFeatures: [const FontFeature.superscripts()],
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
    DateTime(DateTime.now().year, DateTime.now().month, 13): CalendarData(widget: Text(
      "8",
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xff000000),
      ),
    ),  type: 'work',),
    DateTime(DateTime.now().year, DateTime.now().month, 14): CalendarData(widget: Text(
      "8",
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xff000000),
      ),
    ),  type: 'work',),
    DateTime(DateTime.now().year, DateTime.now().month, 15): CalendarData(widget: Text(
      "8",
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: const Color(0xff000000),
      ),
    ),  type: 'work',),
  };

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
        print('calendarHeight $calendarHeight');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              const SliverAppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: CustomAppBar(showBackButton: false,image: 'assets/icons/cons_logo.png'),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeaderContent(),
                  ],
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: FixedHeaderDelegate(
                  height: 80 + calendarHeight, // Stepper (100) + Calendar
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Stepper UI
                      Container(
                        // margin: const EdgeInsets.only(top: 30),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5),
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
                          onHeightCalculated:
                              _updateCalendarHeight, // Update dynamically
                          customData: customData,
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
                SizedBox(height: 200, child: CustomTabView()),
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

  Widget _buildHeaderContent() {
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
          _buildHeaderActions(),
          const SizedBox(height: 15),
          _buildEmployeeInfo(),
          const SizedBox(height: 15),
          _buildManagerInfo(),
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
        SvgPicture.asset('assets/icons/edit_icon.svg'),
        const SizedBox(width: 10),
        CustomButton(
          text: 'Save',
          width: 85,
          height: 36,
          borderRadius: 8,
          onPressed: () {},
          isOutlined: true,
          svgAsset: 'assets/icons/save.svg',
        ),
        const SizedBox(width: 7),
        CustomButton(
          text: 'Submit',
          width: 100,
          height: 36,
          borderRadius: 8,
          onPressed: () {},
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
    return _buildInfoColumn(
      'Reporting Manager : ',
      'Miss. Tiana Calzoni (tiana@gmail.com)',
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
