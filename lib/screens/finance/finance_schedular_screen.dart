import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';


class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({super.key});

  @override
  State<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  final Color brandRed = const Color(0xFFFF1901);

  final TextEditingController _logController = TextEditingController();
  String? selectedDate = "20/04/2025";
  String? selectedTime = "1:41:14 AM";

  final List<String> dateItems = [
    "20/04/2025",
    "21/04/2025",
    "22/04/2025",
  ];
  final List<String> timeItems = [
    "1:41:14 AM",
    "2:00:00 PM",
    "6:30:15 PM",
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    const double columnWidthRatio = 0.85;
    final double columnWidth = screenWidth * columnWidthRatio;

    final List<String> columnLabels = [
      'Date & Timestamp',
      'Client Name',
      'Group Name',
      'Frequency',
      'Log Type',
      'Expiration Timestamp',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Table Section
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: screenWidth),
              child: DataTable(
                columnSpacing: 30,
                headingRowHeight: 48,
                dataRowMinHeight: 52,
                dataRowMaxHeight: 52,
                headingRowColor: WidgetStateColor.resolveWith(
                      (states) => const Color(0xFFF5F5F5),
                ),
                columns: columnLabels
                    .map((label) => DataColumn(
                  label: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: columnWidth),
                    child: Text(
                      label,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: label == 'Date & Timestamp'
                          ? TextAlign.left
                          : TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ))
                    .toList(),
                rows: [
                  _buildDataRow(columnWidth, [
                    '25/06/2025 10:30',
                    'Bruce Lee',
                    'Group A',
                    'Daily',
                    'Info',
                    '25/06/2025 10:32',
                  ]),
                  _buildDataRow(columnWidth, [
                    '26/06/2025 09:15',
                    'Allison Schleifer',
                    'Group B',
                    'Weekly',
                    'Error',
                    '26/06/2025 09:20',
                  ]),
                  _buildDataRow(columnWidth, [
                    '26/06/2025 14:45',
                    'Charlie Vetrovs',
                    'Group C',
                    'Monthly',
                    'Info',
                    '26/06/2025 14:50',
                  ]),
                  _buildDataRow(columnWidth, [
                    '27/06/2025 08:00',
                    'Lincoln Geidt',
                    'Group D',
                    'Daily',
                    'Warning',
                    '27/06/2025 08:05',
                  ]),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, height: 40),

          // Header Row
          Row(
            children: [
              const SizedBox(width: 16),
              Text(
                "Details",
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: brandRed,
                ),
              ),
              const Expanded(
                child: Divider(thickness: 1, indent: 15, endIndent: 15,color: Colors.black,),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form Fields
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: CustomDropdownField(
                    label: "Date",
                    value: selectedDate,
                    items: dateItems,
                    onChanged: (val) {
                      setState(() {
                        selectedDate = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomDropdownField(
                    label: "Time",
                    value: selectedTime,
                    items: timeItems,
                    onChanged: (val) {
                      setState(() {
                        selectedTime = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomTextField(
              label: "Log Description",
              hintText: "Max 200 words are allowed",
              controller: _logController,
              maxLines: 5,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // or MainAxisAlignment.start
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    'assets/icons/saveclose.svg',
                    height: 35,
                    width: 35,
                  ),
                ),
                Expanded(
                  child: SvgPicture.asset(
                    'assets/icons/cancell.svg',
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  DataRow _buildDataRow(double columnWidth, List<String> cells) {
    return DataRow(
      cells: cells.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        return DataCell(
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: columnWidth),
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: index == 0 ? TextAlign.left : TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
    );
  }
}