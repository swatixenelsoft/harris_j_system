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
import 'package:pie_chart/pie_chart.dart';

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


class BomDashboardScreen extends StatefulWidget {
  const BomDashboardScreen({super.key});

  @override
  State<BomDashboardScreen> createState() => _BomDashboardScreenState();
}

class _BomDashboardScreenState extends State<BomDashboardScreen> {
  bool showInfoSections = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showInfoSections = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          showBackButton: false, image: 'assets/images/bom/bom_logo.png'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications

              if (showInfoSections)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
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
                                padding: const EdgeInsets.only(
                                    left: 32.0), // align with text after icon
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
                    ),
                  ),
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
                      text: "View DashBoard",
                      onPressed: () {
                        setState(() {
                          showInfoSections = !showInfoSections;
                        });
                      },
                      height: 34,
                      width: 151,
                      isOutlined: true,
                      borderRadius: 5,
                      icon: showInfoSections
                          ? Icons.keyboard_arrow_up_sharp
                          : Icons.keyboard_arrow_down_sharp,
                    ),
                  ],
                ),
              ),
              if (showInfoSections) ...[
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
                        Container(
                          height: 220,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Total No. Of Consultancy:",
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
                                  label: "Active: 200"),
                              const SizedBox(height: 8),
                              const LegendDot(
                                  color: Color(0xff007BFF),
                                  label: "Inactive: 100"),
                              const SizedBox(height: 8),
                              const LegendDot(
                                  color: Color(0xffFF1901),
                                  label: "Rejected: 0"),
                            ],
                          ),
                        ),
                        // Right side: Pie Chart
                        SizedBox(
                          height: 220,
                          width: 120,
                          child: PieChart(
                            dataMap: const {
                              "Clocked-In": 160,
                              "Gap": 2,
                              "Left": 40,
                              "Gap1": 2,
                            },
                            chartType: ChartType.disc,
                            baseChartColor: Colors.grey[200]!,
                            colorList: const [
                              Color(0xFF28A745),
                              Colors.white,
                              Color(0xFFFF8403),
                              Colors.white,
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

                const SizedBox(height: 16),
                consultancyCard(
                  count: "200",
                  label: "Active Consultancies",
                  iconPath: 'assets/icons/active.svg',
                ),
                const SizedBox(height: 16),
                consultancyCard(
                  count: "100",
                  label: "Inactive Consultancies",
                  iconPath: 'assets/icons/inactive.svg',
                ),
                const SizedBox(height: 16),
                FinanceChartCard(),

                // Claims Summary
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("List Of Consultancy",
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
                          onPressed: () {}),
                    ],
                  ),
                ),

                CustomTableView(data: tableData,heading:heading),
              ],
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.8,
                    child: MasonryGridView.builder(
                        itemCount: 4,
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
                                  context.push(Constant.bomConsultancyScreen);
                                },
                                child: BottomCard(
                                  title: "Consultancy",
                                  bgColor: const Color(0xff263238),
                                  textColor: Colors.white,
                                  image:
                                      'assets/images/bom/bom_consultancy.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 1:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.bomFinanceScreen);
                                },
                                child: BottomCard(
                                  title: "Finances",
                                  lightRed: true,
                                  bgColor:
                                      const Color.fromRGBO(255, 25, 1, 0.09),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/bom/bom_finances.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 2:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.bomReportScreen);
                                },
                                child: BottomCard(
                                  title: "Reports",
                                  white: true,
                                  bgColor: const Color.fromRGBO(0, 0, 0, 0.1),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/bom/bom_reports.png',
                                  index: index,
                                ),
                              );
                              break;
                            case 3:
                              card = BottomCard(
                                title: "Static Settings",
                                orange: true,
                                bgColor: const Color(0xffFFEDDA),
                                textColor: const Color(0xff5A5A5A),
                                image:
                                    'assets/images/bom/bom_static_settings.png',
                                index: index,
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
                        })),

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
        height: 138,
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
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xffA7A7A7),
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
      height: 280,
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
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 16, color: textColor)),
          const SizedBox(height: 5),
          Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore ",
              style: TextStyle(
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
