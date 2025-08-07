import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
import 'package:harris_j_system/screens/bom/widget/finance_chart_widget.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_table.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, dynamic>> tableData = [
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12 /08/2024  10 : 12 : 34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12 /08/2024  10 : 12 : 34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12 /08/2024  10 : 12 : 34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12 /08/2024  10 : 12 : 34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12 /08/2024  10 : 12 : 34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
];
final List<Map<String, String>> heading = [
  {'label': 'Consultancy Name', 'key': 'consultancy_name'},
  {'label': 'License Expiry', 'key': 'license_expiry'},
  {'label': 'Status', 'key': 'status'},
];

class HrDashboardScreen extends ConsumerStatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  ConsumerState<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends ConsumerState<HrDashboardScreen> {
  TextEditingController _searchController = TextEditingController();

  String? _selectedClient;
  String? _selectedClientId;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];

  String? token;

  bool showInfoSections = true;
  Timer? _hideDashboardTimer;
  String _selectedPeriod = 'Monthly';
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<String, dynamic>? timesheetData;
  Map<String, dynamic>? workLogData;

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final client = await ref.read(hrProvider.notifier).clientList(token!);
    print('client $client');

    _rawClientList = (client['data'] != null && client['data'] is List)
        ? List<Map<String, dynamic>>.from(client['data'])
        : [];

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    print('_clientList $_clientList');

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();

      print('_selectedClientId11 $_selectedClientId,$_selectedClient');

      // ✅ Optionally fetch consultants for the first client
    }

    setState(() {});
  }

  getDashBoardByClient() async {
    print('_selectedClientId $_selectedClientId');
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await ref
        .read(hrProvider.notifier)
        .getDashBoardByClient(_selectedClientId!, token!);
  }

  fetchData() async {
    ref.read(hrProvider.notifier).setLoading(true);
    await getClientList();
    await getDashBoardByClient();

    ref.read(hrProvider.notifier).setLoading(false);

  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchData());
    _startHideDashboardTimer();
  }

  void _startHideDashboardTimer() {
    _hideDashboardTimer?.cancel();
    _hideDashboardTimer = Timer(const Duration(seconds: 5), () {
      setState(() {
        showInfoSections = false;
      });
    });
  }

  void _onDashboardHoldStart() {
    _hideDashboardTimer?.cancel();
    setState(() {
      showInfoSections = true;
    });
  }

  void _onDashboardHoldEnd() {
    setState(() {
      showInfoSections = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(hrProvider);

    final isLoading = consultantState.isLoading;
    final Map<String, dynamic> dashboardData =
        consultantState.dashboardData ?? {};

    final List<Widget> pages = [
      _buildTimesheetCard(),
      _buildTimesheetCard(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Bar
                CustomAppBar(
                  showBackButton: false,
                  showProfileIcon: true,
                  image: 'assets/icons/cons_logo.png',
                  onProfilePressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    context.pushReplacement(Constant.login);
                  },
                ),

                SizedBox(height: showInfoSections ? 24 : 10),
                // User Greeting & Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Hi HR",
                          style: GoogleFonts.montserrat(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff5A5A5A))),
                      CustomButton(
                        text: "View Dashboard",
                        onPressed: () {
                          setState(() {
                            showInfoSections = !showInfoSections;
                          });
                        },
                        height: 38,
                        width: 151,
                        isOutlined: true,
                        borderRadius: 8,
                        textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500,fontSize: 12,),
                        icon: showInfoSections
                            ? Icons.keyboard_arrow_up_sharp
                            : Icons.keyboard_arrow_down_sharp,
                      ),

                    ],
                  ),
                ),

                if (showInfoSections) ...[
                  const SizedBox(height: 10),
                  GestureDetector(
                    onLongPressStart: (_) => _onDashboardHoldStart(),
                    onLongPressEnd: (_) => _onDashboardHoldEnd(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Turn-in-rate: 90/100",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff000000),
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_rawClientList.isNotEmpty && _selectedClient != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: CustomClientDropdown(
                              clients: _rawClientList,
                              initialClientName: _selectedClient,
                              onChanged: (selectedName, selectedId) async {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _selectedClient = selectedName;
                                  _selectedClientId = selectedId;
                                });

                                getDashBoardByClient();
                              },
                            ),
                          ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'My Dashboard',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                                  height: 230,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Residential Status",
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
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
                                            dashboardData["consultant_total"]
                                                .toString(),
                                            style: GoogleFonts.montserrat(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xff007BFF))),
                                      ),
                                      const SizedBox(height: 20),
                                      LegendDot(
                                        color: const Color(0xff28A745),
                                        label:
                                        "Nationality: ${dashboardData["residential_breakdown"]?["nationality"]?.toString() ?? 'N/A'}",
                                      ),
                                      const SizedBox(height: 8),
                                      LegendDot(
                                          color: const Color(0xffFF8403),
                                          label:
                                          "Permanent Resident:  ${dashboardData["residential_breakdown"]?["permanent_resident"].toString() ?? "N/A"}"),
                                      const SizedBox(height: 8),
                                      LegendDot(
                                          color: const Color(0xffFF1901),
                                          label:
                                          "Employment Pass Holders :${dashboardData["residential_breakdown"]?["employment_pass"].toString() ?? "N/A"}"),
                                    ],
                                  ),
                                ),
                                // Right side: Pie Chart
                                SizedBox(
                                  height: 220,
                                  width: 120,
                                  child: PieChart(
                                    dataMap: {
                                      "Nationality":
                                      (dashboardData["residential_breakdown"]
                                      ?["nationality"] ??
                                          0)
                                          .toDouble(),
                                      "Left": (dashboardData["residential_breakdown"]
                                      ?["permanent_resident"] ??
                                          0)
                                          .toDouble(),
                                      "Right": (dashboardData["residential_breakdown"]
                                      ?["employment_pass"] ??
                                          0)
                                          .toDouble(),
                                    },
                                    chartType: ChartType.disc,
                                    baseChartColor: Colors.grey[200]!,
                                    colorList: const [
                                      Color(0xFF28A745),
                                      Color(0xffFF8403),
                                      Color(0xFFFD0D1B),
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Your Wins",
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.black)),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xffE8E6EA)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: 'Monthly',
                                    icon: const Icon(
                                      Icons
                                          .keyboard_arrow_down_rounded, // Custom dropdown icon
                                      color: Color(0xff8D91A0),
                                      size: 25,
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Monthly',
                                        child: Text(
                                          'Monthly',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff8D91A0),
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Weekly',
                                        child: Text(
                                          'Weekly',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff8D91A0),
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        consultancyCard(
                          count: dashboardData['status_counts']?['working']?.toString() ?? '0',
                          label: "Talent HeadCount",
                          iconPath: 'assets/icons/employee_list_icon.svg',
                        ),
                        const SizedBox(height: 16),
                        consultancyCard(
                          count: dashboardData['status_counts']?['new']?.toString()??'0',
                          label: "New Talent onBoarded",
                          iconPath: 'assets/icons/new_employee_icon.svg',
                        ),

                        const SizedBox(height: 16),
                        consultancyCard(
                          count: dashboardData['status_counts']?['relieving']?.toString()??'0',
                          label: "Talent Departure Summary",
                          iconPath: 'assets/icons/relieving_employee_icon.svg',
                        ),
                        const SizedBox(height: 16),
                        consultancyCard(
                          count: dashboardData['status_counts']?['future_joining']?.toString()??'0',
                          label: "Incoming Talent",
                          iconPath: 'assets/icons/joining_employee_icon.svg',
                        ),
                      ],
                    ),
                  )

                ],




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
                                context
                                    .push(Constant.hrConsultantTimesheetScreen);
                              },
                              child: BottomCard(
                                title: "Human Resources",
                                bgColor: const Color.fromRGBO(255, 25, 1, 0.09),
                                textColor: const Color(0xff5A5A5A),
                                image: 'assets/images/hr.png',
                                index: index,
                              ),
                            );
                            break;
                          case 1:
                            card = GestureDetector(
                              onTap: () {
                                context.push(Constant.hrConsultantClaimScreen);
                              },
                              child: BottomCard(
                                title: "Claims",
                                lightRed: true,
                                bgColor: const Color(0xffFFDBB5),
                                textColor: const Color(0xff5A5A5A),
                                image: 'assets/images/gridView2.png',
                                index: index,
                              ),
                            );
                            break;
                          case 2:
                            card = GestureDetector(
                              onTap: () {
                                context.push(Constant.hrReportScreen);
                              },
                              child: BottomCard(
                                title: "Reports",
                                white: true,
                                bgColor: const Color(0xffF6F6F6),
                                textColor: const Color(0xff5A5A5A),
                                image: 'assets/images/bom/bom_reports.png',
                                index: index,
                              ),
                            );
                            break;
                          case 3:
                            card = GestureDetector(
                              onTap: () {
                                context.push(Constant.hrConsultantListScreen);
                              },
                              child: BottomCard(
                                title: "Consultant",
                                orange: true,
                                bgColor: const Color(0xff4F4F4F),
                                textColor: Colors.white,
                                image: 'assets/images/consultant.png',
                                index: index,
                              ),
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
                            card = const SizedBox.shrink();
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
                )
              ],
              // MasonryGridView
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CustomLoader(
                  color: Color(0xffFF1901),
                  size: 35,
                ),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _buildTimesheetCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Timesheets",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
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
                  timesheetData?['Total Timesheets'].toString()??'0',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff007BFF),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              LegendDot(
                color: const Color(0xff28A745),
                label: "Submitted: ${timesheetData?['Submitted']?.toInt() ?? 0}",
              ),
              const SizedBox(height: 8),
              LegendDot(
                color: const Color(0xff007BFF),
                label: "Approved: ${timesheetData?['Approved']?.toInt()??'0'}",
              ),
              const SizedBox(height: 8),
              LegendDot(
                color: const Color(0xffFF1901),
                label: "Rejected: ${timesheetData?['Rejected']?.toInt()??'0'}",
              ),
            ],
          ),
        ),
        // Right side: Pie Chart
        SizedBox(
          width: 120,
          child: PieChart(
            dataMap: {
              "Submitted": (timesheetData?['Submitted'] ?? 0).toDouble(),
              "Approved": (timesheetData?['Approved'] ?? 0).toDouble(),
              "Rejected": (timesheetData?['Rejected'] ?? 0).toDouble(),
            },
            chartType: ChartType.disc,
            baseChartColor: Colors.grey[200]!,
            colorList: const [
              Color(0xFF28A745),
              Color(0xFF007BFF),
              Color(0xFFFF1901), // Rejected (red)
            ],
            chartRadius: 160,
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
            ),
            legendOptions: const LegendOptions(
              showLegends: false,
            ),
            centerText: '',
            ringStrokeWidth: 50,
          ),
        ),
      ],
    );
  }

  Widget consultancyCard({
    required String count,
    required String label,
    required String iconPath,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 47.15,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 170,
                  child: Text(
                    label,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: const Color(0xffA7A7A7),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            SvgPicture.asset(iconPath),
          ],
        ),
      ),
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
        SizedBox(
          width: 155,
          child: Text(
            label,
            style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000)),
          ),
        ),
      ],
    );
  }
}

class BottomCard extends StatelessWidget {
  final String title;
  final bool lightRed;
  final bool white;
  final bool orange;
  final Color bgColor;
  final Color textColor;
  final String image;
  final int index;

  const BottomCard({
    super.key,
    required this.title,
    this.lightRed = false,
    this.white = false,
    this.orange = false,
    required this.bgColor,
    required this.textColor,
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 280,
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore ",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w300, fontSize: 12, color: textColor)),
          SizedBox(height: (index == 1 || index == 2) ? 50 : 15),
          Image(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
