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

// TimesheetActivityBox with PageView and Dots
class TimesheetActivityBox extends StatefulWidget {
  final List<Map<String, double>> timesheetActivityDatasets;

  const TimesheetActivityBox(
      {super.key, required this.timesheetActivityDatasets});

  @override
  _TimesheetActivityBoxState createState() => _TimesheetActivityBoxState();
}

class _TimesheetActivityBoxState extends State<TimesheetActivityBox> {
  int _currentPage = 0;
  final List<Color> colorList = const [
    Color(0xff28A745),
    Color(0xffFF1901),
    Color(0xff8D91A0),
    Color(0xff007BFF),
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> dashboardPages = widget.timesheetActivityDatasets
        .asMap()
        .entries
        .map((entry) => _buildPieChart(context, entry.value))
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "TOTAL TIMESHEET ACTIVITY:",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 10, // reduced from 14
                    color: Colors.black,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 18, // reduced from 20
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color(0xffE5F1FF),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '(',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        ...widget.timesheetActivityDatasets[_currentPage].values
                            .toList()
                            .asMap()
                            .entries
                            .map((entry) {
                              final index = entry.key;
                              final value = entry.value;
                              final color = colorList[index % colorList.length];
                              return TextSpan(
                                text: value.toInt().toString(),
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: color,
                                ),
                              );
                            })
                            .toList()
                            .insertBetween(
                              TextSpan(
                                text: ', ',
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                        TextSpan(
                          text:
                              ')/${widget.timesheetActivityDatasets[_currentPage].values.fold(0, (sum, value) => sum + value.toInt())}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // reduced from 16
            SizedBox(
              height: 220, // reduced from 300
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: dashboardPages,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: LegendDot(
                          color: colorList[0],
                          label: widget
                              .timesheetActivityDatasets[_currentPage].keys
                              .toList()[0],
                          backgroundColor: const Color(0xffF2F2F2),
                          textColor: colorList[0],
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (widget
                              .timesheetActivityDatasets[_currentPage].length >
                          1)
                        Expanded(
                          child: LegendDot(
                            color: colorList[1],
                            label: widget
                                .timesheetActivityDatasets[_currentPage].keys
                                .toList()[1],
                            backgroundColor: const Color(0xffF2F2F2),
                            textColor: colorList[1],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (widget.timesheetActivityDatasets[_currentPage].length > 2)
                    Row(
                      children: [
                        Expanded(
                          child: LegendDot(
                            color: colorList[2],
                            label: widget
                                .timesheetActivityDatasets[_currentPage].keys
                                .toList()[2],
                            backgroundColor: const Color(0xffF2F2F2),
                            textColor: colorList[2],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  if (widget.timesheetActivityDatasets[_currentPage].length > 3)
                    Row(
                      children: [
                        Expanded(
                          child: LegendDot(
                            color: colorList[3],
                            label: widget
                                .timesheetActivityDatasets[_currentPage].keys
                                .toList()[3],
                            backgroundColor: const Color(0xffF2F2F2),
                            textColor: colorList[3],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(dashboardPages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? Colors.black
                        : Colors.grey.withOpacity(0.5),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, Map<String, double> data) {
    return Center(
      child: PieChart(
        dataMap: data,
        colorList: colorList,
        chartRadius: 174,
        chartValuesOptions: const ChartValuesOptions(
          showChartValues: false,
        ),
        legendOptions: const LegendOptions(
          showLegends: false,
        ),
        centerText: '',
        ringStrokeWidth: 30,
      ),
    );
  }
}

class FinanceDashboardScreen extends StatefulWidget {
  const FinanceDashboardScreen({super.key});

  @override
  State<FinanceDashboardScreen> createState() => _FinanceDashboardScreenState();
}

class _FinanceDashboardScreenState extends State<FinanceDashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, double>> timesheetActivityDatasets = [
    {
      'Invoice raised': 10,
      'Rejected Invoice': 23,
      'Pending Invoice to be raised': 12,
      'Timesheet pending with HR/Operator': 20,
    },
    {
      'Invoice raised': 12,
      'Rejected Invoice': 18,
      'Pending Invoice to be raised': 15,
      'Claim pending with HR/Operator': 20,
    },
    {
      'Total schedules running successfully': 25,
      'Total schedules failed': 15,
      'Total schedulers to run on next planned day': 25,
    },
  ];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        precacheImage(
            const AssetImage('assets/images/gridView10.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView11.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView12.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView13.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView14.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView15.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView16.png'), context);
        precacheImage(
            const AssetImage('assets/images/gridView17.png'), context);
      });
    }
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Hi Finance",
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff5A5A5A),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TimesheetActivityBox(
                  timesheetActivityDatasets: timesheetActivityDatasets),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MasonryGridView.count(
                  itemCount: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemBuilder: (context, index) {
                    print('Building tile for index: $index');
                    Widget card;
                    switch (index) {
                      case 0:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeScreen);
                          },
                          child: BottomCard(
                            title: "Finance",
                            bgColor: const Color.fromRGBO(255, 25, 1, 0.09),
                            textColor: Colors.black,
                            image: 'assets/images/gridView10.png',
                            index: index,
                          ),
                        );
                        break;
                      case 1:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeClaimScreen);
                          },
                          child: BottomCard(
                            title: "Claims",
                            lightRed: true,
                            bgColor: const Color.fromRGBO(255, 236, 245, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView11.png',
                            index: index,
                          ),
                        );
                        break;
                      case 2:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeInvoiceScreen);
                          },
                          child: BottomCard(
                            title: "Invoice",
                            white: true,
                            bgColor: const Color.fromRGBO(248, 255, 229, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView12.png',
                            index: index,
                          ),
                        );
                        break;
                      case 3:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeClaimsInvoiceScreen);
                          },
                          child: BottomCard(
                            title: "Claims Invoice",
                            orange: true,
                            bgColor: const Color.fromRGBO(246, 229, 255, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView13.png',
                            index: index,
                          ),
                        );
                        break;
                      case 4:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeAddGroupScreen);
                          },
                          child: BottomCard(
                            title: "Add Group",
                            orange: true,
                            bgColor: const Color.fromRGBO(229, 229, 229, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView14.png',
                            index: index,
                          ),
                        );
                        break;
                      case 5:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeReportScreen);
                          },
                          child: BottomCard(
                            title: "Reports",
                            orange: true,
                            bgColor: const Color.fromRGBO(246, 246, 246, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView15.png',
                            index: index,
                          ),
                        );
                        break;
                      case 6:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeStaticSettingScreen);
                          },
                          child: BottomCard(
                            title: "Static Settings",
                            orange: true,
                            bgColor: const Color.fromRGBO(255, 237, 218, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView16.png',
                            index: index,
                          ),
                        );
                        break;
                      case 7:
                        card = GestureDetector(
                          onTap: () {
                            context.push(Constant.financeFeedbackScreen);
                          },
                          child: BottomCard(
                            title: "Feedback",
                            orange: true,
                            bgColor: const Color.fromRGBO(229, 241, 255, 1),
                            textColor: const Color(0xff5A5A5A),
                            image: 'assets/images/gridView17.png',
                            index: index,
                          ),
                        );
                        break;
                      default:
                        card = const SizedBox.shrink();
                    }
                    return index == 1
                        ? Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: card,
                          )
                        : card;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

extension ListTextSpanExtension on List<TextSpan> {
  List<TextSpan> insertBetween(TextSpan separator) {
    final result = <TextSpan>[];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
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
  final Color backgroundColor;
  final Color textColor;

  const LegendDot({
    super.key,
    required this.color,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
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
      child: Container(
        padding:
            const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
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
            const SizedBox(height: 10),
            Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w300,
                fontSize: 12,
                color: textColor,
              ),
            ),
            const SizedBox(height: 50),
            Image.asset(
              image,
              fit: BoxFit.contain,
              height: 181,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $image, Error: $error');
                return const Icon(Icons.error, size: 50);
              },
            ),
          ],
        ),
      ),
    );
  }
}
