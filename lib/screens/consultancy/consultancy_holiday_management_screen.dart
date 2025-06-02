import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/consultancy/add_holiday_screen.dart';
import 'package:harris_j_system/screens/consultancy/create_holiday_profile_screen.dart';

class HolidayManagementScreen extends StatefulWidget {
  const HolidayManagementScreen({Key? key}) : super(key: key);

  @override
  State<HolidayManagementScreen> createState() => _HolidayManagementScreenState();
}

class _HolidayManagementScreenState extends State<HolidayManagementScreen> {
  final List<Map<String, dynamic>> holidays = List.generate(
    16,
        (index) => {'name': 'Singapore Holiday', 'status': 'Active'},
  );

  final List<Map<String, dynamic>> detailedHolidays = [
    {'name': 'New Year\'s Day', 'status': 'Active'},
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

  bool showDetailedTable = false;

  void _addHoliday(Map<String, dynamic> newHoliday) {
    setState(() {
      detailedHolidays.add(newHoliday);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${newHoliday['name']}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    final double columnSpacing = 8;
    final double headingRowHeight = screenHeight * 0.05;
    final double dataRowHeight = screenHeight * 0.075;
    final double iconSize = screenWidth * 0.05;
    final double fontSize = screenWidth * 0.035;
    final double padding = screenWidth * 0.04; // Padding for main screen elements

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              if (!showDetailedTable)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/search.svg',
                              width: iconSize,
                              height: iconSize,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Search clicked')),
                              );
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/vert.svg',
                              width: iconSize,
                              height: iconSize,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('More options clicked')),
                              );
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            backgroundColor: Colors.white, // Match form background
                            barrierColor: Colors.black54,
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: screenWidth, // Full screen width
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: screenHeight * 0.7,
                                      ),
                                      child: const CreateHolidayProfileForm(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1901),
                          padding: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                        child: Text(
                          'Create Holiday Profile',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (showDetailedTable)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: padding,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/search.svg',
                              width: iconSize,
                              height: iconSize,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Search clicked')),
                              );
                            },
                          ),
                          IconButton(
                            icon: SvgPicture.asset(
                              'assets/icons/vert.svg',
                              width: iconSize,
                              height: iconSize,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('More options clicked')),
                              );
                            },
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            ),
                            backgroundColor: Colors.white, // Match form background
                            barrierColor: Colors.black.withOpacity(0.5),
                            builder: (BuildContext context) {
                              return SizedBox(
                                width: screenWidth, // Full screen width
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(
                                        maxHeight: screenHeight * 0.5,
                                      ),
                                      child: AddHolidayForm(
                                        onSubmit: _addHoliday,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF1901),
                          padding: EdgeInsets.symmetric(
                            horizontal: padding,
                            vertical: screenHeight * 0.015,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.02),
                          ),
                        ),
                        child: Text(
                          'Add Holiday',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth,
                  ),
                  child: DataTable(
                    headingRowHeight: headingRowHeight,
                    dataRowHeight: dataRowHeight,
                    headingRowColor: MaterialStateProperty.all(const Color(0xFFFF1901)),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    columnSpacing: columnSpacing,
                    decoration: const BoxDecoration(
                      border: Border(right: BorderSide.none, left: BorderSide.none),
                    ),
                    columns: [
                      DataColumn(
                        label: Container(
                          constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                          child: Text(
                            'Holiday Name',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                          child: Text(
                            'Status',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                          child: Text(
                            'Actions',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: fontSize,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    rows: (showDetailedTable ? detailedHolidays : holidays)
                        .asMap()
                        .entries
                        .map((entry) {
                      int index = entry.key;
                      final holiday = entry.value;
                      return DataRow(
                        cells: [
                          DataCell(
                            GestureDetector(
                              onTap: () {
                                if (!showDetailedTable &&
                                    holiday['name'] == 'Singapore Holiday') {
                                  setState(() {
                                    showDetailedTable = true;
                                  });
                                }
                              },
                              child: Container(
                                constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
                                child: Text(
                                  holiday['name'],
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: holiday['status'] == 'Active'
                                    ? const Color(0xFFEBF9F1)
                                    : const Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: screenWidth * 0.02,
                                    color: holiday['status'] == 'Active'
                                        ? const Color(0xFF1F9254)
                                        : Colors.red,
                                  ),
                                  SizedBox(width: screenWidth * 0.005),
                                  Text(
                                    holiday['status'],
                                    style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      height: 1.0,
                                      letterSpacing: 0,
                                      color: holiday['status'] == 'Active'
                                          ? const Color(0xFF1F9254)
                                          : Colors.red[900],
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              constraints: BoxConstraints(maxWidth: screenWidth * 0.3),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('View ${holiday['name']}')),
                                      );
                                    },
                                    child: SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: SvgPicture.asset(
                                        'assets/icons/fullscreen.svg',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  GestureDetector(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Edit ${holiday['name']}')),
                                      );
                                    },
                                    child: SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: SvgPicture.asset(
                                        'assets/icons/pen.svg',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.01),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (showDetailedTable) {
                                          detailedHolidays.removeAt(index);
                                        } else {
                                          holidays.removeAt(index);
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Deleted ${holiday['name']}')),
                                      );
                                    },
                                    child: SizedBox(
                                      width: iconSize,
                                      height: iconSize,
                                      child: SvgPicture.asset(
                                        'assets/icons/delete.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}