import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/finance_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


class FinanceScreen extends ConsumerStatefulWidget {
  const FinanceScreen({super.key});

  @override
  ConsumerState<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends ConsumerState<FinanceScreen> {
  int activeIndex = -1;
  double calendarHeight = 350;
  String? token;
  String? _selectedClient;
  String? _selectedClientId;
  int? _selectedRowIndex;
  Map<String, dynamic> selectedFullData = {};
  List<Map<String, dynamic>> _rawClientList = [];
  List<String> _clientList = [];
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
    " Get Copies"
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      fetchData();
    });
  }

  Future<void> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    print('Token: $token'); // Debug print
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found')),
      );
      return;
    }
    ref.read(financeProvider.notifier).setLoading(true);
    await getClientList();
    if (_selectedClientId != null) {
      await getConsultantTimesheetByClient();
    }
    await updateActiveIndexFromStatus();
    ref.read(financeProvider.notifier).setLoading(false);
  }

  Future<void> getClientList() async {
    if (token != null) {
      final clientResponse = await ref.read(financeProvider.notifier).clientList(token!);
      print('Raw clientList: $clientResponse'); // Debug print
      if (clientResponse['success'] == true && clientResponse['data'] != null) {
        setState(() {
          _rawClientList = List<Map<String, dynamic>>.from(clientResponse['data']);
          _clientList = _rawClientList
              .map<String>((item) => item['serving_client'].toString())
              .toList();
          if (_rawClientList.isNotEmpty) {
            _selectedClientId = _rawClientList[0]['id']?.toString() ?? '';
            _selectedClient = _rawClientList[0]['serving_client']?.toString() ?? 'No Client';
          } else {
            _selectedClient = 'No Client Selected';
            _selectedClientId = '';
          }
          print('Client List: $_clientList, Selected Client: $_selectedClient, Selected ID: $_selectedClientId');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(clientResponse['message'] ?? 'Failed to load clients')),
        );
        setState(() {
          _rawClientList = [];
          _clientList = [];
          _selectedClient = 'No Client Selected';
          _selectedClientId = '';
        });
      }
    }
  }

  Future<void> getConsultantTimesheetByClient() async {
    if (_selectedClientId != null && token != null) {
      await ref.read(financeProvider.notifier).getConsultantTimesheetByClientFinance(
        _selectedClientId!,
        selectedMonth.toString().padLeft(2, '0'),
        selectedYear.toString(),
        token!,
        previouslySelectedConsultant: selectedFullData,
      );
      final financeState = ref.read(financeProvider);
      print('Raw consultantList: ${financeState.consultantList}'); // Debug print
      setState(() {
        customData = _parseTimelineData(financeState.consultantList ?? []);
      });
    }
  }

  Future<void> _refreshData() async {
    if (_selectedClientId != null && token != null) {
      await ref.read(financeProvider.notifier).getConsultantTimesheetByClientFinance(
        _selectedClientId!,
        selectedMonth.toString().padLeft(2, '0'),
        selectedYear.toString(),
        token!,
        previouslySelectedConsultant: selectedFullData,
      );
      final financeState = ref.read(financeProvider);
      final updatedClaims = financeState.selectedConsultantData['timesheet_data'] ?? [];
      setState(() {
        customData = _parseTimelineData(updatedClaims);
      });
      await updateActiveIndexFromStatus();
    }
  }

  Future<void> updateActiveIndexFromStatus() async {
    final status = ref.read(financeProvider).selectedConsultantData['status'];
    print('Status: $status'); // Debug print
    if (mounted) {
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
            activeIndex = -1;
        }
      });
    }
  }

  void _updateCalendarHeight(double newHeight) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          calendarHeight = newHeight;
        });
      }
    });
  }

  Map<DateTime, CalendarData> _parseTimelineData(List<dynamic> apiResponse) {
    final Map<DateTime, CalendarData> data = {};

    if (apiResponse.isNotEmpty) {
      for (var dayData in apiResponse) {
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
    final financeState = ref.watch(financeProvider);
    final List<dynamic> fullConsultantData = financeState.consultantList ?? [];
    final isLoading = financeState.isLoading;

    print('Rebuilding UI with consultantList: $fullConsultantData'); // Debug print

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: NestedScrollView(
              physics: const ClampingScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                  SliverToBoxAdapter(child: _buildHeaderContent(fullConsultantData)),
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
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
                              isGoodToGo: true,
                              onMonthChanged: (month, year) async {
                                setState(() {
                                  selectedMonth = month;
                                  selectedYear = year;
                                });
                                await _refreshData();
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
                    _buildRemarksSection(financeState),
                    const SizedBox(height: 30),
                    _buildBottomTabView(tabsData, financeState),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: _rawClientList.isEmpty
                ? const Text(
              'No clients available',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            )
                : CustomClientDropdown(
              clients: _rawClientList,
              initialClientName: _selectedClient ?? 'Select a Client',
              onChanged: (selectedName, selectedId) async {
                FocusScope.of(context).unfocus();
                setState(() {
                  _selectedClient = selectedName;
                  _selectedClientId = selectedId;
                  _selectedRowIndex = -1;
                  customData = {};
                  activeIndex = -1;
                });
                await getConsultantTimesheetByClient();
                await updateActiveIndexFromStatus();
              },
            ),
          ),

          const SizedBox(height: 10),
          SizedBox(
            height: fullConsultantList.isEmpty ? 50 : 200,
            child: fullConsultantList.isEmpty
                ? const Center(
              child: Text(
                "No Consultant Found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
                : SfDataGrid(
              source: GenericDataSource(
                data: fullConsultantList.map<Map<String, dynamic>>((consultant) {
                  return {
                    'name': consultant['emp_name'] ?? 'Unknown',
                    'loggedHours': consultant['hours_logged'] ?? '0/160',
                    'loggedTimeOff': consultant['time_off'] ?? '0/0/0',
                    'alOverview': consultant['al_balance'] ?? '0/0',
                    'mlOverview': consultant['ml_balance'] ?? '0/0',
                    'pdoOverview': consultant['pdo_balance'] ?? '0/0',
                    'ulOverview': consultant['ul_balance'] ?? '0',
                    'queue': consultant['queue'] ?? '',
                    'full_data': consultant,
                  };
                }).toList(),
                columns: [
                  'name',
                  'queue',
                  'loggedHours',
                  'loggedTimeOff',
                  'alOverview',
                  'mlOverview',
                  'pdoOverview',
                  'ulOverview'
                ],
                onZoomTap: (rowData) {
                  // Implement zoom tap action if needed
                },
                selectedIndex: _selectedRowIndex,
              ),
              columnWidthMode: ColumnWidthMode.fill,
              headerRowHeight: 38,
              rowHeight: 52,
              onCellTap: (details) async {
                final index = details.rowColumnIndex.rowIndex - 1;
                if (index < 0 || index >= fullConsultantList.length) return;

                final selectedData = fullConsultantList[index];
                ref
                    .read(financeProvider.notifier)
                    .getSelectedConsultantDetails(selectedData);

                setState(() {
                  _selectedRowIndex = index;
                  selectedFullData = selectedData;
                  customData = _parseTimelineData(
                    selectedData['timesheet_data'] ?? [],
                  );
                });
                await updateActiveIndexFromStatus();
              },
              columns: [
                GridColumn(
                  columnName: 'name',
                  width: 120,
                  label: _buildHeaderCell('Name'),
                ),
                GridColumn(
                  columnName: 'queue',
                  width: 80,
                  label: _buildHeaderCell('Queue', alignment: Alignment.center),
                ),
                GridColumn(
                  columnName: 'loggedHours',
                  width: 120,
                  label: _buildHeaderCell('Hrs LGD/FCst'),
                ),
                GridColumn(
                  columnName: 'loggedTimeOff',
                  width: 120,
                  label: _buildHeaderCell('Logged Time Off'),
                ),
                GridColumn(
                  columnName: 'alOverview',
                  width: 100,
                  label: _buildHeaderCell('AL Overview'),
                ),
                GridColumn(
                  columnName: 'mlOverview',
                  width: 100,
                  label: _buildHeaderCell('ML Overview'),
                ),
                GridColumn(
                  columnName: 'pdoOverview',
                  width: 100,
                  label: _buildHeaderCell('PDO Overview'),
                ),
                GridColumn(
                  columnName: 'ulOverview',
                  width: 100,
                  label: _buildHeaderCell('UL Overview'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {Alignment alignment = Alignment.centerLeft}) {
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
          child: SvgPicture.asset('assets/icons/back.svg', height: 15),
        ),
        const Spacer(),
        Text(
          'Timesheet Approval: 90/100',
          style: GoogleFonts.montserrat(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: const Color(0xff5A5A5A),
          ),
        ),
      ],
    );
  }
  Widget _buildRemarksSection(financeState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(financeState: financeState),
    );
  }
  Widget _buildBottomTabView(List<String> tabsData, financeState) {
    return Container(
      height: 260,
      decoration: containerBoxDecoration(null, const Offset(2, 4)),
      child: Stack(
        children: [
          BottomTabView(tabsData: tabsData, financeState: financeState),
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
                    Icon(Icons.arrow_back_ios_rounded, size: 20, color: Colors.black),
                    Icon(Icons.arrow_forward_ios_rounded, size: 20, color: Colors.black),
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

  Widget _stepperUI(BuildContext context, List<String> svgIcons, int activeIndex) {
    return KeyedSubtree(
      key: ValueKey(activeIndex),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(svgIcons.length, (index) {
          Color backgroundColor = Colors.white;
          Color borderColor = const Color(0xffA1AEBE);
          Color iconColor = Colors.black;

          if (index < activeIndex) {
            backgroundColor = const Color(0xFF007BFF);
            borderColor = const Color(0xFF007BFF);
            iconColor = Colors.white;
          } else if (index == activeIndex) {
            switch (index) {
              case 1:
                backgroundColor = const Color(0xFFFFC107);
                borderColor = const Color(0xFFFFC107);
                iconColor = Colors.white;
                break;
              case 4:
                backgroundColor = const Color(0xFF28A745);
                borderColor = const Color(0xFF28A745);
                iconColor = Colors.white;
                break;
              case 5:
                backgroundColor = const Color(0xFFDA6536);
                borderColor = const Color(0xFFDA6536);
                iconColor = Colors.white;
                break;
              case 3:
                backgroundColor = Colors.red.shade400;
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

          return Row(
            children: [
              if (index != 0)
                SizedBox(
                  width: 38,
                  child: Divider(
                    color: index <= activeIndex ? Colors.blue : const Color(0xffA1AEBE),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
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
