import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/operator_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_timesheet_detail_popup.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/screens/operator/action_click.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/bottom_tab_view.dart';
import 'package:harris_j_system/widgets/calender_view.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../providers/consultant_provider.dart';

class OperatorClaimScreen extends ConsumerStatefulWidget {
  const OperatorClaimScreen({super.key});

  @override
  ConsumerState<OperatorClaimScreen> createState() =>
      _OperatorClaimScreenState();
}

class _OperatorClaimScreenState extends ConsumerState<OperatorClaimScreen> {
  int activeIndex = 0;
  int? _selectedRowIndex;
  double calendarHeight = 350;
  String? token;
  TextEditingController _searchController = TextEditingController();

  String? _selectedClient;
  String? _selectedClientId;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];

  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  Map<String, dynamic> selectedFullData = {};
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
      BuildContext context, Map<String, dynamic> consultancy)
  {
    print('consultancy $consultancy');
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: operatorActionPopup(
                consultant: consultancy,
                isFromClaims: true,
                onDelete: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  getClientList() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');


    final client =
    await ref.read(operatorProvider.notifier).getOperatorDashboard(token!);
    print('client $client');

    _rawClientList = (client['data'] != null && client['data'] is List)
        ? List<Map<String, dynamic>>.from(client['data'])
        : [];

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    print('_clientList$_rawClientList');

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();

      print(
          '_selectedClientId11 $_selectedClientId,$_selectedClient');

      // ✅ Optionally fetch consultants for the first client
    }

    setState(() {});
  }

  getConsultantClaimsByClient() async {
    await ref.read(operatorProvider.notifier).getConsultantClaimsByClient(
        _selectedClientId!,
        selectedMonth.toString().padLeft(2, '0'),
        selectedYear.toString(),
        token!);
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    ref.read(operatorProvider.notifier).setLoading(true);
    await getClientList();
    await getConsultantClaimsByClient();
    ref.read(operatorProvider.notifier).setLoading(false);
  }


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Map<DateTime, List<Map<String, dynamic>>> parseTimelineData(
      List<dynamic> json)
  {
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
          color = const Color(0xffB8E6D0);
          break;
        case 'dining':
          color = const Color(0xffE9BDBF);
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
    print('data claims $data');


    return data;
  }

  void _refreshData() async {
    print('selectedMonth $selectedMonth');

    if (token != null) {
      await ref.read(operatorProvider.notifier).getConsultantClaimsByClient(
        _selectedClientId!,
        selectedMonth.toString().padLeft(2, '0'),
        selectedYear.toString(),
        token!,
        previouslySelectedConsultant: selectedFullData,
      );

      // ✅ Now re-read the updated provider state
      final hrState = ref.read(operatorProvider);
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
  Widget build(BuildContext context) {
    final operatorState = ref.watch(operatorProvider);
    final List<dynamic> fullConsultantData = operatorState.hrConsultantList ?? [];
    final List<dynamic> claimsDetails =operatorState.selectedConsultantData['claim_tab']??[];
    final isLoading = operatorState.isLoading;
    log('claimsDetails $claimsDetails');

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
                    height: 180 + calendarHeight,
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
                            claimsDetails:claimsDetails,
                            backDatedClaims: (operatorState.selectedConsultantData['data'] is Map)
                                ? Map<String, dynamic>.from(operatorState.selectedConsultantData['data'])
                                : {},
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
                  _buildRemarksSection(operatorState),
                  const SizedBox(height: 10),
                  _buildBottomTabView(tabsData, operatorState),
                  const SizedBox(height: 30),
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

  Widget _buildHeaderContent(List<dynamic> consultancies) {
    // Get screen width using MediaQuery
    final double screenWidth = MediaQuery.of(context).size.width;

    // Define proportional column widths based on screen width
    final double nameWidth = screenWidth * 0.25; // 25% of screen width
    final double queueWidth = screenWidth * 0.20; // 15% of screen width
    final double submittedWidth = screenWidth * 0.25; // 20% of screen width
    final double claimNoWidth = screenWidth * 0.25; // 20% of screen width
    final double numClaimsWidth = screenWidth * 0.4; // 25% of screen width
    final double totalAmountWidth = screenWidth * 0.30; // 20% of screen width
    final double actionWidth = screenWidth * 0.15; // 15% of screen width


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
          const SizedBox(height: 15),
          if (_rawClientList.isNotEmpty && _selectedClient != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomClientDropdown(
                clients: _rawClientList,
                initialClientName: _selectedClient,
                onChanged: (selectedName, selectedId) async {
                  FocusScope.of(context).unfocus();
                  final selectedClient = _rawClientList.firstWhere(
                        (client) => client['id'].toString() == selectedId,
                    orElse: () => {},
                  );

                  if (selectedClient.isNotEmpty) {
                    setState(() {
                      _selectedClient = selectedName;
                      _selectedClientId = selectedId;
                    });

                    print('_selectedClientId $_selectedClientId');
                    // getDashBoardByClient();
                  }
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
                  print('consultantInfo $consultantInfo');
                  return {
                    'emp_name': consultantInfo['emp_name'] ?? 'N/A',
                    'status': consultantInfo['status'],
                    'submitted': consultantInfo['joining_date'] ?? '',
                    'claim_no': consultantInfo['claim_no'] ?? 'N/A',
                    'number_of_claims': '${consultantInfo['number_of_claims'] ?? '0'}',
                    'total_amount': '\$${consultantInfo['total_amount'] ?? '0'}',
                    'full_data': consultant,
                  };
                }).toList(),
                columns: [
                  'emp_name',
                  'status',
                  'submitted',
                  'claim_no',
                  'number_of_claims',
                  'total_amount',
                  'actions',
                ],
                onZoomTap: (rowData) {
                  _showConsultancyPopup(context, rowData['full_data']);
                },
                selectedIndex: _selectedRowIndex,
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
                  customData = parseTimelineData(selectedData['claims'] ?? []);
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
                  columnName: 'submitted',
                  width: 100,
                  label: _buildHeaderCell('Submitted', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'claim_no',
                  width: 80,
                  label: _buildHeaderCell('Claim No', iconPath: 'assets/icons/hrs.svg'),
                ),
                GridColumn(
                  columnName: 'number_of_claims',
                  width: 130,
                  label: _buildHeaderCell('Number of Claims', iconPath: 'assets/icons/hrs.svg', alignment: Alignment.center),
                ),
                GridColumn(
                  columnName: 'total_amount',
                  width: 110,
                  label: _buildHeaderCell('Total Amount', iconPath: 'assets/icons/hrs.svg', alignment: Alignment.center),
                ),
                GridColumn(
                  columnName: 'actions',
                  width: 80,
                  label: _buildHeaderCell('Action', alignment: Alignment.center),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title, {String? iconPath, Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisAlignment: alignment == Alignment.center ? MainAxisAlignment.center : MainAxisAlignment.start,
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
             SizedBox(width:title=='Name'?40 :6),
            SvgPicture.asset(iconPath, width: 15, height: 15),
          ],
        ],
      ),
    );
  }

  Color _getQueueColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return const Color.fromRGBO(40, 167, 69, 1); // green
      case 'pending':
        return const Color.fromRGBO(255, 193, 7, 1); // yellow
      case 'rejected':
      case 'inactive':
        return const Color.fromRGBO(255, 25, 1, 1); // red
      default:
        return const Color.fromRGBO(0, 123, 255, 1); // blue (default)
    }
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
              child: SvgPicture.asset('assets/icons/back.svg', height: 15),
            ),
            const SizedBox(width: 10),
            Text(
              'Claims list',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xffFF1901),
              ),
            ),
          ],
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/icons/search_icon.svg',
          height: 15,
          width: 15,
        ),
      ],
    );
  }

  Widget _buildRemarksSection(GetOperatorState operatorState) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: _containerBoxDecoration(Colors.white, const Offset(0, 0)),
      child: RemarksSection(operatorState: operatorState),
    );
  }

  Widget _buildBottomTabView(List<String> tabsData,GetOperatorState operatorState) {
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
      operatorState: operatorState,
      isFromClaimScreen: true,
         isFromHrScreen:true,
      selectedMonth: selectedMonth.toString(),
      selectedYear: selectedYear.toString(),
    ),);
  }

  BoxDecoration _containerBoxDecoration([
    Color? color,
    Offset shadowOffset = const Offset(0, 0),
    Border? border,
    BorderRadius? borderRadius,
  ]) {
    return BoxDecoration(
      color: color,
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
                  activeIndex = index;
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

class FixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final dynamic customData;

  FixedHeaderDelegate({required this.child, required this.height,  required this.customData,});

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
