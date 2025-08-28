import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_dashboard_screen.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_table.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultancyDashboardScreen extends StatefulWidget {
  const ConsultancyDashboardScreen({super.key});

  @override
  State<ConsultancyDashboardScreen> createState() =>
      _ConsultancyDashboardScreenState();
}

class _ConsultancyDashboardScreenState
    extends State<ConsultancyDashboardScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
        onProfilePressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          context.pushReplacement(Constant.login);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notifications

              // User Greeting & Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Hey Consultancy",
                        style: GoogleFonts.montserrat(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff5A5A5A))),
                  ],
                ),
              ),

              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.9,
                    child: MasonryGridView.builder(
                        itemCount: 3,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemBuilder: (context, index) {
                          debugPrint('index $index');
                          Widget card;
                          switch (index) {
                            case 0:
                              card = GestureDetector(
                                onTap: () {
                                  context
                                      .push(Constant.consultancyUserListScreen);
                                },
                                child: BottomCard(
                                  title: "User Management",
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
                                  context.push(
                                      Constant.consultancyClientListScreen);
                                },
                                child: BottomCard(
                                  title: "Clients",
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
                              card = GestureDetector(
                                onTap: () {
                                  context.push(Constant.hrFeedBackScreen);
                                },
                                child: BottomCard(
                                  title: "Feedback",
                                  orange: true,
                                  bgColor: const Color(0xffE5F1FF),
                                  textColor: const Color(0xff5A5A5A),
                                  image: 'assets/images/gridView5.png',
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
                        })),
              ),
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
