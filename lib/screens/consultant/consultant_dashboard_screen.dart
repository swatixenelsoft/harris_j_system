import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';
import 'package:harris_j_system/screens/consultant/widget/view_all_claims_list_widget.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_table.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, String>> heading = [
  {'label': 'Claim Form', 'key': 'claimForm'},
  {'label': 'Amount', 'key': 'amount'},
  {'label': 'Submit Date', 'key': 'submitDate'},
  {'label': 'Status', 'key': 'status'},
];

class ConsultantDashboardScreen extends ConsumerStatefulWidget {
  const ConsultantDashboardScreen({super.key});

  @override
  ConsumerState<ConsultantDashboardScreen> createState() =>
      _ConsultantDashboardScreenState();
}

class _ConsultantDashboardScreenState
    extends ConsumerState<ConsultantDashboardScreen> {
  final PageController _pageController = PageController();
  Future<void> requestAllPermissions() async {
    print('fgf');
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();

    bool allPermissionsGranted =
        statuses.values.every((status) => status.isGranted);
    if (!allPermissionsGranted) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Permissions required for full functionality')),
      // );
      return;
    }
  }

  Future<void> _getDashBoardData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('token $token');
    await ref.read(consultantProvider.notifier).fetchDashBoardData(token!);
  }

  _fetchAllData() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    await _getDashBoardData();
    await requestAllPermissions();
  }

  @override
  void initState() {
    _fetchAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final consultantDashboardState = ref.watch(consultantProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: consultantDashboardState.isLoading
            ? const CustomLoader()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //App Bar
                    CustomAppBar(
                      showBackButton: false,
                      showProfileIcon: true,
                      image: 'assets/icons/cons_logo.png',
                      onProfilePressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        // Read all isLoggedIn flags before clearing
                        final keys = prefs.getKeys();
                        final isLoggedInMap = <String, bool>{};

                        for (final key in keys) {
                          if (key.startsWith('isLoggedIn_')) {
                            isLoggedInMap[key] = prefs.getBool(key) ?? false;
                          }
                        }

                        // Clear all shared preferences
                        await prefs.clear();

                        // Restore isLoggedIn flags
                        for (final entry in isLoggedInMap.entries) {
                          await prefs.setBool(entry.key, entry.value);
                        }

                        // Navigate to login
                        context.pushReplacement(Constant.login);
                      },
                    ),
                    // Notifications
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 12, left: 12, bottom: 12, right: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xffE5F1FF),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xff007BFF)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset('assets/icons/close.png', height: 20),
                            ...List.generate(3, (index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle_outline,
                                            color: Color(0xff007BFF)),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Notification ${index + 1}',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff007BFF),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 32.0),
                                      child: Text(
                                        'Lorem ipsum dolor sit amet, consectetur elit.',
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff037EFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // User Greeting & Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                          consultantDashboardState.consultantData?['name'] ??
                              '',
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5A5A5A))),
                    ),
                    const SizedBox(height: 16),
                    // Work Hour Log

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        height: 216,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left side: Info
                            SizedBox(
                              height: 220,
                              width: 170,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Work Hour Log",
                                      style: GoogleFonts.montserrat(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Colors.black)),
                                  const SizedBox(height: 8),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 20,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color: const Color(0xffE5F1FF),
                                    ),
                                    child: Text(
                                        consultantDashboardState
                                                .workingLogGraphData?[
                                                    'hours_logged']
                                                .toString() ??
                                            'N/A',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xff007BFF))),
                                  ),
                                  const SizedBox(height: 80),
                                  LegendDot(
                                      color: const Color(0xff28A745),
                                      label:
                                          "Hours Logged: ${consultantDashboardState.workingLogGraphData?['hours_logged'].toString() ?? "N/A"}"),
                                  const SizedBox(height: 8),
                                  LegendDot(
                                      color: const Color(0xff007BFF),
                                      label:
                                          "Hours Forecasted : ${consultantDashboardState.workingLogGraphData?['hours_forecasted'].toString() ?? 'N/A'}"),
                                ],
                              ),
                            ),
                            // Right side: Pie Chart
                            SizedBox(
                              height: 220,
                              width: 125,
                              child: PieChart(
                                dataMap: {
                                  "Clocked-In": (consultantDashboardState
                                                  .workingLogGraphData?[
                                              'hours_logged'] ??
                                          0)
                                      .toDouble(),
                                  "Left": (consultantDashboardState
                                                  .workingLogGraphData?[
                                              'hours_forecasted'] ??
                                          0)
                                      .toDouble(),
                                },
                                chartType: ChartType.disc,
                                baseChartColor: Colors.grey[200]!,
                                colorList: const [
                                  Color(0xFF28A745),
                                  Color(0xFF007BFF),
                                ],
                                chartRadius: 160, // Bigger radius
                                chartValuesOptions: const ChartValuesOptions(
                                  showChartValues: false,
                                ),
                                legendOptions: const LegendOptions(
                                  showLegends: false,
                                ),
                                centerText: '',
                                ringStrokeWidth: 50,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: 240,
                    //   child: PageView(
                    //     controller: _pageController,
                    //     children: [
                    //       _graphWidget(consultantDashboardState),
                    //       _graphWidget(consultantDashboardState),
                    //     ],
                    //   ),
                    // ),

                    const SizedBox(height: 16),

                    // Leave Summary
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: Text("Leave Summary",
                    //       style: GoogleFonts.montserrat(
                    //           fontWeight: FontWeight.w500, fontSize: 14)),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //   child: Container(
                    //     margin: const EdgeInsets.symmetric(vertical: 12),
                    //     padding: const EdgeInsets.symmetric(vertical: 16),
                    //     decoration: BoxDecoration(
                    //       color: const Color(0xffE8E8E8),
                    //       borderRadius: BorderRadius.circular(4),
                    //     ),
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         LeaveTile(count: "15", label: "Availed"),
                    //         LeaveTile(count: "10", label: "AL"),
                    //         LeaveTile(count: "03", label: "MC"),
                    //         LeaveTile(count: "02", label: "Comp Off"),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // Claims Summary
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      color: const Color(0xffF2F2F2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Claims Summary",
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black)),
                          CustomButton(
                            isOutlined: true,
                            height: 34,
                            width: 91,
                            text: "View All",
                            icon: Icons.remove_red_eye_outlined,
                            onPressed: () {
                              _showFullClaimsPopup(
                                  context,
                                  consultantDashboardState
                                      .claimSummaryTableData,
                                  heading);
                            },
                          ),
                        ],
                      ),
                    ),

                    CustomTableView(
                      data: consultantDashboardState.claimSummaryTableData
                          .take(4)
                          .toList(),
                      heading: heading,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: MasonryGridView.builder(
                          itemCount: 6,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          itemBuilder: (context, index) {
                            Widget card;
                            switch (index) {
                              case 0:
                                card = GestureDetector(
                                  onTap: () {
                                    context.push(Constant.timeSheet);
                                  },
                                  child: BottomCard(
                                    title: "Timesheet",
                                    bgColor: const Color(0xff263238),
                                    textColor: Colors.white,
                                    image: 'assets/images/gridView1.png',
                                    index: index,
                                  ),
                                );
                                break;
                              case 1:
                                card = GestureDetector(
                                  onTap: () {
                                    context.push(Constant.claimScreen);
                                  },
                                  child: BottomCard(
                                    title: "Claims",
                                    lightRed: true,
                                    bgColor:
                                        const Color.fromRGBO(255, 25, 1, 0.09),
                                    textColor: const Color(0xff5A5A5A),
                                    image: 'assets/images/gridView2.png',
                                    index: index,
                                  ),
                                );
                                break;
                              case 2:
                                card = BottomCard(
                                  title: "Leave Log",
                                  white: true,
                                  bgColor: const Color.fromRGBO(0, 0, 0, 0.1),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView3.png',
                                  index: index,
                                );
                                break;
                              case 3:
                                card = BottomCard(
                                  title: "Work Log",
                                  orange: true,
                                  bgColor: const Color(0xffFFEDDA),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView4.png',
                                  index: index,
                                );
                                break;
                              case 5:
                                card = GestureDetector(
                                  onTap: () {
                                    context.push(Constant.hrFeedBackScreen);
                                  },
                                  child: BottomCard(
                                    title: "Feedback",
                                    orange: true,
                                    bgColor: const Color(0xffE5F1FF),
                                    textColor: const Color(0xff5A5A5A),
                                    image: 'assets/images/feedback.png',
                                    index: index,
                                  ),
                                );
                                break;
                              default:
                                return const SizedBox.shrink();
                            }

                            // Apply margin only for index 1 and 3
                            if (index == 1) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: card,
                              );
                            } else {
                              return card;
                            }
                          }),
                    ),
                  ],
                  // MasonryGridView
                ),
              ),
      ),
    );
  }

  _graphWidget(GetConsultantState consultantDashboardState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        height: 216,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Info
            SizedBox(
              height: 220,
              width: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Work Hour Log",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.black)),
                  const SizedBox(height: 8),
                  Container(
                    alignment: Alignment.center,
                    height: 20,
                    width: 95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color(0xffE5F1FF),
                    ),
                    child: Text(
                        consultantDashboardState
                                .workingLogGraphData?['hours_logged']
                                .toString() ??
                            "N/A",
                        style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff007BFF))),
                  ),
                  const SizedBox(height: 80),
                  LegendDot(
                      color: const Color(0xff28A745),
                      label:
                          "Hours Logged: ${consultantDashboardState.workingLogGraphData?['hours_logged'].toString() ?? 'N?A'}"),
                  const SizedBox(height: 8),
                  LegendDot(
                      color: const Color(0xff007BFF),
                      label:
                          "Hours Forecasted : ${consultantDashboardState.workingLogGraphData?['hours_forecasted'].toString() ?? 'N/A'}"),
                ],
              ),
            ),
            // Right side: Pie Chart
            SizedBox(
              height: 220,
              width: 125,
              child: PieChart(
                dataMap: {
                  "Clocked-In": (consultantDashboardState
                              .workingLogGraphData?['hours_logged'] ??
                          0)
                      .toDouble(),
                  "Left": (consultantDashboardState
                              .workingLogGraphData?['hours_forecasted'] ??
                          0)
                      .toDouble(),
                },
                chartType: ChartType.disc,
                baseChartColor: Colors.grey[200]!,
                colorList: const [
                  Color(0xFF28A745),
                  Color(0xFF007BFF),
                ],
                chartRadius: 160, // Bigger radius
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: false,
                ),
                legendOptions: const LegendOptions(
                  showLegends: false,
                ),
                centerText: '',
                ringStrokeWidth: 50,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showFullClaimsPopup(BuildContext context,
      List<Map<String, dynamic>> allClaims, List<Map<String, String>> heading) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // Blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
              // Centered dialog
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      // Header with close button
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "All Claims",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 150, 27, 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Content

                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: CustomTableView(
                                data: allClaims,
                                heading: heading,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LeaveTile extends StatelessWidget {
  final String count;
  final String label;

  const LeaveTile({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: GoogleFonts.montserrat(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: const Color(0xff008080))),
        Text(
          label,
          style: GoogleFonts.montserrat(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        ),
      ],
    );
  }
}

class LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const LegendDot({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 12, color: color),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xff000000)),
        ),
      ],
    );
  }
}
