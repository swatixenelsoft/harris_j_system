import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/widgets/leave_log_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTabView extends StatefulWidget {
  final GetConsultantState consultantState;
  const CustomTabView({super.key, required this.consultantState});

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  int selectedIndex = 0; // 0 -> Leave Log, 1 -> Work Summary

// Dynamic tab names
  final List<String> _tabs = ["Leave Log", "Work Summary"];

  final List leaveList = [
    {
      "type": "PDO",
      "from": "05 / 05 / 2024",
      "to": "05 / 05 / 2024",
      "days": "1/2",
      "bgColor": const Color.fromRGBO(3, 126, 255, 0.38),
      "textColor": Color(0xff007BFF)
    },
    {
      "type": "ML HD1",
      "from": "09 / 05 / 2024",
      "to": "09 / 05 / 2024",
      "days": "1/2",
      "bgColor": const Color.fromRGBO(3, 126, 255, 0.38),
      "textColor": Color(0xff007BFF)
    },
    {
      "type": "UL",
      "from": "11 / 05 / 2024",
      "to": "11 / 05 / 2024",
      "days": "1/2",
      "bgColor": const Color.fromRGBO(255, 150, 27, 0.1),
      "textColor": Color(0xffFF1901)
    },
    {
      "type": "UL HD1",
      "from": "22 / 05 / 2024",
      "to": "22 / 05 / 2024",
      "days": "1/2",
      "bgColor": const Color.fromRGBO(255, 150, 27, 0.1),
      "textColor": Color(0xffFF1901)
    },
  ];

  String? token;

  void _showPopup(BuildContext context, String tabName) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.9, // 90% of screen width
                  height: 400, // Set a fixed height here
                  padding: const EdgeInsets.only(
                      top: 10, left: 16, right: 16, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "$tabName",
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.pop();
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Color.fromRGBO(255, 150, 27,
                                    0.3), // Light orange background
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.close_outlined, size: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Wrapping _leaveLog() with a fixed height
                      SizedBox(
                        height: selectedIndex == 1
                            ? 320
                            : 290, // Adjust the height as needed
                        child: Scrollbar(
                          thickness: 4, // Adjust scrollbar thickness
                          radius: const Radius.circular(10),
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),

                            /// Add scroll if content overflows
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: selectedIndex == 1
                                  ? _workLog()
                                  : _leaveLog(true),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Tab Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 37,
                width: 270,
                decoration: const BoxDecoration(
                  color: Color(0xffF2F2F2), // Light gray background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                clipBehavior:
                    Clip.hardEdge, // Ensures children follow the border radius
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _tabs.length,
                    (index) => Expanded(
                      child: _buildTabButton(index, _tabs[index],
                          isLeft: index == 0,
                          isRight: index == _tabs.length - 1),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _showPopup(context, _tabs[selectedIndex]),
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(
                          255, 150, 27, 0.3), // Light gray background
                      shape: BoxShape.circle),
                  child: Center(
                      child: SvgPicture.asset(
                    'assets/icons/zoom.svg',
                    height: 15,
                    width: 15,
                  )),
                ),
              ),
            ],
          ),
        ),

        // Tab Content
        selectedIndex == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildLeaveLogContent(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildWorkSummaryContent(),
              ),
      ],
    );
  }

  Widget _buildTabButton(int index, String text,
      {bool isLeft = false, bool isRight = false}) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Container(
        height: 37,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.red
              : Colors.transparent, // Highlight selected tab
          borderRadius: BorderRadius.only(
            topLeft: isLeft ? const Radius.circular(12) : Radius.zero,
            topRight: isRight ? const Radius.circular(12) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildLeaveLogContent() {
    return _leaveLog(false);
  }

  Widget _buildWorkSummaryContent() {
    return _buildContent();
  }

  Widget _buildContent() {
    return Container(
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xffF2F2F2),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(4),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        // boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // First Row
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                  widget.consultantState.consultantWorkLog!['forecasted_hours']
                      .toString(),
                  "Hours Forecasted",
                  const Color(0xff008080),
                  CrossAxisAlignment.start,
                  GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff008080)),
                  GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000))),
              const SizedBox(width: 57),
              _buildStat(
                  widget.consultantState.consultantWorkLog!['logged_hours']
                      .toString(),
                  "Hours Logged",
                  const Color(0xff008080),
                  CrossAxisAlignment.start,
                  GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff008080)),
                  GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000))),
            ],
          ),
          const SizedBox(height: 20),

          // Second Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                  widget.consultantState.consultantWorkLog!['leave_summary']
                      ['Leave Log'],
                  "Leave Log",
                  Colors.red,
                  CrossAxisAlignment.center,
                  GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFF1901)),
                  GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000))),
              _buildStat(
                  widget.consultantState.consultantWorkLog!['leave_summary']
                      ['AL'],
                  "AL",
                  Colors.red,
                  CrossAxisAlignment.center,
                  GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFF1901)),
                  GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000))),
              _buildStat(
                  widget.consultantState.consultantWorkLog!['leave_summary']
                      ['ML'],
                  "ML",
                  Colors.red,
                  CrossAxisAlignment.center,
                  GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffFF1901)),
                  GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff000000))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(
    String value,
    String label,
    Color color,
    CrossAxisAlignment crossAxisAlignment,
    TextStyle mainTextStyle,
    TextStyle subTextStyle,
  ) {
    final parts = value.split('/');

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        parts.length == 2
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: parts[0].trim(), // e.g., "8.50"
                      style: mainTextStyle.copyWith(color: Colors.green),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: mainTextStyle.copyWith(color: Colors.black),
                    ),
                    TextSpan(
                      text: parts[1].trim(), // e.g., "75"
                      style: mainTextStyle.copyWith(color: Colors.red),
                    ),
                  ],
                ),
              )
            : Text(value, style: mainTextStyle),
        Text(label, style: subTextStyle),
      ],
    );
  }

  Widget _workLog() {
    return Column(
      children: [
        _buildStatCard(
          [
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['forecasted_hours']
                    .toString(),
                "Hours Forecasted",
                const Color.fromRGBO(0, 128, 128, 1)),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['logged_hours']
                    .toString(),
                "Hours Logged",
                const Color.fromRGBO(0, 128, 128, 1)),
          ],
          childAspectRatio: 5,
          gridPadding: const EdgeInsets.only(top: 10, left: 30, bottom: 10),
        ),
        const SizedBox(height: 16),
        _buildStatCard(
          [
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['Leave Log'],
                "Leave Log",
                Colors.green,
                redText: true),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['AL'],
                "AL",
                Colors.green,
                redText: true),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['ML'],
                "ML",
                Colors.green,
                redText: true),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['UL'],
                "UL",
                Colors.green,
                redText: true),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['PDO'],
                "PDO",
                Colors.green,
                redText: true),
            _buildStatItem(
                widget.consultantState.consultantWorkLog!['leave_summary']
                    ['Comp Off'],
                "Comp Off",
                Colors.green,
                redText: true),
          ],
          crossAxisCount: 2,
          childAspectRatio: 2.2,
          gridPadding: const EdgeInsets.only(top: 12, left: 10),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    List<Widget> children, {
    int crossAxisCount = 1,
    double childAspectRatio = 2,
    EdgeInsetsGeometry gridPadding =
        const EdgeInsets.only(top: 10, left: 40, bottom: 10),
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 8), // Reduced padding
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: GridView.count(
        shrinkWrap: true,
        padding: gridPadding, // Removes extra padding inside GridView
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6, // Reduced spacing between items
        mainAxisSpacing: 6, // Reduced spacing between rows
        childAspectRatio: childAspectRatio, // Now dynamic
        children: children,
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color,
      {bool redText = false}) {
    // Split value if it contains a space between two parts (e.g., "1.50 / 15")
    final parts = value.split('/');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        parts.length == 2
            ? Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: parts[0].trim(), // "1.50"
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                    TextSpan(
                      text: ' / ',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: parts[1].trim(), // "15"
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                value,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: redText ? Colors.red : color,
                ),
              ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _leaveLog(bool fromZoom) {
    final leaveLogs = widget.consultantState.consultantLeaveLog;

    return SizedBox(
      height: !fromZoom ? 130 : 350,
      child: Scrollbar(
        thickness: 4,
        radius: const Radius.circular(10),
        thumbVisibility: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: leaveLogs == null || leaveLogs.isEmpty
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      'No Leave Log Found',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              : DataTable(
                  headingRowHeight: 30,
                  columnSpacing: 20,
                  dataRowHeight: 30,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => const Color(0xffF1F4F6)),
                  headingTextStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff8D91A0),
                    fontSize: 12,
                  ),
                  columns: const [
                    DataColumn(label: Text("Type Of leave")),
                    DataColumn(label: Text("From")),
                    DataColumn(label: Text("To")),
                    DataColumn(label: Text("Days")),
                  ],
                  rows: leaveLogs.map((leave) => _buildDataRow(leave)).toList(),
                ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(leave) {
    return DataRow(cells: [
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
            color: leave['bgColor'],
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            leave['record']['leaveType'],
            style: GoogleFonts.montserrat(
                color: Color(0xff007bff),
                fontWeight: FontWeight.w500,
                fontSize: 12),
          ),
        ),
      ),
      DataCell(Text(
        leave['record']['from'],
        style: GoogleFonts.montserrat(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
      )),
      DataCell(Text(
        leave['record']['to'],
        style: GoogleFonts.montserrat(
            color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12),
      )),
      DataCell(Text(
        leave['record']['count'],
        style: GoogleFonts.montserrat(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 12),
      )),
    ]);
  }
}
