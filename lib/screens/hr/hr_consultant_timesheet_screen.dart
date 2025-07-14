import 'dart:developer';
import 'dart:ui';

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

class HrConsultantTimeSheetScreen extends ConsumerStatefulWidget {
  const HrConsultantTimeSheetScreen({super.key});

  @override
  ConsumerState<HrConsultantTimeSheetScreen> createState() =>
      _HrConsultantTimeSheetScreenState();
}

class _HrConsultantTimeSheetScreenState
    extends ConsumerState<HrConsultantTimeSheetScreen> {
  int activeIndex = -1;
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
  Map<DateTime, CalendarData> customData = {};

  List<String> iconData = [
    'assets/icons/icon1.svg',
    'assets/icons/icon2.svg',
    'assets/icons/icon3.svg',
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

  List<Map<String, dynamic>> consultanciesData = [
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
    {'name': 'Bruce Lee', 'loggedHours': '0/160', 'actions': {}},
  ];

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
        print('calendarHeight $calendarHeight');
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
          initialChildSize: 0.66,
          minChildSize: 0.4,
          maxChildSize: 0.66,
          expand: false,
          builder: (_, scrollController) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: HrConsultantTimesheetDetailPopup(
              consultant: consultancy,
              isFromClaims: false,
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
    print('client $client');

    _rawClientList = List<Map<String, dynamic>>.from(client['data']);

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    print('_clientList $_clientList');

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();

      print('_selectedClientId11 $_selectedClientId,$_selectedClient');
    }

    setState(() {});
  }

  getConsultantTimesheetByClient() async {
    print('_selectedClientId $_selectedClientId,$selectedMonth,$selectedYear');
    await ref.read(hrProvider.notifier).getConsultantTimeSheetByClient(
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
    await getConsultantTimesheetByClient();
    await updateActiveIndexFromStatus();
    ref.read(hrProvider.notifier).setLoading(false);
  }

  Future<void> _refreshData() async {
    print('selectedMonth $selectedMonth');

    if (token != null) {
      await ref.read(hrProvider.notifier).getConsultantTimeSheetByClient(
            _selectedClientId!,
            selectedMonth.toString().padLeft(2, '0'),
            selectedYear.toString(),
            token!,
            previouslySelectedConsultant: selectedFullData,
          );

      // ✅ Now re-read the updated provider state
      final hrState = ref.read(hrProvider);
      final updatedClaims =
          hrState.selectedConsultantData['timesheet_data'] ?? [];

      final newParsedData = parseTimelineData(updatedClaims);

      setState(() {
        customData = newParsedData;
      });
      await updateActiveIndexFromStatus();

      print('✅ Updated customData for month $selectedMonth => $customData');
    }
  }

  updateActiveIndexFromStatus() {
    final status = ref.read(hrProvider).selectedConsultantData['status'];
    print('claimsDetails $status');

    if(mounted){
      setState(() {
        switch (status) {
          case null:
            activeIndex = -1;
            break;
          case 'Draft':
            activeIndex = 0;
            break;
          case 'Submitted':
            activeIndex = 1;
            break;
          case 'Rejected':
            activeIndex = 3;
            break;
          case 'Approved':
            activeIndex = 4;
            break;
          case 'Rework':
            activeIndex = 5;
            break;
          default:
            activeIndex = -1; // fallback if status is unknown
        }
      });
    }

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
        final dateStr = details['applyOnCell']; // e.g., "05 / 05 / 2025"
        if (dateStr == null) continue;
        final parts = dateStr.split(' / ');
        final day = int.tryParse(parts[0] ?? '');
        final month = int.tryParse(parts[1] ?? '');
        final year = int.tryParse(parts[2] ?? '');
        if (day == null || month == null || year == null) continue;

        final dateKey = DateTime(year, month, day);

        // Leave case
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
        }
        // Work case
        else if (details.containsKey('workingHours') &&
            details['workingHours'] != null) {
          final workingHours = details['workingHours'].toString();
          data[dateKey] = CalendarData(
            widget: Text(
              workingHours,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: int.parse(workingHours) != 8
                    ? const Color(0xffFF1901)
                    : const Color(0xff000000),
              ),
            ),
            type: 'work',
          );
        }
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final hrState = ref.watch(hrProvider);
    final List<dynamic> fullConsultantData = hrState.hrConsultantList ?? [];
    final isLoading = hrState.isLoading;
    print('loader is ${hrState.isLoading}');



    print(
        'Rebuilding UI with timesheet: ${hrState.selectedConsultantData['timesheet_data']?.length},${hrState.selectedConsultantData['remarks']?.length}');

    print('customData$customData');
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
                      height: 120 + calendarHeight,
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
                              // onDataUpdated: _refreshData,
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
                    _buildRemarksSection(hrState),
                    const SizedBox(height: 30),
                    _buildBottomTabView(tabsData, hrState),
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

  Widget _buildHeaderContent(List<dynamic> fullConsultantList) {
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
                    activeIndex=-1;
                  });
                  await getConsultantTimesheetByClient();
                await updateActiveIndexFromStatus();
                },
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            height: fullConsultantList.isEmpty?50:200,
            child:
            fullConsultantList.isEmpty?
            const Center(
              child: Text(
                "No Consultant Found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                :SfDataGrid(
              source: GenericDataSource(
                data:
                    fullConsultantList.map<Map<String, dynamic>>((consultant) {
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
              onCellTap: (details) async{
                final index = details.rowColumnIndex.rowIndex - 1;
                if (index < 0 || index >= fullConsultantList.length) return;

                final selectedData = fullConsultantList[index];

                ref
                    .read(hrProvider.notifier)
                    .getSelectedConsultantDetails(selectedData);

                setState(() {
                  _selectedRowIndex = index;
                  selectedFullData = selectedData;
                  customData = parseTimelineData(
                    selectedData['timesheet_data'] ?? [],
                  );
                });
                await updateActiveIndexFromStatus();
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
        GestureDetector(
            onTap: () {
              context.pop();
            },
            child: SvgPicture.asset('assets/icons/back.svg', height: 15)),
        const Spacer(),
        Text(
          'Total Timesheet:\n90/100',
          style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: const Color(0xff5A5A5A)),
        ),
      ],
    );
  }

  Widget _buildRemarksSection(GetHrState hrState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(hrState: hrState),
    );
  }

  Widget _buildBottomTabView(tabsData, GetHrState hrState) {
    print(
        'timesheet_overview ${hrState.selectedConsultantData['timesheet_overview']}');
    return Container(
      height: 260,
      decoration: containerBoxDecoration(null, const Offset(2, 4)),
      child: Stack(
        children: [
          BottomTabView(tabsData: tabsData, hrState: hrState),
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
                        size: 20, color: Colors.black)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration containerBoxDecoration(
      [Color? color, Offset shadowOffset = const Offset(0, 2)]) {
    return BoxDecoration(
      color: color, // If color is null, it will be transparent (default)
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
    print('Rendering stepper with activeIndex: $activeIndex');

    return KeyedSubtree(
      key: ValueKey(activeIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(svgIcons.length, (index) {
          Color backgroundColor = Colors.white;
          Color borderColor = const Color(0xffA1AEBE);
          Color iconColor = Colors.black;

          if (index < activeIndex) {
            // ✅ Completed step
            backgroundColor = const Color(0xFF007BFF); // Blue
            borderColor = const Color(0xFF007BFF);
            iconColor = Colors.white;
          } else if (index == activeIndex) {
            // ✅ Active step
            switch (index) {
              case 1:
                backgroundColor = const Color(0xFFFFC107); // Yellow
                borderColor = const Color(0xFFFFC107);
                iconColor = Colors.white;
                break;
              case 4:
                backgroundColor = const Color(0xFF28A745); // Green
                borderColor = const Color(0xFF28A745);
                iconColor = Colors.white;
                break;
              case 5:
                backgroundColor = const Color(0xFFDA6536); // Orange
                borderColor = const Color(0xFFDA6536);
                iconColor = Colors.white;
                break;
              case 3:
                backgroundColor = Colors.red.shade400; // Red
                borderColor = Colors.red.shade400;
                iconColor = Colors.white;
                break;
              case 0:
                backgroundColor = Colors.blue;
                borderColor = Colors.blue;
                iconColor = Colors.white;
                break;
              default:
                backgroundColor = Colors.blue;
                borderColor = Colors.blue;
                iconColor = Colors.white;
            }
          }
          // else => upcoming step: remains white

          return Row(
            children: [
              if (index != 0)
                SizedBox(
                  width: 38,
                  child: Divider(
                    color: index <= activeIndex
                        ? Colors.blue
                        : const Color(0xffA1AEBE),
                    thickness: 2,
                    endIndent: 2,
                    indent: 2,
                  ),
                ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 1.5,
                  ),
                ),
                child: SvgPicture.asset(
                  svgIcons[index],
                  height: 12,
                  width: 8,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
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
