import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/operator_provider.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/services/api_service.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<Map<String, dynamic>> tableData = [
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12/08/2024 10:12:34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12/08/2024 10:12:34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12/08/2024 10:12:34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12/08/2024 10:12:34 AM',
    'status': {
      'label': 'Approved',
      'color': Colors.green,
      'background': Colors.green.withOpacity(0.1),
    },
  },
  {
    'consultancy_name': 'Encore Films',
    'license_expiry': '12/08/2024 10:12:34 AM',
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

class OperatorDashboardScreen extends ConsumerStatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  ConsumerState<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState
    extends ConsumerState<OperatorDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? timesheetData;
  Map<String, dynamic>? workLogData;
  // int get totalTimesheets =>
  //     timesheetData.values.fold(0, (sum, value) => sum + value.toInt());
  String _selectedPeriod = 'Monthly';

  String? token;

  String? _selectedClient;
  String? _selectedClientId;
  bool showInfoSections = true;
  Timer? _hideDashboardTimer;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    getClientList();
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final client =
        await ref.read(operatorProvider.notifier).getOperatorDashboard(token!);
    print('client $client');

    _rawClientList = (client['data'] != null && client['data'] is List)
        ? List<Map<String, dynamic>>.from(client['data'])
        : [];

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    log('_clientList$_rawClientList');

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();
      timesheetData = _rawClientList[0]['timesheet_stats'];
      workLogData = _rawClientList[0]['working_log'];
      print(
          '_selectedClientId11 $_selectedClientId,$_selectedClient,$timesheetData,$workLogData');

      // ✅ Optionally fetch consultants for the first client
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final operatorState = ref.watch(operatorProvider);

    final isLoading = operatorState.isLoading;
    final Map<String, dynamic> operatorDashboardData =
        operatorState.dashboardData ?? {};
    print('consultantStatedashj ${operatorState.dashboardData}');

    final List<Widget> pages = [
      _buildTimesheetCard(),
      _buildTimesheetCard(),
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                      try {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.clear();
                        if (context.mounted) {
                          context.pushReplacement(Constant.login);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error logging out: $e')),
                          );
                        }
                      }
                    },
                  ),

                  SizedBox(height: showInfoSections ? 24 : 10),

                  // User Greeting & Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Hi Bruce Lee",
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
                    SizedBox(height: 10),
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
                                  final selectedClient = _rawClientList.firstWhere(
                                        (client) => client['id'].toString() == selectedId,
                                    orElse: () => {},
                                  );
                      
                                  if (selectedClient.isNotEmpty) {
                                    setState(() {
                                      _selectedClient = selectedName;
                                      _selectedClientId = selectedId;
                                      timesheetData =
                                      selectedClient['timesheet_stats'];
                                    });
                      
                                    // getDashBoardByClient();
                                  }
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
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 180,
                                    child: PageView(
                                        controller: _pageController,
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentPage = index;
                                          });
                                        },
                                        children: pages),
                                  ),
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
                                Text(
                                  "Total Activity",
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border:
                                    Border.all(color: const Color(0xffE8E6EA)),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedPeriod,
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Color(0xff8D91A0),
                                        size: 25,
                                      ),
                                      items:  [
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
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _selectedPeriod = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          consultancyCard(
                            count: "200",
                            label: "Total Manual Review",
                            iconPath: 'assets/icons/operator1.svg',
                          ),
                          const SizedBox(height: 16),
                          consultancyCard(
                            count: "200",
                            label: "Total Auto Approved Timesheets",
                            iconPath: 'assets/icons/operator2.svg',
                          ),
                          const SizedBox(height: 16),
                          consultancyCard(
                            count: "200",
                            label: "Total Draft For Submission For The Day",
                            iconPath: 'assets/icons/operator3.svg',
                          ),
                      
                        ],
                      ),
                    )

                  ],
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.9,
                      child: MasonryGridView.builder(
                        itemCount: 4, // Adjusted to match defined cards
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
                                  context.push(Constant.humanResourcesScreen);
                                },
                                child: BottomCard(
                                  title: "Human Resources",
                                  bgColor:
                                      const Color.fromRGBO(255, 25, 1, 0.09),
                                  textColor: Colors.black,
                                  image: 'assets/images/gridView6.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 1:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.operatorClaimScreen);
                                },
                                child: BottomCard(
                                  title: "Claims",
                                  lightRed: true,
                                  bgColor:
                                      const Color.fromRGBO(255, 219, 181, 1),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView7.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 2:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.operatorReportScreen);
                                },
                                child: BottomCard(
                                  title: "Reports",
                                  white: true,
                                  bgColor:
                                      const Color.fromRGBO(246, 246, 246, 1),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView8.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 3:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.operatorFeedbackScreen);
                                },
                                child: BottomCard(
                                  title: "Feedback",
                                  orange: true,
                                  bgColor:
                                      const Color.fromRGBO(229, 241, 255, 1),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView9.png',
                                  index: index,
                                ),
                              );
                              break;

                            default:
                              card = const SizedBox.shrink();
                          }
                          if (index == 1) {
                            return Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: card,
                            );
                          }
                          return card;
                        },
                      ),
                    ),
                  ),
                ],
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
        ],
      ),
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
                  timesheetData!['Total Timesheets'].toString(),
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
                label: "Submitted: ${timesheetData!['Submitted']!.toInt()}",
              ),
              const SizedBox(height: 8),
              LegendDot(
                color: const Color(0xff007BFF),
                label: "Approved: ${timesheetData!['Approved']!.toInt()}",
              ),
              const SizedBox(height: 8),
              LegendDot(
                color: const Color(0xffFF1901),
                label: "Rejected: ${timesheetData!['Rejected']!.toInt()}",
              ),
            ],
          ),
        ),
        // Right side: Pie Chart
        SizedBox(
          width: 120,
          child: PieChart(
            dataMap: {
              "Submitted": (timesheetData!['Submitted'] ?? 0).toDouble(),
              "Approved": (timesheetData!['Approved'] ?? 0).toDouble(),
              "Rejected": (timesheetData!['Rejected'] ?? 0).toDouble(),
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
                  width: 145,
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
        Text(
          count,
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: const Color(0xff008080),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
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
              color: const Color(0xff000000),
            ),
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
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w300,
              fontSize: 12,
              color: textColor,
            ),
          ),
          SizedBox(height: (index == 1 || index == 2) ? 50 : 15),
          Image.asset(
            image,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
        ],
      ),
    );
  }
}
