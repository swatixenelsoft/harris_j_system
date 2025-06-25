import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_timesheet_detail_popup.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/shared/login_screen.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:harris_j_system/widgets/tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HrConsultantClaimScreen extends ConsumerStatefulWidget {
  const HrConsultantClaimScreen({super.key});

  @override
  ConsumerState<HrConsultantClaimScreen> createState() =>
      _HrConsultantClaimScreenState();
}

class _HrConsultantClaimScreenState
    extends ConsumerState<HrConsultantClaimScreen> {
  int activeIndex = 0;
  double calendarHeight = 350;
  String? token;
  String? _selectedClient;
  String? _selectedClientId;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];
  int? _selectedRowIndex;
  Map<String, dynamic> selectedFullData = {};

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  Map<DateTime, List<Map<String, dynamic>>> customData = {};

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];

  final List<String> tabsData = ["Claims", "Get Copies"];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
      }
    });
  }

  void _showConsultancyPopup(
      BuildContext context, Map<String, dynamic> consultancy) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
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
            child: HrConsultantTimesheetDetailPopup(
              consultant: consultancy,
              isFromClaims: true,
              onDelete: () {},
            ),
          ),
        );
      },
    );
  }

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final client = await ref.read(hrProvider.notifier).clientList(token!);

    _rawClientList = List<Map<String, dynamic>>.from(client['data']);

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();
    }

    setState(() {});
  }

  getConsultantClaimsByClient() async {
    await ref.read(hrProvider.notifier).getConsultantClaimsByClient(
        _selectedClientId!,
        selectedMonth.toString().padLeft(2, '0'),
        selectedYear.toString(),
        token!);
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    ref.read(hrProvider.notifier).setLoading(true);
    await getClientList();
    await getConsultantClaimsByClient();
    ref.read(hrProvider.notifier).setLoading(false);
  }

  void _refreshData() async {
    print('selectedMonth $selectedMonth');

    if (token != null) {
      await ref.read(hrProvider.notifier).getConsultantClaimsByClient(
            _selectedClientId!,
            selectedMonth.toString().padLeft(2, '0'),
            selectedYear.toString(),
            token!,
            previouslySelectedConsultant: selectedFullData,
          );

      // ✅ Now re-read the updated provider state
      final hrState = ref.read(hrProvider);
      final updatedClaims = hrState.selectedConsultantData['claims'] ?? [];

      print('updatedClaims $updatedClaims');

      final newParsedData = parseTimelineData(updatedClaims);

      setState(() {
        customData = newParsedData;
      });

      print('✅ Updated customData for month $selectedMonth => $customData');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchData();
    });
  }

  Map<DateTime, List<Map<String, dynamic>>> parseTimelineData(
      List<dynamic> json) {
    final Map<DateTime, List<Map<String, dynamic>>> data = {};

    for (var item in json) {
      final String? dateStr = item['record']?['date'] ?? item['date'];
      final String? expenseType =
          item['record']?['expenseType'] ?? item['expense_type'];
      final int? id = item['id']; // or any unique identifier if present

      if (dateStr == null || expenseType == null) continue;

      // Parse the date string into DateTime
      final dateKey = DateTime.tryParse(dateStr);
      if (dateKey == null) continue;

      // Determine color based on expenseType
      Color color;
      switch (expenseType.toLowerCase()) {
        case 'taxi':
          color = const Color(0xffEBF9F1);
          break;
        case 'dining':
          color = const Color(0xffFBE7E8);
          break;
        case 'others':
          color = const Color(0xffFF9F2D);
          break;
        default:
          color = Colors.grey;
      }

      data.putIfAbsent(dateKey, () => []).add({
        'type': expenseType.toLowerCase(),
        'color': color,
        'id': id,
      });
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final hrState = ref.watch(hrProvider);

    final List<dynamic> fullConsultantData = hrState.hrConsultantList ?? [];
    final isLoading = hrState.isLoading;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: CustomAppBar(
                        showBackButton: false,
                        image: 'assets/icons/cons_logo.png',
                        onProfilePressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.clear();
                          context.pushReplacement(Constant.login);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: _buildHeaderContent(fullConsultantData)),
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: FixedHeaderDelegate(
                      height: 135 + calendarHeight,
                      customData: customData,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            width: double.infinity,
                            color: const Color(0xffF5F5F5),
                            child: _stepperUI(context, iconData, activeIndex),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 7,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CalendarScreen(
                              selectedMonth: selectedMonth,
                              selectedYear: selectedYear,
                              onHeightCalculated: _updateCalendarHeight,
                              customData: customData,
                              isFromClaimScreen: true,
                              isFromHrScreen: true,
                              onMonthChanged: (month, year) async {
                                setState(() {
                                  selectedMonth = month;
                                  selectedYear = year;
                                });
                                _refreshData();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildBottomTabView(tabsData, hrState),
                    const SizedBox(height: 10),
                    _buildRemarksSection(hrState),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const CustomLoader(
                    color: Color(0xffFF1901),
                    size: 35,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(consultancies) {
    return Container(
      padding: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border.all(color: const Color(0xffE8E8E8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: _buildHeaderActions(),
          ),
          const SizedBox(height: 15),
          if (_rawClientList.isNotEmpty && _selectedClient != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomClientDropdown(
                clients: _rawClientList,
                initialClientName: _selectedClient,
                onChanged: (selectedName, selectedId) async {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _selectedClient = selectedName;
                    _selectedClientId = selectedId;
                    _selectedRowIndex = -1;
                    customData = {};
                  });
                  await getConsultantClaimsByClient();
                },
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: SfDataGrid(
              source: GenericDataSource(
                data: consultancies.map<Map<String, dynamic>>((consultant) {
                  final consultantInfo = consultant['consultant_info'] ?? {};
                  final workLog = consultant['work_log'] ?? {};
                  return {
                    'emp_name': consultantInfo['emp_name'] ?? '',
                    'working_hours': consultantInfo['working_hours'] ?? '',
                    'logged_hours': workLog['logged_hours'] ?? 0,
                    'full_data': consultant, // include full object for actions
                  };
                }).toList(),
                columns: ['emp_name', 'working_hours', 'actions'],
                onZoomTap: (rowData) {
                  _showConsultancyPopup(context, rowData['full_data']);
                },
                selectedIndex: _selectedRowIndex,
              ),
              columnWidthMode: ColumnWidthMode.fill,
              headerRowHeight: 38,
              rowHeight: 52,
              onCellTap: (details) {
                final index = details.rowColumnIndex.rowIndex - 1;
                if (index < 0 || index >= consultancies.length) return;

                final selectedData = consultancies[index];

                ref
                    .read(hrProvider.notifier)
                    .getSelectedConsultantDetails(selectedData);

                setState(() {
                  _selectedRowIndex = index;
                  selectedFullData = selectedData;
                  customData = parseTimelineData(
                    selectedData['claims'] ?? [],
                  );
                });
              },
              columns: [
                GridColumn(
                  columnName: 'emp_name',
                  width: 120,
                  label: _buildHeaderCell('Name'),
                ),
                GridColumn(
                  columnName: 'working_hours',
                  width: 120,
                  label: _buildHeaderCell('Hours Logged'),
                ),
                GridColumn(
                  columnName: 'actions',
                  label:
                      _buildHeaderCell('Actions', alignment: Alignment.center),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text,
      {Alignment alignment = Alignment.centerLeft}) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0xFFF2F2F2),
      child: Text(
        text,
        style: GoogleFonts.montserrat(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Row(
      children: [
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset('assets/icons/back.svg', height: 15)),
            const SizedBox(width: 10),
            Text(
              'Claims list',
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffFF1901)),
            ),
          ],
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/icons/search_icon.svg',
          height: 15,
          width: 15,
        )
      ],
    );
  }

  Widget _buildRemarksSection(GetHrState hrState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(hrState: hrState),
    );
  }

  Widget _buildBottomTabView(List<String> tabsData, GetHrState hrState) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 414,
      decoration: _containerBoxDecoration(
        Colors.white,
        const Offset(0, 0),
        Border.all(width: 1, color: const Color(0xffE8E8E8)),
        BorderRadius.circular(12),
      ),
      child: BottomTabView(
        tabsData: tabsData,
        hrState: hrState,
        isFromClaimScreen: true,
        selectedMonth: selectedMonth.toString(),
        selectedYear: selectedYear.toString(),
      ),
    );
  }

  BoxDecoration _containerBoxDecoration(
      [Color? color,
      Offset shadowOffset = const Offset(0, 0),
      Border? border,
      BorderRadius? borderRadius]) {
    return BoxDecoration(
      color: color, // If color is null, it will be transparent (default)
      borderRadius: borderRadius,
      border: border,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4,
          offset: shadowOffset,
        ),
      ],
    );
  }

  Widget _stepperUI(
      BuildContext context, List<String> svgIcons, int activeIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Align items in the center
      children: List.generate(svgIcons.length, (index) {
        bool isSelected = index == activeIndex;

        return Row(
          children: [
            // Add a divider before each step except the first one
            if (index != 0)
              const SizedBox(
                width: 28, // Adjust width as needed
                child: Divider(
                  color: Color(0xffA1AEBE),
                  thickness: 2,
                  endIndent: 2,
                  indent: 2,
                ),
              ),
            GestureDetector(
              onTap: () {
// setState(() {
//   isSelected=index==activeIndex;
// });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5), // Padding inside the circle
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : Colors.white, // Change background color if selected
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : const Color(
                            0xffA1AEBE), // Change border color if selected
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    isSelected
                        ? Colors.white
                        : Colors.black, // Change icon color if selected
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final dynamic customData;

  FixedHeaderDelegate({
    required this.child,
    required this.height,
    required this.customData,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant FixedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || customData != oldDelegate.customData;
  }
}

class CalendarData {
  final Widget widget;
  final String type; // e.g., 'leave', 'work', etc.

  CalendarData({required this.widget, required this.type});
}
