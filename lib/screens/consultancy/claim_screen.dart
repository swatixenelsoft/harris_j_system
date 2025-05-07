import 'package:flutter/material.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';

class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key});

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
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

  final List<String> tabsData = ["Claims", "Get Copies"];

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
    print('custom ${customData}');
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
                            isFromClaimScreen: true),
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
        SvgPicture.asset('assets/icons/back.svg', height: 15),
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
      decoration: _containerBoxDecoration(Colors.white, const Offset(0, 2)),
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
