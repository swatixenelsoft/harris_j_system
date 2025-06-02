import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
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
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';
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

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];

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
    await ref.read(consultantProvider.notifier).consultantClaimSheet(
        token!);

  }

  Map<DateTime, List<Map<String, dynamic>>> parseTimelineData(Map<String, dynamic> json) {
    final Map<DateTime, List<Map<String, dynamic>>> customData = {};

    final List dataList = json['data'] ?? [];

    for (var item in dataList) {
      final List days = item['days'] ?? [];

      for (var day in days) {
        final int? dayNum = day['day'];
        final String? type = day['type'];
        final String? expenseType = day['details']?['expenseType'];

        if (dayNum == null || (type != 'claims' && type != 'timesheet')) continue;

        // Determine color based on expenseType or type
        Color color;
        switch ((expenseType ?? type)?.toLowerCase()) {
          case 'taxi':
            color = const Color(0xffEBF9F1);
            break;
          case 'dining':
            color = const Color(0xffFBE7E8);
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
        });
      }
    }

    print('customData $customData');
    return customData;
  }





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

  void _refreshData() async {
    await ref.read(consultantProvider.notifier).consultantClaimSheet(
        token!);

    setState(() {});
    print('refresh ');
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
print('consultantState.consultantClaimSheet ${consultantState.consultantClaimSheet}');
    final customData = parseTimelineData(consultantState.consultantClaimSheet!);
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
                  background: CustomAppBar( showBackButton: false,
                    image: 'assets/icons/cons_logo.png',
                    onProfilePressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      context.pushReplacement(Constant.login);
                    },),
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
                  height: 80 + calendarHeight, // Stepper (100) + Calendar
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
                            onHeightCalculated:
                                _updateCalendarHeight, // Update dynamically
                            customData: customData,
                            isFromClaimScreen: true,
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
          const SizedBox(height: 15),
          _buildEmployeeInfo(),
          const SizedBox(height: 15),
          _buildManagerInfo(),
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
            onTap: () {
              setState(() {
                consultantState.isEditable =
                !(consultantState.isEditable ?? false);
              });

              ToastHelper.showInfo(
                context,
                consultantState.isEditable ? "Edit Enabled" : "Edit Disabled",
              );

              print('isEdit ${consultantState.isEditable}');
            },
            child: SvgPicture.asset('assets/icons/edit_icon.svg')),
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
