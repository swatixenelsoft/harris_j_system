import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BottomTabView extends StatefulWidget {
  final List<String> tabsData;
  final bool isFromClaimScreen;
  final GetConsultantState? consultantState;

  const BottomTabView(
      {super.key,
      required this.tabsData,
      this.isFromClaimScreen = false,
      this.consultantState});

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  int _selectedIndex = 0; // Track the selected tab index
  final List<dynamic> claimsDataSets = [
    // Timesheet Overview
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
    {
      "date": "12/08/2024",
      "type": "Submitted",
      "event": "3 individual claims",
      "claimNo": "Cl04892F12",
      "image": "assets/images/profile.jpg"
    },
  ];
  final List<Map<String, dynamic>> claims = [
    {"form": "#2948", "amount": "1800.00", "count": "03"},
    {"form": "#2949", "amount": "2000.00", "count": "05"},
    {"form": "#2950", "amount": "1000.00", "count": "02"},
    {"form": "#2850", "amount": "1000.00", "count": "01"},
  ];

  Future<void> downloadAndOpenPdf(String url, String fileName) async {
    try {
      // if (Platform.isAndroid) {
      //   var status = await Permission.manageExternalStorage.request();
      //   if (!status.isGranted) {
      //     print("Permission denied");
      //     return;
      //   }
      // }

      final downloadsDir = Directory('/storage/emulated/0/Download');
      final filePath = '${downloadsDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, filePath);

      print('Downloaded to $filePath');

      ToastHelper.showSuccess(context, 'TimeSheet download successfully!');

      final result = await OpenFilex.open(filePath);
      print('Open result: ${result.message}');
    } catch (e) {
      print('Error downloading/opening PDF: $e');
    }
  }

  void _showPopup(BuildContext context, String tabName) {
    final List<dynamic> dataList = _selectedIndex == 4
        ? widget.consultantState!.getCopies
        : widget.isFromClaimScreen
        ? claimsDataSets[_selectedIndex]
        : widget.consultantState!.timesheetOverview;

    print('dataList $dataList');
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                width: MediaQuery.of(context).size.width * 0.9,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              tabName,
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            height: 20,
                            width: 20,
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 150, 27, 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close_outlined, size: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Flexible(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return _selectedIndex == 4
                              ? _buildCopiesListView(dataList[index])
                              : _buildTimelineItem(dataList[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
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
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: widget.isFromClaimScreen
                  ? const EdgeInsets.only(left: 10, right: 10, top: 10)
                  : EdgeInsets.zero,
              child: _buildTabBar(),
            )),
        widget.isFromClaimScreen
            ? _selectedIndex == 1
                ? Column(
                    children: [
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Total Work Hours",
                                style: GoogleFonts.montserrat(
                                    color: const Color(0xffDC143C),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Total Work Hours",
                                style: GoogleFonts.montserrat(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              height: 280,
                              child: ListView.builder(
                                itemCount: claims.length,
                                itemBuilder: (context, index) {
                                  final item = claims[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    // padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0xFFEDEDED)),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        // Checkbox with background color
                                        Container(
                                          width: 28,
                                          // height: 28,
                                          // padding: const EdgeInsets.all(2),
                                          decoration: const BoxDecoration(
                                            color: Color(
                                                0xffF5F5F5), // Light gray background
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(9.0),
                                                bottomLeft:
                                                    Radius.circular(9.0)),
                                          ),
                                          child: Checkbox(
                                            value: false,
                                            onChanged: (val) {},
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            side: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),

                                        const SizedBox(width: 8),

                                        // Claim details column
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Claim Form : ${item['form']}",
                                                      style: GoogleFonts
                                                          .montserrat(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: const Color(
                                                            0xff1D212D),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Amount : \$ ${item['amount']}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xff1D212D),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Text(
                                                    "individual claims ( ${item['count']} )",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: const Color(
                                                          0xff1D212D),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          255,
                                                          150,
                                                          27,
                                                          0.3), // Light orange background
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                          Icons
                                                              .cloud_download_rounded,
                                                          size: 10),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    height: 15,
                                                    width: 15,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          255,
                                                          150,
                                                          27,
                                                          0.3), // Light orange background
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                          Icons.email_rounded,
                                                          size: 10),
                                                    ),
                                                  ),
                                                  // const Icon(
                                                  //     Icons
                                                  //         .remove_red_eye_outlined,
                                                  //     size: 18,
                                                  //     color: Colors.red),
                                                  // const SizedBox(width: 8),
                                                  // const Icon(
                                                  //     Icons.download_rounded,
                                                  //     size: 18,
                                                  //     color: Colors.red),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Background Container
                              Container(
                                width: double.infinity,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(
                                      0xffF5F5F5), // Light gray background
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(11.0),
                                    bottomLeft: Radius.circular(11.0),
                                  ),
                                ),
                              ),

                              // Button on top of background
                              CustomButton(
                                width: 121,
                                height: 30,
                                isOutlined: true,
                                text: "Submit",
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    color: Colors.white,
                    height: 280,
                    child: ListView.builder(
                      itemCount: claimsDataSets.length < 7
                          ? claimsDataSets.length // If less than 3, show all
                          : 7, // Otherwise, show only 3
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildClaimItem(claimsDataSets[index]);
                      },
                    ),
                  )
            : Stack(
          children: [
            Container(
              color: Colors.white,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 40, top: 10),

                // Determine which list to use based on _selectedIndex
                child: Builder(
                  builder: (context) {
                    final list = _selectedIndex == 4
                        ? widget.consultantState!.getCopies
                        : _selectedIndex == 0
                        ? widget.consultantState!.timesheetOverview
                        : _selectedIndex == 1
                        ? widget.consultantState!.extraTimeLog
                        : _selectedIndex == 2
                        ? widget.consultantState!.payOffLog
                        : widget.consultantState!.compOffLog;

                    if (list == null || list.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Data Found',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: list.take(3).length,
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return _selectedIndex == 4
                            ? _buildCopiesListView(data)
                            : _selectedIndex == 0
                            ? _buildTimelineItem(data)
                            : _selectedIndex == 1
                            ? _buildExtraItem(data)
                            : _selectedIndex == 2
                            ? _buildPayOffItem(data)
                            : _buildCompOffItem(data);
                      },
                    );
                  },
                ),
              ),
            ),

            // Zoom Button
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => _showPopup(context, widget.tabsData[_selectedIndex]),
                child: Container(
                  height: 26,
                  width: 26,
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(255, 150, 27, 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/icons/zoom.svg',
                      height: 15,
                      width: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),



      ],
    );
  }

  Widget _buildCopiesListView(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEDEDED)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Container(
          //   width: 28,
          //   decoration: const BoxDecoration(
          //     color: Color(0xffF5F5F5),
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(9.0),
          //       bottomLeft: Radius.circular(9.0),
          //     ),
          //   ),
          //   child: Checkbox(
          //     value: false,
          //     onChanged: (val) {},
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     side: const BorderSide(color: Colors.grey),
          //   ),
          // ),
          // const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['label'],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: const Color(0xff1D212D),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "( ${item['month_title']} )",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xff1D212D),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (){
                        print(item);
                        downloadAndOpenPdf(
                         item["download_url"],
                          'timesheet_${item["month_title"]}.pdf',
                        );
                      },
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 150, 27, 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.cloud_download_rounded, size: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }



  Widget _buildTabBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(widget.tabsData.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  child: _buildTabButton(
                      widget.tabsData[index], index == _selectedIndex),
                );
              }),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (widget.isFromClaimScreen)
          GestureDetector(
            onTap: () => _showPopup(context, widget.tabsData[_selectedIndex]),
            child: Container(
              height: 26,
              width: 26,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(255, 150, 27, 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/zoom.svg',
                  height: 15,
                  width: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.red : Colors.grey.shade300,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 14),
      ),
    );
  }

  Widget _buildTimelineItem(dynamic remark) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      beforeLineStyle: const LineStyle(thickness: 2, color: Colors.white),
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 90,
        indicator: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Container(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF8403),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${remark["topLabel"]} - (1)",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xff007BFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Text(
                      remark["formatted"]!,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 15)),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffE5F1FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        remark["topLabel"]!,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff007BFF),
                        ),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 15)),
                  WidgetSpan(
                    child: Text(
                      '-',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffE5F1FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        remark["mainLabel"]??"",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff007BFF),
                        ),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 15)),
                  WidgetSpan(
                    child: Text(
                      remark["extraHours"].toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExtraItem(dynamic remark) {
    print('remark $remark');
    return TimelineTile(
      alignment: TimelineAlign.start,
      beforeLineStyle: const LineStyle(thickness: 2, color: Colors.white),
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 90,
        indicator: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Container(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF8403),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${remark["label"]}",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: const Color(0xff007BFF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Text(
                      remark["date"]!,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),

                  WidgetSpan(
                    child: Text(
                      '-',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 132, 3, 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        remark["label"]!,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xffFF1901),
                        ),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Text(
                      '-',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Text(
                      '${remark["hours"]!} hours',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayOffItem(dynamic remark) {
    print('remark $remark');
    return TimelineTile(
      alignment: TimelineAlign.start,
      beforeLineStyle: const LineStyle(thickness: 2, color: Colors.white),
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 90,
        indicator: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Container(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF8403),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  remark["date"],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color:  Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '-',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xff000000),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${remark["hours"]!} hours',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff000000),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCompOffItem(dynamic remark) {
    print('remark1 $remark');
    return TimelineTile(
      alignment: TimelineAlign.start,
      beforeLineStyle: const LineStyle(thickness: 2, color: Colors.white),
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 90,
        indicator: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Container(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF8403),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  remark["date"],
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color:  Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2, horizontal: 3),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(255, 132, 3, 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    remark["label"]!,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildClaimItem(Map<String, String> remark) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      beforeLineStyle: const LineStyle(thickness: 2, color: Colors.white),
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 90,
        indicator: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Container(
                width: 3,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xffFF8403),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(remark["image"]!),
                    radius: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Claim No # - ${remark["claimNo"]}",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: const Color(0xff007BFF),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 150, 27,
                                      0.3), // Light gray background
                                  shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/download.svg',
                                  height: 10,
                                  width: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          GestureDetector(
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 150, 27,
                                      0.3), // Light gray background
                                  shape: BoxShape.circle),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/upload_claim.svg',
                                  height: 10,
                                  width: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Text(
                      remark["date"]!,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Text(
                      '-',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Container(
                      width: 90,
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(225, 150, 27, 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            decoration: const BoxDecoration(
                                color: Color(0xffFFC107),
                                shape: BoxShape.circle),
                          ),
                          Text(
                            remark["type"]!,
                            style: GoogleFonts.montserrat(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xffFFC107),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Text(
                      '-',
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff000000),
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Text(
                      remark["event"]!,
                      style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff1D212D),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 15)),
                  // WidgetSpan(
                  //   child: Text(
                  //     remark["hoursOff"]!,
                  //     style: GoogleFonts.montserrat(
                  //       fontSize: 12,
                  //       fontWeight: FontWeight.w600,
                  //       color: const Color(0xff000000),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
