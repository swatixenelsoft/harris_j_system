import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
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

class OperatorDashboardScreen extends StatefulWidget {
  const OperatorDashboardScreen({super.key});

  @override
  State<OperatorDashboardScreen> createState() =>
      _OperatorDashboardScreenState();
}

class _OperatorDashboardScreenState extends State<OperatorDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, double> timesheetData = {
    'Submitted': 290,
    'Approved': 240,
    'Draft': 10,
    'Rejected': 10,
  };
  int get totalTimesheets =>
      timesheetData.values.fold(0, (sum, value) => sum + value.toInt());
  String _selectedPeriod = 'Monthly';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Refresh UI on search input
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
              // User Greeting & Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Hi Operator",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5A5A5A),
                  ),
                ),
              ),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomTextField(
                  label: 'Search',
                  hintText: 'Start typing or click to see clients/consultant',
                  controller: _searchController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset('assets/icons/search_icon.svg'),
                    ),
                  ),
                  suffixIcon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 30,
                    color: Color(0xff8D91A0),
                  ),
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
                                "$totalTimesheets",
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
                              label:
                                  "Submitted: ${timesheetData['Submitted']!.toInt()}",
                            ),
                            const SizedBox(height: 8),
                            LegendDot(
                              color: const Color(0xff007BFF),
                              label:
                                  "Approved: ${timesheetData['Approved']!.toInt()}",
                            ),
                            const SizedBox(height: 8),
                            LegendDot(
                              color: const Color(0xff8D91A0),
                              label:
                                  "Draft: ${timesheetData['Draft']!.toInt()}",
                            ),
                            const SizedBox(height: 8),
                            LegendDot(
                              color: const Color(0xffFF1901),
                              label:
                                  "Rejected: ${timesheetData['Rejected']!.toInt()}",
                            ),
                          ],
                        ),
                      ),
                      // Right side: Pie Chart
                      SizedBox(
                        width: 120,
                        child: PieChart(
                          dataMap: {
                            "Submitted": timesheetData['Submitted']!,
                            " ": 5, // Spacer
                            "Approved": timesheetData['Approved']!,
                            "  ": 5, // Spacer
                            "Draft": timesheetData['Draft']!,
                            "   ": 5, // Spacer
                            "Rejected": timesheetData['Rejected']!,
                          },
                          chartType: ChartType.disc,
                          baseChartColor: Colors.grey[200]!,
                          colorList: const [
                            Color(0xFF28A745),
                            Colors.transparent, // Spacer 1
                            Color(0xFF007BFF),
                            Colors.transparent, // Spacer 2
                            Color(0xFF8D91A0),
                            Colors.transparent, // Spacer 3
                            Color(0xFFFF1901),
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
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
                        border: Border.all(color: const Color(0xffE8E6EA)),
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
                          items: const [
                            DropdownMenuItem(
                              value: 'Monthly',
                              child: Text(
                                'Monthly',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff8D91A0),
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Weekly',
                              child: Text(
                                'Weekly',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff8D91A0),
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  child: MasonryGridView.builder(
                    itemCount: 5, // Adjusted to match defined cards
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
                              bgColor: const Color.fromRGBO(255, 25, 1, 0.09),
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
                              bgColor: const Color.fromRGBO(255, 219, 181, 1),
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
                              bgColor: const Color.fromRGBO(246, 246, 246, 1),
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
                              bgColor: const Color.fromRGBO(229, 241, 255, 1),
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
