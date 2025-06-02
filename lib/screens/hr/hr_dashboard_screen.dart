import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/widget/finance_chart_widget.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
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

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:

            SingleChildScrollView(
            child:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Bar
                  CustomAppBar(
                    showBackButton: false,
                    showProfileIcon: true,
                    image:'assets/icons/cons_logo.png',
                    onProfilePressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      context.pushReplacement(Constant.login);
                    },
                  ),
                  // User Greeting & Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Hi HR",
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff5A5A5A))),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Turn – in – rate : 90 / 100",
                        style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff000000)),
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
                        padding: const EdgeInsets.all(
                            14.0), // optional padding for spacing
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
                  const SizedBox(height: 16),
                  // Work Hour Log
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'My Dashboard',
                      style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
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
                          Container(
                            height: 220,
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
                                  child: Text("300",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xff007BFF))),
                                ),
                                const SizedBox(height: 40),
                                const LegendDot(
                                    color: Color(0xff28A745),
                                    label: "Nationality: 200"),
                                const SizedBox(height: 8),
                                const LegendDot(
                                    color: Color(0xff007BFF),
                                    label: "Permanent Resident: 20"),
                                const SizedBox(height: 8),
                                const LegendDot(
                                    color: Color(0xffFF1901),
                                    label: "Employment Pass Holders :80"),
                              ],
                            ),
                          ),
                          // Right side: Pie Chart
                          SizedBox(
                            height: 220,
                            width: 120,
                            child: PieChart(
                              dataMap: const {
                                "Nationality": 200,
                                "Gap": 2,
                                "Left": 40,
                                "Gap1": 2,
                                "Right":80,
                                "Gap2": 2,
                              },
                              chartType: ChartType.disc,
                              baseChartColor: Colors.grey[200]!,
                              colorList: const [
                                Color(0xFF28A745),
                                Colors.white,
                                Color(0xFFFF8403),
                                Colors.white,
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
                        Text("Total Activity",
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
                                Icons.keyboard_arrow_down_rounded, // Custom dropdown icon
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
                    count: "200",
                    label: "Total Number Of Employees",
                    iconPath: 'assets/icons/employee_list_icon.svg',
                  ),
                  const SizedBox(height: 16),
                  consultancyCard(
                    count: "200",
                    label: "Total Number Of New Employees",
                    iconPath: 'assets/icons/new_employee_icon.svg',
                  ),

                  const SizedBox(height: 16),
                  consultancyCard(
                    count: "200",
                    label: "Total Number Of Relieving Employees",
                    iconPath: 'assets/icons/relieving_employee_icon.svg',
                  ),
                  const SizedBox(height: 16),
                  consultancyCard(
                    count: "200",
                    label: "Total Number Of Future Joining Employees",
                    iconPath: 'assets/icons/joining_employee_icon.svg',
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
                                  context.push(Constant.hrConsultantTimesheetScreen);
                                },
                                child: BottomCard(
                                  title: "Human Resources",
                                  bgColor: const Color.fromRGBO(255, 25, 1, 0.09),
                                  textColor:const Color(0xff5A5A5A),
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
                                  bgColor:
                                  const Color(0xffFFDBB5),
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
                                  textColor:  Colors.white,
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
                        width:170,
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
