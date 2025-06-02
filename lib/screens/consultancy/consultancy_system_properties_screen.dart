import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HolidayPropertyScreen extends StatefulWidget {
  const HolidayPropertyScreen({Key? key}) : super(key: key);

  @override
  State<HolidayPropertyScreen> createState() => _HolidayPropertyScreenState();
}

class _HolidayPropertyScreenState extends State<HolidayPropertyScreen> {
  final List<Map<String, dynamic>> holidays = [
    {'name': 'Leave Type', 'status': 'Active'},
    {'name': 'Expense Type', 'status': 'Active'},
    {'name': 'Claim Status', 'status': 'Active'},
    {'name': 'Claim Form', 'status': 'Inactive'},
    {'name': 'Status', 'status': 'Active'},
    {'name': 'Designation', 'status': 'Active'},
    {'name': 'Gender', 'status': 'Active'},
    {'name': 'Document Type', 'status': 'Inactive'},
    {'name': 'Leave Type', 'status': 'Active'},
  ];

  final Map<int, List<Map<String, String>>> optionsMap = {
    0: [
      {'name': 'Medical Leave', 'value': '1'},
      {'name': 'Casual Leave', 'value': '2'},
      {'name': 'Paid Leave', 'value': '3'},
      {'name': 'Unpaid Leave', 'value': '4'},
    ],
    1: [
      {'name': 'Travel', 'value': '10'},
      {'name': 'Food', 'value': '11'},
    ],
    2: [
      {'name': 'Approved', 'value': '21'},
      {'name': 'Rejected', 'value': '22'},
    ],
    3: [
      {'name': 'Form A', 'value': 'A'},
      {'name': 'Form B', 'value': 'B'},
    ],
    4: [
      {'name': 'Active', 'value': '1'},
      {'name': 'Inactive', 'value': '0'},
    ],
    5: [
      {'name': 'Manager', 'value': 'MGR'},
      {'name': 'Developer', 'value': 'DEV'},
      {'name': 'Tester', 'value': 'QA'},
    ],
    6: [
      {'name': 'Male', 'value': 'M'},
      {'name': 'Female', 'value': 'F'},
      {'name': 'Other', 'value': 'O'},
    ],
    7: [
      {'name': 'Passport', 'value': 'PASS'},
      {'name': 'Aadhaar Card', 'value': 'AAD'},
      {'name': 'Pan Card', 'value': 'PAN'},
    ],
    8: [
      {'name': 'Maternity Leave', 'value': 'ML'},
      {'name': 'Paternity Leave', 'value': 'PL'},
    ],
  };

  int? _expandedRowIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
            child: Column(
              children: [
                // Header Row
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  color: const Color.fromRGBO(242, 242, 242, 1),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          "Property Name",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Status",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Actions",
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.grey, thickness: 1.0),
                // List of Properties
                ListView.builder(
                  itemCount: holidays.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = holidays[index];
                    final bool isActive = item['status'] == 'Active';
                    final bool isExpanded = _expandedRowIndex == index;

                    return Column(
                      children: [
                        // Property Row
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          color: Colors.white,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  item['name'],
                                  style: GoogleFonts.spaceGrotesk(fontSize: 14),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isActive ? const Color(0xFFEBF9F1) : const Color(0xFFFBE7E8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color: isActive ? const Color(0xFF1F9254) : const Color(0xFFA30D11),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['status'],
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isActive ? const Color(0xFF1F9254) : const Color(0xFFA30D11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _expandedRowIndex = isExpanded ? null : index;
                                          print('isExpanded: $isExpanded, Index: $index, Options: ${optionsMap[index]?.length ?? 0}');
                                        });
                                      },
                                      child: SvgPicture.asset(
                                        isExpanded ? 'assets/icons/drop_up.svg' : 'assets/icons/drop_down.svg',
                                        width: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Edit ${item['name']}')),
                                        );
                                      },
                                      child: SvgPicture.asset('assets/icons/pen2.svg', width: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.grey, thickness: 1.0),
                        // Expanded Options List
                        if (isExpanded)
                          Container(
                            color: const Color(0xFFF9F9F9),
                            child: Column(
                              children: [
                                // Options Header
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                  color: const Color(0xFFF2F2F2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Option Name',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Option Value',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Actions',
                                          style: GoogleFonts.spaceGrotesk(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Options List or Fallback
                                optionsMap[index]?.isNotEmpty == true
                                    ? Column(
                                  children: [
                                    ...List.generate(
                                      optionsMap[index]!.length,
                                          (optIndex) {
                                        final option = optionsMap[index]![optIndex];
                                        return Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                                              color: Colors.white,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                      option['name'] ?? '',
                                                      style: GoogleFonts.spaceGrotesk(fontSize: 13),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                      option['value'] ?? '',
                                                      style: GoogleFonts.spaceGrotesk(fontSize: 13),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text('Edit ${option['name']}')),
                                                            );
                                                          },
                                                          child: SvgPicture.asset('assets/icons/pen2.svg', width: 20),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              optionsMap[index]!.removeAt(optIndex);
                                                            });
                                                            ScaffoldMessenger.of(context).showSnackBar(
                                                              SnackBar(content: Text('Deleted ${option['name']}')),
                                                            );
                                                          },
                                                          child: SvgPicture.asset('assets/icons/dustbin.svg', width: 20),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (optIndex < optionsMap[index]!.length - 1)
                                              const Divider(height: 1, color: Colors.grey, thickness: 1.0), // Normal divider between options
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(height: 1, color: Colors.black, thickness: 1.5), // Darker divider after last option
                                  ],
                                )
                                    : Container(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'No options available',
                                    style: GoogleFonts.spaceGrotesk(fontSize: 13, color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}