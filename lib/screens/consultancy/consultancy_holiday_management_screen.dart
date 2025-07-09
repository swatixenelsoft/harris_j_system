import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_detailed_holiday_screen.dart';
import 'package:harris_j_system/screens/consultancy/create_holiday_profile_screen.dart';
import 'package:harris_j_system/screens/consultancy/edit_form_screen.dart';
import 'package:harris_j_system/widgets/custom_button.dart';

class HolidayManagementScreen extends ConsumerStatefulWidget {
  const HolidayManagementScreen({super.key});

  @override
  ConsumerState<HolidayManagementScreen> createState() =>
      _HolidayManagementScreenState();
}

class _HolidayManagementScreenState
    extends ConsumerState<HolidayManagementScreen> {
  String userId = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadHolidayList());
  }

  Future<void> _loadHolidayList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    userId = prefs.getInt('userId')?.toString() ?? '';
    final notifier = ref.read(staticSettingProvider.notifier);
    await notifier.getHolidayList(userId: userId, token: token);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;
    final iconSize = w * 0.05;

    final staticSettingState = ref.watch(staticSettingProvider);
    List detailedHolidays = staticSettingState.holidayList ?? [];

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Search clicked'))),
                      child: SvgPicture.asset('assets/icons/search.svg',
                          width: 16, height: 16),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('More options clicked'))),
                      child: SvgPicture.asset('assets/icons/vert.svg',
                          width: 16, height: 16),
                    ),
                  ],
                ),
                CustomButton(
                  text: 'Create Holiday Profile',
                  leftPadding: 0,
                  width: 150,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (_) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                            constraints: BoxConstraints(maxHeight: h * 0.7),
                            child: CreateHolidayProfileForm(
                              token: token,
                              userId: userId,
                              onHolidayAdded: (json) {
                                // Always refresh the holiday list after adding a holiday
                                _loadHolidayList();
                                // Close modal only for "Save"
                                if (!json['isSaveAndAdd']) {
                                  Navigator.pop(context);
                                }
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: w),
              child: DataTable(
                headingRowHeight: h * 0.05,
                dataRowHeight: h * 0.075,
                headingRowColor:
                MaterialStateProperty.all(const Color(0xFFFF1901)),
                columns: [
                  DataColumn(
                      label: Text('Holiday Name',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12))),
                  DataColumn(
                      label: Text('Status',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12))),
                  DataColumn(
                      label: Text('Actions',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12))),
                ],
                rows: detailedHolidays.asMap().entries.map((e) {
                  final idx = e.key;
                  final holiday = e.value;

                  return DataRow(cells: [
                    DataCell(
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailedHolidayScreen(
                                token: token,
                                userId: userId,
                                childrenHoliday: holiday['children'],
                              ),
                            ),
                          );
                        },
                        child: Text(holiday['holiday_name'] ?? 'Unknown',
                            style: GoogleFonts.montserrat(fontSize: 12)),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: w * 0.02, vertical: h * 0.005),
                        decoration: BoxDecoration(
                          color: holiday['status'] == 1
                              ? const Color(0xFFEBF9F1)
                              : const Color(0xFFFFE3E3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.circle,
                                size: w * 0.02,
                                color: holiday['status'] == 1
                                    ? const Color(0xFF1F9254)
                                    : Colors.red),
                            const SizedBox(width: 4),
                            Text(
                              holiday['status'] == 1 ? 'Active' : 'Inactive',
                              style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: holiday['status'] == 1
                                      ? const Color(0xFF1F9254)
                                      : Colors.red[900]),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'View ${holiday['holiday_name'] ?? 'Unknown'}'))),
                            child: SvgPicture.asset('assets/icons/fullscreen.svg',
                                width: iconSize),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                builder: (_) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: Container(
                                      constraints: BoxConstraints(maxHeight: h * 0.8),
                                      child: EditHolidayForm(
                                        token: token,
                                        id: '',
                                        holidayData: {
                                          'id': holiday['id'],
                                          'name': holiday['holiday_name'] ?? '',
                                          'status': holiday['status'],
                                          'startDate': holiday['start_date'],
                                          'endDate': holiday['end_date'],
                                        },
                                        onSubmit: (updatedHoliday) async {
                                          Navigator.pop(context);
                                          await _loadHolidayList();
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset('assets/icons/pen.svg',
                                width: iconSize),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'Delete ${holiday['holiday_name'] ?? 'Unknown'}')));
                            },
                            child: SvgPicture.asset('assets/icons/delete.svg',
                                width: iconSize),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}