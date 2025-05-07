import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_table.dart';
import 'package:pie_chart/pie_chart.dart';

final List<Map<String, dynamic>> tableData = [
  {
    'claimForm': '#2984',
    'amount': '\$250.34',
    'submitDate': '5th Aug, 2024',
    'status': 'Approved',
    'statusColor': const Color(0xff28A745),
    'statusBackground': const Color.fromRGBO(0, 186, 52, 0.1),
  },
  {
    'claimForm': '#2985',
    'amount': '\$120.50',
    'submitDate': '6th Aug, 2024',
    'status': 'Submitted',
    'statusColor': const Color(0xffFFC107),
    'statusBackground': const Color.fromRGBO(255, 193, 7, 0.1),
  },
  {
    'claimForm': '#2986',
    'amount': '\$80.00',
    'submitDate': '7th Aug, 2024',
    'status': 'Pending',
    'statusColor': const Color(0xffFF1901),
    'statusBackground': const Color.fromRGBO(255, 25, 1, 0.1),
  },
  {
    'claimForm': '#2984',
    'amount': '\$250.34',
    'submitDate': '5th Aug, 2024',
    'status': 'Approved',
    'statusColor': const Color(0xff28A745),
    'statusBackground': const Color.fromRGBO(0, 186, 52, 0.1),
  },
  {
    'claimForm': '#2985',
    'amount': '\$120.50',
    'submitDate': '6th Aug, 2024',
    'status': 'Submitted',
    'statusColor': const Color(0xffFFC107),
    'statusBackground': const Color.fromRGBO(255, 193, 7, 0.1),
  },
  {
    'claimForm': '#2986',
    'amount': '\$80.00',
    'submitDate': '7th Aug, 2024',
    'status': 'Pending',
    'statusColor': const Color(0xffFF1901),
    'statusBackground': const Color.fromRGBO(255, 25, 1, 0.1),
  },
];

// final List<String> heading =['Claim Form','Amount','Submit Date','Status'];
final List<Map<String, String>> heading = [
  {'label': 'Claim Form', 'key': 'claim_form'},
  {'label': 'Amount', 'key': 'amount'},
  {'label': 'Submit Date', 'key': 'submit_date'},
  {'label': 'Status', 'key': 'status'},
];
class ConsultancyDashboardScreen extends StatefulWidget {
  const ConsultancyDashboardScreen({super.key});

  @override
  State<ConsultancyDashboardScreen> createState() => _ConsultancyDashboardScreenState();
}





class _ConsultancyDashboardScreenState extends State<ConsultancyDashboardScreen> {
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
      appBar: const CustomAppBar(showBackButton: false,image: 'assets/icons/cons_logo.png'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications

              if (showInfoSections)    Padding(
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
                   SizedBox(height:showInfoSections? 24:10),

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
                  showInfoSections=!showInfoSections;
                });
                        },
                        height: 34,
                        width: 151,
                        isOutlined: true,
                        borderRadius: 5,
                        icon:showInfoSections? Icons.keyboard_arrow_up_sharp:Icons.keyboard_arrow_down_sharp,
                      ),
                    ],
                  ),
                ),
              if (showInfoSections) ...[   const SizedBox(height: 16),
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
                                child: Text("168",
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xff007BFF))),
                              ),
                              const SizedBox(height: 80),
                              const LegendDot(
                                  color: Color(0xff28A745),
                                  label: "Hours Clocked-In: 160"),
                              const SizedBox(height: 8),
                              const LegendDot(
                                  color: Color(0xff007BFF),
                                  label: "Hours Left over : 8"),
                            ],
                          ),
                        ),
                        // Right side: Pie Chart
                        SizedBox(
                          height: 220,
                          width: 125,
                          child: PieChart(
                            dataMap: const {
                              "Clocked-In": 160,
                              "Left": 40,
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

                const SizedBox(height: 16),

                // Leave Summary
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Leave Summary",
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500, fontSize: 14)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8E8E8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LeaveTile(count: "15", label: "Availed"),
                        LeaveTile(count: "10", label: "AL"),
                        LeaveTile(count: "03", label: "MC"),
                        LeaveTile(count: "02", label: "Comp Off"),
                      ],
                    ),
                  ),
                ),

                // Claims Summary
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
                          onPressed: () {}),
                    ],
                  ),
                ),

                CustomTableView(data: tableData, heading:heading),
              ],
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    height: 750,
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
                                  context.push(Constant.timeSheet);
                                },
                                child: const BottomCard(
                                  title: "Timesheet",
                                  bgColor: Color(0xff263238),
                                  textColor: Colors.white,
                                  image: 'assets/images/gridView1.png',
                                ),
                              );
                              break;
                            case 1:
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.claimScreen);
                                },
                                child: const BottomCard(
                                  title: "Claims",
                                  lightRed: true,
                                  bgColor: Color.fromRGBO(255, 25, 1, 0.09),
                                  textColor: Color(0xff5A5A5A),
                                  image: 'assets/images/gridView2.png',
                                ),
                              );
                              break;
                            case 2:
                              card = const BottomCard(
                                title: "Leave Log",
                                white: true,
                                bgColor: Color.fromRGBO(0, 0, 0, 0.1),
                                textColor: Color(0xff5A5A5A),
                                image: 'assets/images/gridView3.png',
                              );
                              break;
                            case 3:
                              card = const BottomCard(
                                title: "Work Log",
                                orange: true,
                                bgColor: Color(0xffFFEDDA),
                                textColor: Color(0xff5A5A5A),
                                image: 'assets/images/gridView4.png',
                              );
                              break;
                            default:
                              return const SizedBox.shrink();
                          }

                          // Apply margin only for index 1 and 3
                          if (index == 1 ) {
                            return Container(
                              margin: const EdgeInsets.only(top: 30),
                              child: card,
                            );
                          } else {
                            return card;
                          }
                        }

                    )),
                // child: GridView.count(
                //   crossAxisCount: 2,
                //   shrinkWrap: true,
                //   physics: const NeverScrollableScrollPhysics(),
                //   mainAxisSpacing: 12,
                //   crossAxisSpacing: 12,
                //   childAspectRatio: 0.8,
                //   children: [
                //     GestureDetector(
                //         onTap: () {
                //           context.push(Constant.timeSheet);
                //         },
                //         child: const BottomCard(title: "Timesheet")),
                //     const BottomCard(title: "Claims", lightRed: true),
                //     const BottomCard(title: "Leave Log", white: true),
                //     const BottomCard(title: "Work Log", orange: true),
                //   ],
                // ),
              )
            ],
            // MasonryGridView
          ),
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

  const BottomCard({
    super.key,
    required this.title,
    this.lightRed = false,
    this.white = false,
    this.orange = false,
    required this.bgColor,
    required this.textColor,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 351,
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
          const SizedBox(height: 60),
          Image(
            image: AssetImage(image),
            height: 150,
            width: 187,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
