import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';

class FinanceReportScreen extends StatelessWidget {
  const FinanceReportScreen({super.key});

  final List<String> reports = const [
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summaryyyyyyyyy",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summaryyyyyyyyy",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summaryyyyyyyyy",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summaryyyyyyyyy",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summary",
    "Per Consultancy Data Summary",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderContent(context),
              Container(
                width: double.infinity,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffE4E4EF),
                      blurRadius: 0,
                      spreadRadius: 0,
                      offset: Offset(-1, 0),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      "Report Name",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 122),
                    Text(
                      "Actions",
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              reports[index],
                              style: GoogleFonts.montserrat(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff1D212D),
                              ),
                            ),
                          ),
                          CustomButton(
                            text: 'Download CSV',
                            onPressed: () {}, // Static, no action
                            width: 124,
                            height: 32,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop(); // Retain navigation back
                  },
                  child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                ),
                Text(
                  'Reports', // Updated title
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFF1901),
                  ),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  leftPadding: 2,
                  text: 'Download',
                  width: 100,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {}, // Static, no action
                  isOutlined: true,
                  svgAsset: 'assets/icons/download_report.svg',
                ),
                CustomButton(
                  leftPadding: 2,
                  text: 'Email',
                  width: 75,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {}, // Static, no action
                  isOutlined: true,
                  svgAsset: 'assets/icons/mail_report.svg',
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: CustomDropdownField(
                  label: 'Choose Client',
                  items: const ['client Name', 'Client Name'],
                  value: 'Client Name',
                  onChanged: (value) {}, // Static, no action
                  borderColor: 0xFF8D91A0,
                ),
              ),
              SvgPicture.asset(
                  'assets/icons/search_icon.svg'), // Static icon, no tap
            ],
          ),
        ],
      ),
    );
  }
}
