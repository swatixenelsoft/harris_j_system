import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RemarksSection extends StatelessWidget {
  final List<Map<String, String>> remarks = [
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
    {
      "name": "Alena",
      "date": "31 / 05 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg" // Replace with actual image
    },
    {
      "name": "Alena",
      "date": "31 / 04 / 2024",
      "time": "09:45 AM",
      "message": "This is Approved, Thank you for the excellent contribution",
      "image": "assets/images/profile.jpg"
    },
  ];


  void _showPopup(BuildContext context) {
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
              // Blur background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.2), // Optional dim effect
                ),
              ),
              // Center popup
              Center(
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
                              child: Align(
                                alignment: Alignment.center,
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
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(255, 150, 27, 0.3),
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
                        Flexible(
                          child: ListView.builder(
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
                                              backgroundImage: AssetImage(
                                                  remark["image"]!),
                                              radius: 10,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "Approved On ${remark['date']} ${remark['time']}",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xff8D91A0),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (remark["message"]!.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          remark["message"]!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff000000),
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
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }),
              ),
            ],
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
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 25),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
        itemCount: remarks.length < 3
          ? remarks.length // If less than 3, show all
            : 2,
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
                                color: const Color(0xffFF8403), // Border color
                                width: 2, // Border thickness
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: AssetImage(remark["image"]!),
                              radius: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Approved On ${remark['date']} ${remark['time']}",
                            style: GoogleFonts.montserrat(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff8D91A0)),
                          ),
                        ],
                      ),
                      if (remark["message"]!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          remark["message"]!,
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
