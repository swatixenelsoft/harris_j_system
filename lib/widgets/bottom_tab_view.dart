import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/providers/finance_provider.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
import 'package:harris_j_system/providers/operator_provider.dart';
import 'package:harris_j_system/screens/consultant/widget/claim_detail_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:open_filex/open_filex.dart';
import 'package:timeline_tile/timeline_tile.dart';

class BottomTabView extends StatefulWidget {
  final List<String> tabsData;
  final bool isFromClaimScreen;
  final bool isFromHrScreen;
  final GetConsultantState? consultantState;
  final GetHrState? hrState;
  final GetOperatorState? operatorState;
  final GetFinanceState? financeState;
  final String? selectedMonth;
  final String? selectedYear;

  const BottomTabView({
    super.key,
    required this.tabsData,
    this.isFromClaimScreen = false,
    this.isFromHrScreen = false,
    this.consultantState,
    this.hrState,
    this.operatorState,
    this.financeState,
    this.selectedMonth,
    this.selectedYear,
  });

  @override
  State<BottomTabView> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomTabView> {
  int _selectedIndex = 0; // Track the selected tab index

  Map<String, dynamic> get _selectedConsultantData {
    return widget.hrState?.selectedConsultantData ??
        widget.operatorState?.selectedConsultantData ??
        widget.financeState?.selectedConsultantData ??
        {};
  }

  void _showPopup(BuildContext context, String tabName) {
    late final List<dynamic> dataList;

    if (widget.isFromClaimScreen) {
      if (widget.consultantState != null) {
        // Consultant + Claim Screen
        dataList = _selectedIndex == 1
            ? widget.consultantState?.getCopies ?? []
            : widget.consultantState?.claimList ?? [];
      } else {
        // HR + Claim Screen
        dataList = _selectedIndex == 1
            ? _selectedConsultantData['get_copies'] ?? []
            : _selectedConsultantData['claim_tab'] ?? [];
      }
    }
    else if (widget.consultantState != null) {
      // Consultant normal screen
      switch (_selectedIndex) {
        case 0:
          dataList = widget.consultantState!.timesheetOverview ?? [];
          break;
        case 1:
          dataList = widget.consultantState!.extraTimeLog ?? [];
          break;
        case 2:
          dataList = widget.consultantState!.payOffLog ?? [];
          break;
        case 3:
          dataList = widget.consultantState!.compOffLog ?? [];
          break;
        case 4:
          dataList = widget.consultantState!.getCopies ?? [];
          break;
        default:
          dataList = [];
      }
    } else {
      // HR normal screen
      final selectedData = widget.hrState?.selectedConsultantData ?? {};
      switch (_selectedIndex) {
        case 0:
          dataList = selectedData['timesheet_overview'] ?? [];
          break;
        case 1:
          dataList = selectedData['extra_time_log'] ?? [];
          break;
        case 2:
          dataList = selectedData['pay_off_log'] ?? [];
          break;
        case 3:
          dataList = selectedData['comp_off_log'] ?? [];
          break;
        case 4:
          dataList = selectedData['get_copies'] ?? [];
          break;
        default:
          dataList = [];
      }
    }

    print('📦 Zoom Data List ($_selectedIndex): $dataList');

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
                      child: dataList.isEmpty
                          ? const Text("No Data Found")
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                final item = dataList[index];
                                if (widget.isFromClaimScreen) {
                                  return _selectedIndex == 0
                                      ? _buildClaimItem(item)
                                      : _buildClaimCopy(item);
                                } else {
                                  return _selectedIndex == 4
                                      ? _buildCopiesListView(item)
                                      : _selectedIndex == 0
                                          ? _buildTimelineItem(item)
                                          : _selectedIndex == 1
                                              ? _buildExtraItem(item)
                                              : _selectedIndex == 2
                                                  ? _buildPayOffItem(item)
                                                  : _buildCompOffItem(item);
                                }
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
    late final timesheetOverview;
    late final extraTimeLog;
    late final payOffLog;
    late final compOffLog;
    late final getCopies;
    late final claimTab;

    if (widget.consultantState == null) {
      timesheetOverview = _selectedConsultantData['timesheet_overview'];
      extraTimeLog = _selectedConsultantData['extra_time_log'];
      payOffLog = _selectedConsultantData['pay_off_log'];
      compOffLog = _selectedConsultantData['comp_off_log'];
      getCopies = _selectedConsultantData['get_copies'];
      claimTab = _selectedConsultantData['claim_tab'];
    } else {
      timesheetOverview = widget.consultantState!.timesheetOverview;
      extraTimeLog = widget.consultantState!.extraTimeLog;
      payOffLog = widget.consultantState!.payOffLog;
      compOffLog = widget.consultantState!.compOffLog;
      getCopies = widget.consultantState!.getCopies;
      claimTab = widget.consultantState!
          .claimList; // ✅ add this to your model if not present
    }

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
                                itemCount: getCopies.length,
                                itemBuilder: (context, index) {
                                  final item = getCopies[index];
                                  print("item $item");
                                  return _buildClaimCopy(item);
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
                      itemCount: (claimTab?.length ?? 0) < 7
                          ? (claimTab?.length ?? 0)
                          : 7,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildClaimItem(claimTab[index]);
                      },
                    ),
                  )
            : Stack(
                children: [
                  Container(
                    color: Colors.white,
                    height: 220,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 40, top: 10),

                      // Determine which list to use based on _selectedIndex
                      child: Builder(
                        builder: (context) {
                          final list = _selectedIndex == 4
                              ? getCopies
                              : _selectedIndex == 0
                                  ? timesheetOverview
                                  : _selectedIndex == 1
                                      ? extraTimeLog
                                      : _selectedIndex == 2
                                          ? payOffLog
                                          : compOffLog;

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
                      onTap: () {
                        print('gfdkj');

                        _showPopup(context, widget.tabsData[_selectedIndex]);
                      },
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                      onTap: () {
                        print(item);
                        CommonFunction().downloadAndOpenPdf(
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
            onTap: () {
              print('gfdkj');
              _showPopup(context, widget.tabsData[_selectedIndex]);
            },
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
    print('resdf $remark');
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
                        remark["topLabel"] ?? "",
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff007BFF),
                        ),
                      ),
                    ),
                  ),
                  const WidgetSpan(child: SizedBox(width: 10)),
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
                  const WidgetSpan(child: SizedBox(width: 10)),
                  WidgetSpan(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffE5F1FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        remark["mainLabel"] == 'Working'
                            ? '8'
                            : remark["mainLabel"] ?? "",
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
                      remark["extraHours"] == null
                          ? ""
                          : remark["extraHours"].toString(),
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
                    color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 3),
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

  Widget _buildClaimCopy(Map<String, dynamic> item) {
    print('itemss $item');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFEDEDED)),
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
              color: Color(0xffF5F5F5), // Light gray background
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(9.0),
                  bottomLeft: Radius.circular(9.0)),
            ),
            child: Checkbox(
              value: false,
              onChanged: (val) {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: Colors.grey),
            ),
          ),

          const SizedBox(width: 8),

          // Claim details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Claim Form : ${item['claim_no']}",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xff1D212D),
                        ),
                      ),
                    ),
                    Text(
                      "Amount : \$ ${item['amount']}",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: const Color(0xff1D212D),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "individual claims ( ${item['items'].length} )",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color(0xff1D212D),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // CommonFunction().downloadAndOpenPdf(url, fileName)
                      },
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(
                              255, 150, 27, 0.3), // Light orange background
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.cloud_download_rounded, size: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Container(
                    //   height: 15,
                    //   width: 15,
                    //   decoration: const BoxDecoration(
                    //     color: Color.fromRGBO(
                    //         255, 150, 27, 0.3), // Light orange background
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: const Center(
                    //     child: Icon(Icons.email_rounded, size: 10),
                    //   ),
                    // ),
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
  }

  Widget _buildClaimItem(Map<String, dynamic> remark) {
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
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Claim No # - ${remark["claim_no"] ?? ""}",
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
                            onTap: () {
                              print("remark554 $remark");
                              CommonFunction().downloadAndOpenPdf(
                                remark["download_url"],
                                'Claim${remark["month_title"]}.pdf',
                              );
                            },
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
                            onTap: () async {
                              log('selectedConsultantData ${widget.operatorState?.hrConsultantList}');
                              bottomSheetWidget(context, remark['entries'],remark,
                                  widget.selectedMonth!, widget.selectedYear!);
                              // context.pop(true);
                            },
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
                      remark["apply_date"] ?? "",
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 6),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(225, 150, 27, 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize
                            .min, // <-- This is key for dynamic width
                        children: [
                          Container(
                            height: 10,
                            width: 10,
                            margin: const EdgeInsets.only(right: 4),
                            decoration: const BoxDecoration(
                              color: Color(0xffFFC107),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            remark["status"] ?? "",
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
                  const WidgetSpan(child: SizedBox(width: 5)),
                  WidgetSpan(
                    child: Text(
                      "${remark['count'] ?? ""} individual claims",
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

  void bottomSheetWidget(BuildContext context, List entries,remark,
      String selectedMonth, String selectedYear)
  {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        print('entriessss $entries');
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.6,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Claims',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child:
                            Image.asset('assets/icons/close.png', height: 25),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(
                            "assets/images/profile.jpg"), // Replace with your asset
                        backgroundColor: Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Bruce Lee",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: const Color(0xff2A282F))),
                            Text("Employee Id : Emp14982",
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: const Color(0xffA8A6AC))),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Claim Form",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: const Color(0xff2A282F))),
                          Text(remark['claim_no'],
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: const Color(0xff2A282F))),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    "Individual Claims ( ${remark['count']} )",
                    style: GoogleFonts.montserrat(
                        color: const Color(0xffFF1901),
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Amount : \$${entries.fold<double>(
                          0.0,
                              (double sum, dynamic entry) =>
                          sum + (double.tryParse(entry['amount'].toString()) ?? 0.0),
                        )}",
                        style: GoogleFonts.montserrat(
                            color: const Color(0xff1D212D),
                            fontWeight: FontWeight.w700,
                            fontSize: 14),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withOpacity(0.1), // Adjust opacity as needed
                              blurRadius: 4, // Controls the blur effect
                              spreadRadius:
                                  0, // Controls the size of the shadow
                              offset: const Offset(
                                  0, 0), // Moves the shadow downward
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 13,
                              height: 13,
                              decoration: const BoxDecoration(
                                  color: Color(0xff007BFF),
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 5),
                             Text(remark['status'],
                                style: TextStyle(color: Color(0xff007BFF))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                  thickness: 1,
                ),
                ExpenseListView(
                    entries: entries,
                    isFromHrScreen:widget.isFromHrScreen,
                    selectedMonth: selectedMonth,
                    selectedYear: selectedYear),
              ],
            ),
          ),
        );
      },
    );
  }
}
