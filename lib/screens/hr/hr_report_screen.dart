import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class HrReportScreen extends StatefulWidget {
  const HrReportScreen({super.key});

  @override
  State<HrReportScreen> createState() => _HrReportScreenState();
}

class _HrReportScreenState extends State<HrReportScreen> {
  final reports = [
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

  final TextEditingController _searchController = TextEditingController();
  bool isSearchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
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
                          color: Color(0xffE4E4EF), // Adjust opacity as needed
                          blurRadius: 0, // Controls the blur effect
                          spreadRadius: 0, // Controls the size of the shadow
                          offset: Offset(-1, 0), // Moves the shadow downward
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
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
                                      color: const Color(0xff1D212D)),
                                ),
                              ),
                              CustomButton(
                                text: 'Download CSV',
                                onPressed: () {},
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
          // if (isLoading)
          //   Positioned.fill(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          //       child: Container(
          //         color: Colors.black.withOpacity(0.2),
          //         alignment: Alignment.center,
          //         child: const CustomLoader(
          //           color: Color(0xffFF1901),
          //           size: 35,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
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
          bottom: BorderSide.none, // 👈 removes bottom border
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
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                Text(
                  'Reports',
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                const SizedBox(width: 20),
                CustomButton(
                  leftPadding: 2,
                  text: 'Download',
                  width: 100,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {},
                  isOutlined: true,
                  svgAsset: 'assets/icons/download_report.svg',
                ),
                CustomButton(
                  leftPadding: 2,
                  text: 'Email',
                  width: 75,
                  height: 36,
                  borderRadius: 6,
                  onPressed: () {},
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
              if (!isSearchBarVisible)
                SizedBox(
                  width: 200,
                  child: CustomDropdownField(
                    label: 'Choose Client',
                    items: const ['client Name', 'Client Name'],
                    value: 'Client Name',
                    onChanged: (value) {},
                    borderColor: 0xFF8D91A0,
                  ),
                ),
              isSearchBarVisible
                  ? Expanded(
                      child: CustomTextField(
                        label: "Search",
                        hintText: "Search",
                        controller: _searchController,
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close,
                              size: 20, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              isSearchBarVisible = false;
                            });
                          },
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearchBarVisible = true;
                        });
                      },
                      child: SvgPicture.asset(
                        'assets/icons/search_icon.svg',
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
