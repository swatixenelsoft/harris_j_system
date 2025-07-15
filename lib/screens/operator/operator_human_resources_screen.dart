import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/operator_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';

class HumanResourcesScreen extends ConsumerStatefulWidget {
  const HumanResourcesScreen({super.key});

  @override
  ConsumerState<HumanResourcesScreen> createState() =>
      _HumanResourcesScreenState();
}

class _HumanResourcesScreenState extends ConsumerState<HumanResourcesScreen> {
  int activeIndex = 0;
  int? _selectedRowIndex;
  double calendarHeight = 350;
  String? token;
  String? _selectedClient;
  String? _selectedClientId;
  List<Map<String, dynamic>> _rawClientList = [];
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  Map<String, dynamic> selectedFullData = {};
  Map<DateTime, CalendarData> customData = {};

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon4.svg',
    'assets/icons/icon5.svg',
    'assets/icons/icon7.svg',
  ];
  final List<String> tabsData = [
    "Timesheet Overview",
    "Extra Time Log",
    "Pay-off Log",
    "Comp-off log",
    "Get Copies"
  ];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
      }
    });
  }

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    final client =
        await ref.read(operatorProvider.notifier).getOperatorDashboard(token!);
    _rawClientList = (client['data'] != null && client['data'] is List)
        ? List<Map<String, dynamic>>.from(client['data'])
        : [];

    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();
    }

    setState(() {});
  }

  getConsultantClaimsByClient() async {
    if (_selectedClientId != null && token != null) {
      await ref.read(operatorProvider.notifier).getConsultantTimesheetByClient(
            _selectedClientId!,
            selectedMonth.toString().padLeft(2, '0'),
            selectedYear.toString(),
            token!,
          );
    }
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    if (token == null) return;
    ref.read(operatorProvider.notifier).setLoading(true);
    await getClientList();
    await getConsultantClaimsByClient();
    // Select first consultant by default
    final hrState = ref.read(operatorProvider);
    if (hrState.hrConsultantList != null &&
        hrState.hrConsultantList!.isNotEmpty) {
      setState(() {
        _selectedRowIndex = 0;
        selectedFullData = hrState.hrConsultantList![0];
        customData =
            parseTimelineData(selectedFullData['timesheet_data'] ?? []);
      });
      ref
          .read(operatorProvider.notifier)
          .getSelectedConsultantDetails(selectedFullData);
    }
    ref.read(operatorProvider.notifier).setLoading(false);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchData();
    });
  }

  Map<DateTime, CalendarData> parseTimelineData(List<dynamic> apiResponse) {
    final Map<DateTime, CalendarData> data = {};
    if ((apiResponse).isNotEmpty) {
      final days = apiResponse;
      for (var dayData in days) {
        final details = dayData['record'] ?? {};
        final dateStr = details['applyOnCell'];
        if (dateStr == null) continue;
        final parts = dateStr.split(' / ');
        final day = int.tryParse(parts[0] ?? '');
        final month = int.tryParse(parts[1] ?? '');
        final year = int.tryParse(parts[2] ?? '');
        if (day == null || month == null || year == null) continue;
        final dateKey = DateTime(year, month, day);

        if (details.containsKey('leaveType') && details['leaveType'] != null) {
          final leaveType = details['leaveType'];
          data[dateKey] = CalendarData(
            widget: Text(
              leaveType,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xff007BFF),
              ),
            ),
            type: 'leave',
          );
        } else if (details.containsKey('workingHours') &&
            details['workingHours'] != null) {
          final workingHours = details['workingHours'].toString();
          data[dateKey] = CalendarData(
            widget: Text(
              workingHours,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
              ),
            ),
            type: 'work',
          );
        }
      }
    }
    return data;
  }

  void _refreshData() async {
    if (token != null && _selectedClientId != null) {
      await ref.read(operatorProvider.notifier).getConsultantTimesheetByClient(
            _selectedClientId!,
            selectedMonth.toString().padLeft(2, '0'),
            selectedYear.toString(),
            token!,
            previouslySelectedConsultant: selectedFullData,
          );
      final hrState = ref.read(operatorProvider);
      final updatedClaims =
          hrState.selectedConsultantData['timesheet_data'] ?? [];
      setState(() {
        customData = parseTimelineData(updatedClaims);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final operatorState = ref.watch(operatorProvider);
    final List<dynamic> fullConsultantData =
        operatorState.hrConsultantList ?? [];
    final isLoading = operatorState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? CustomLoader()
            : NestedScrollView(
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
                        height: 130 + calendarHeight,
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
                      const SizedBox(height: 10),
                      // Use provider-based RemarksSection
                      Container(
                        height: 200,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: containerBoxDecoration(
                            Colors.white, const Offset(0, 0)),
                        child: RemarksSection(
                          operatorState: operatorState,
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Use provider-based BottomTabView
                      Container(
                        height: 260,
                        decoration:
                            containerBoxDecoration(null, const Offset(2, 4)),
                        child: Stack(
                          children: [
                            BottomTabView(
                              tabsData: tabsData,
                              operatorState: operatorState,
                              isFromHrScreen: true,
                              selectedMonth: selectedMonth.toString(),
                              selectedYear: selectedYear.toString(),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 40.0,
                                height: 50,
                                color: Colors.white,
                                child: const Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.arrow_back_ios_rounded,
                                          size: 20, color: Colors.black),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          size: 20, color: Colors.black),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderContent(List<dynamic> consultancies) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
          const SizedBox(height: 10),
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
                  return {
                    'emp_name': consultantInfo['emp_name'] ?? 'N/A',
                    'status': consultantInfo['status'],
                    'loggedHours': consultant['loggedHours'] ?? '0/160',
                    'loggedTimeOff': consultant['loggedTimeOff'] ?? '5/3/4',
                    'alOverview': consultant['alOverview'] ?? '12/2',
                    'mlOverview': consultant['mlOverview'] ?? '8/2',
                    'pdoOverview': consultant['pdoOverview'] ?? '3/2',
                    'ulOverview': consultant['ulOverview'] ?? '15',
                  };
                }).toList(),
                columns: [
                  'emp_name',
                  'status',
                  'loggedHours',
                  'loggedTimeOff',
                  'alOverview',
                  'mlOverview',
                  'pdoOverview',
                  'ulOverview',
                ],
                selectedIndex: _selectedRowIndex,
                onZoomTap: (rowData) {
                  // Handle popup
                },
              ),
              columnWidthMode: ColumnWidthMode.auto,
              headerRowHeight: 40,
              rowHeight: 52,
              selectionMode: SelectionMode.single,
              onCellTap: (details) {
                final index = details.rowColumnIndex.rowIndex - 1;
                if (index < 0 || index >= consultancies.length) return;

                final selectedData = consultancies[index];
                ref.read(operatorProvider.notifier).getSelectedConsultantDetails(selectedData);

                setState(() {
                  _selectedRowIndex = index;
                  selectedFullData = selectedData;
                  customData = parseTimelineData(selectedData['timesheet_data'] ?? []);
                });
              },
              columns: [
                GridColumn(
                  columnName: 'emp_name',
                  width: 110,
                  label: _buildHeaderCell('Name', iconPath: 'assets/icons/search_o.svg'),
                ),
                GridColumn(
                  columnName: 'status',
                  width: 80,
                  label: _buildHeaderCell('Queue', iconPath: 'assets/icons/queue.svg', alignment: Alignment.center),
                ),
                GridColumn(
                  columnName: 'loggedHours',
                  width: 110,
                  label: _buildHeaderCell('Hrs LGD/FCst', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'loggedTimeOff',
                  width: 120,
                  label: _buildHeaderCell('Logged Time Off', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'alOverview',
                  width: 100,
                  label: _buildHeaderCell('AL OVERVIEW', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'mlOverview',
                  width: 100,
                  label: _buildHeaderCell('ML OVERVIEW', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'pdoOverview',
                  width: 110,
                  label: _buildHeaderCell('PDO OVERVIEW', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'ulOverview',
                  width: 100,
                  label: _buildHeaderCell('UL OVERVIEW', iconPath: 'assets/icons/hrs.svg'),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title,
      {String? iconPath, Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisAlignment: alignment == Alignment.center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xff000000),
            ),
          ),
          if (iconPath != null) ...[
            SizedBox(width: title == 'Name' ? 40 : 6),
            SvgPicture.asset(iconPath, width: 15, height: 15),
          ],
        ],
      ),
    );
  }
  Widget _buildHeaderActions() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: SvgPicture.asset('assets/icons/back.svg', height: 15),
        ),
        const Spacer(),
        Text(
          'Total Timesheet:\n90/100',
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xff5A5A5A),
          ),
        ),
      ],
    );
  }
  BoxDecoration containerBoxDecoration(
      [Color? color, Offset shadowOffset = const Offset(0, 2)]) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(3),
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(svgIcons.length, (index) {
        bool isSelected = index == activeIndex;

        return Row(
          children: [
            if (index != 0)
              const SizedBox(
                width: 28,
                child: Divider(
                  color: Color(0xffA1AEBE),
                  thickness: 2,
                  endIndent: 2,
                  indent: 2,
                ),
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  this.activeIndex = index;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.blue : const Color(0xffA1AEBE),
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : Colors.black,
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

// ... Keep FixedHeaderDelegate and CalendarData classes as in your original code.
class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final dynamic customData;
  FixedHeaderDelegate(
      {required this.child, required this.height, required this.customData});
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: height, child: child);
  }

  @override
  bool shouldRebuild(covariant FixedHeaderDelegate oldDelegate) {
    return height != oldDelegate.height || customData != oldDelegate.customData;
  }
}
class CalendarData {
  final Widget widget;
  final String type;
  CalendarData({required this.widget, required this.type});
}