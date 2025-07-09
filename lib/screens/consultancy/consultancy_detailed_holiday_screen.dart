import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/screens/consultancy/add_holiday_screen.dart';
import 'package:harris_j_system/screens/consultancy/edit_form_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/custom_button.dart';

class DetailedHolidayScreen extends ConsumerStatefulWidget {
  final String token;
  final String userId;
  final List<dynamic> childrenHoliday;

  const DetailedHolidayScreen({
    super.key,
    required this.token,
    required this.userId,
    required this.childrenHoliday,
  });

  @override
  ConsumerState<DetailedHolidayScreen> createState() =>
      _DetailedHolidayScreenState();
}

class _DetailedHolidayScreenState extends ConsumerState<DetailedHolidayScreen> {
  Future<void> _loadHolidays() async {
    final notifier = ref.read(staticSettingProvider.notifier);
    await notifier.getHolidayList(
      userId: widget.userId,
      token: widget.token,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final iconSize = w * 0.05;

    final holidayList = ref.watch(staticSettingProvider).holidayList ?? [];

    final parentId = widget.childrenHoliday.isNotEmpty &&
        widget.childrenHoliday[0]['id'] != null
        ? widget.childrenHoliday[0]['id'].toString()
        : holidayList.isNotEmpty && holidayList[0]['id'] != null
        ? holidayList[0]['id'].toString()
        : '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xffE8E8E8)),
                left: BorderSide(color: Color(0xffE8E8E8)),
                right: BorderSide(color: Color(0xffE8E8E8)),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                ),
                Text(
                  'Holidays',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xffFF1901),
                  ),
                ),
                CustomButton(
                  text: "Add Holiday",
                  height: 35,
                  width: 120,
                  leftPadding: 0,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: h * 0.47),
                            child: AddHolidayForm(
                              token: widget.token,
                              userId: widget.userId,
                              parentId: parentId,
                              onSubmit: (json) async {
                                await _loadHolidays();
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: 'Search by ID',
                    controller: TextEditingController(),
                    prefixIcon: const Icon(Icons.search,
                        size: 18, color: Color(0xff999999)),
                    padding: 0,
                    borderRadius: 10,
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => const AlertDialog(
                      title: Text('Filter'),
                      content: Text('Filter options'),
                    ),
                  ),
                  child: SvgPicture.asset('assets/icons/filter.svg', height: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: w),
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor:
                    MaterialStateProperty.all(const Color(0xFFFF1901)),
                    headingRowHeight: h * 0.05,
                    dataRowHeight: h * 0.075,
                    columns: [
                      DataColumn(
                        label: Text("Holiday Name",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ),
                      DataColumn(
                        label: Text("Status",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ),
                      DataColumn(
                        label: Text("Actions",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            )),
                      ),
                    ],
                    rows: widget.childrenHoliday.asMap().entries.map((e) {
                      final holiday = e.value;
                      return DataRow(cells: [
                        DataCell(
                          Text(holiday['holiday_name'] ?? 'N/A',
                              style: GoogleFonts.montserrat(fontSize: 10)),
                        ),
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: holiday['status'] == 1
                                  ? const Color(0xFFEBF9F1)
                                  : const Color(0xFFFFE3E3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    size: 8,
                                    color: holiday['status'] == 1
                                        ? const Color(0xFF1F9254)
                                        : Colors.red),
                                const SizedBox(width: 4),
                                Text(
                                  holiday['status'] == 1
                                      ? 'Active'
                                      : 'Inactive',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: holiday['status'] == 1
                                        ? const Color(0xFF1F9254)
                                        : Colors.red[900],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16)),
                                    ),
                                    builder: (_) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxHeight: h * 0.8),
                                          child: EditHolidayForm(
                                            token: widget.token,
                                            id: holiday['id'].toString(),
                                            holidayData: {
                                              'id': holiday['id'],
                                              'name': holiday['holiday_name'],
                                              'status': holiday['status'],
                                              'startDate': holiday['start_date'],
                                              'endDate': holiday['end_date'],
                                            },
                                            onSubmit: (updatedHoliday) async {
                                              Navigator.pop(context);
                                              await _loadHolidays();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/pen.svg',
                                  width: iconSize,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                      'Delete ${holiday['holiday_name']}'),
                                )),
                                child: SvgPicture.asset(
                                  'assets/icons/delete.svg',
                                  width: iconSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
                    }).toList(),//to list is created in span area by add holidays function directly
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
