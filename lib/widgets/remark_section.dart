import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/providers/finance_provider.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
import 'package:harris_j_system/providers/operator_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RemarksSection extends StatelessWidget {
  final GetConsultantState? consultantState;
  final GetHrState? hrState;
  final GetOperatorState? operatorState;
  final GetFinanceState? financeState;

  const RemarksSection({super.key, this.consultantState, this.hrState,this.operatorState,this.financeState});

  List<dynamic> get _remarks {
    if (consultantState != null) {
      return consultantState!.consultantTimesheetRemark?['data'] ?? [];
    } else if (hrState != null) {
      return hrState!.selectedConsultantData['remarks'] ?? [];
    } else if (operatorState != null) {
      return operatorState!.selectedConsultantData['remarks'] ?? [];
    }
    else if (financeState != null) {
      return financeState!.selectedConsultantData['remarks'] ?? [];
    }
    return [];
  }

  void _showPopup(BuildContext context) {
    final remarks =_remarks;

    print('Popup remarks: $remarks');

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
              Center(
                child: StatefulBuilder(
                  builder: (context, setState) {
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
                                    "Remarks",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(255, 150, 27, 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close_outlined,
                                      size: 15),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: remarks.isEmpty
                                ? const Text("No Remarks Found")
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount: remarks.length,
                                    itemBuilder: (context, index) {
                                      final remark = remarks[index];
                                      return TimelineTile(
                                        alignment: TimelineAlign.start,
                                        beforeLineStyle: const LineStyle(
                                            thickness: 2, color: Colors.white),
                                        indicatorStyle: IndicatorStyle(
                                          width: 20,
                                          height: 75,
                                          indicator: Column(
                                            children: [
                                              Container(
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
                                        endChild: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffFF8403),
                                                        width: 2,
                                                      ),
                                                    ),
                                                    child: const CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                          "assets/images/profile.jpg"),
                                                      radius: 10,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    "Approved On ${remark['formatted'] ?? remark['status_time']}",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff8D91A0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (remark["remarks"] !=
                                                  null) ...[
                                                const SizedBox(height: 4),
                                                Text(
                                                  remark["remarks"] ?? "",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff000000),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final remarks=_remarks;
    print('remarks $remarks');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Remarks",
              style: GoogleFonts.montserrat(
                  fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showPopup(context),
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
        ),

        const SizedBox(height: 16),

        // Check for empty/null remarks
        if (remarks == null || remarks.isEmpty)
          const Center(
            child: Text(
              "No Remarks Found",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: remarks.length < 3 ? remarks.length : 2,
              itemBuilder: (context, index) {
                final remark = remarks[index];
                return TimelineTile(
                  alignment: TimelineAlign.start,
                  beforeLineStyle:
                      const LineStyle(thickness: 2, color: Colors.white),
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    height: 75,
                    indicator: Column(
                      children: [
                        Container(
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
                  endChild: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
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
                                radius: 12,
                                backgroundImage: (remark['avatar'] != null && remark['avatar'].toString().isNotEmpty)
                                    ? NetworkImage(remark['avatar'])
                                    : AssetImage('assets/images/profile.jpg') as ImageProvider,
                              ),

                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Approved On ${remark['formatted'] ?? remark['status_time']}",
                              style: GoogleFonts.montserrat(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff8D91A0)),
                            ),
                          ],
                        ),
                        if (remark["remarks"] != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            remark["remarks"]!,
                            style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff000000)),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
