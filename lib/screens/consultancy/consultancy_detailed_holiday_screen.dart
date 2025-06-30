import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/add_holiday_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_button.dart'; // <-- Make sure this is your CustomButton

class DetailedHolidayScreen extends StatelessWidget {
  const DetailedHolidayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> detailedHolidays = [
      {'name': 'New Year', 'status': 'Active'},
      {'name': 'Chinese New Year', 'status': 'Active'},
      {'name': 'Good Friday', 'status': 'Active'},
      {'name': 'Hari Raya Puasa', 'status': 'Active'},
      {'name': 'Labour Day', 'status': 'Active'},
      {'name': 'Vesak Day', 'status': 'Active'},
      {'name': 'Hari Raya Haji', 'status': 'Active'},
      {'name': 'National Day', 'status': 'Active'},
      {'name': 'Deepavali', 'status': 'Active'},
      {'name': 'Christmas Day', 'status': 'Active'},
    ];

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double iconSize = screenWidth * 0.05;
    final double columnSpacing = 8;
    final double headingRowHeight = screenHeight * 0.05;
    final double dataRowHeight = screenHeight * 0.075;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: Column(
        children: [
          // Top Curved Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xffE8E8E8)),
                left: BorderSide(color: Color(0xffE8E8E8)),
                right: BorderSide(color: Color(0xffE8E8E8)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                  ),
                  Text(
                    'Holidays',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901),
                    ),
                  ),
                  CustomButton(
                    text: "Add Holiday",
                    height: 35,
                    width: 120,
                    leftPadding: 0,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        backgroundColor: Colors.white,
                        barrierColor: Colors.black54,
                        builder: (BuildContext context) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.47,
                                  ),
                                  child: AddHolidayForm(
                                    onSubmit: (holidayData) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Holiday added successfully")),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                // Search box
                Expanded(
                  child: CustomTextField(
                    hintText: 'Search by ID',
                    controller: TextEditingController(),
                    prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xff999999)),
                    padding: 0,
                    borderRadius: 10,
                  ),
                ),
                const SizedBox(width: 40),

                // Filter icon outside the box
                GestureDetector(
                  onTap: () {
                    // Handle filter button tap
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Filter'),
                        content: const Text('Filter options go here'),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/filter.svg',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Holiday Table
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: screenWidth),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowHeight: headingRowHeight,
                    dataRowHeight: dataRowHeight,
                    columnSpacing: columnSpacing,
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFFF1901)),
                    columns: [
                      DataColumn(
                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Holiday Name",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Status",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              "Actions",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                    rows: detailedHolidays.map((holiday) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  holiday['name'],
                                  style: GoogleFonts.montserrat(fontSize: 12),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4), // <-- moved slightly left
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEBF9F1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.circle, size: 8, color: Color(0xFF1F9254)),
                                      const SizedBox(width: 4),
                                      Text(
                                        holiday['status'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1F9254),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          DataCell(
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/pen.svg', width: iconSize),
                                    const SizedBox(width: 10),
                                    SvgPicture.asset('assets/icons/delete.svg', width: iconSize),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )

                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
