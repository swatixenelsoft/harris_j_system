import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/bom_provider.dart';
import 'package:harris_j_system/providers/hr_provider.dart';
import 'package:harris_j_system/screens/bom/widget/import_export.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_client_detail_popup.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_user_data_table_widget.dart';
import 'package:harris_j_system/screens/hr/hr_consultant_detail_popup.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/delete_pop_up.dart';
import 'package:harris_j_system/ulits/detail_pop_up.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_search_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class HrConsultantListScreen extends ConsumerStatefulWidget {
  const HrConsultantListScreen({super.key});

  @override
  ConsumerState<HrConsultantListScreen> createState() =>
      _HrConsultantListScreenState();
}

class _HrConsultantListScreenState
    extends ConsumerState<HrConsultantListScreen> {
  String _filterStatus = 'All'; // Default filter

  String? _selectedClient;
  String? _selectedClientId;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];

  String? token;
  List<Map<String, dynamic>> _filteredConsultancies = [];

  getClientList() async {
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

      // ✅ Optionally fetch consultants for the first client
      await getConsultantByClient();
    }

    setState(() {});
  }

  getConsultantByClient() async {
    print('_selectedClientId $_selectedClientId');
    await ref
        .read(hrProvider.notifier)
        .getConsultantByClient(_selectedClientId!, token!);
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    ref.read(hrProvider.notifier).setLoading(true);
    await getClientList();
    await getConsultantByClient();
    ref.read(hrProvider.notifier).setLoading(false);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchData());
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filter by Status',
              style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All', style: GoogleFonts.montserrat()),
                onTap: () {
                  setState(() {
                    _filterStatus = 'All';
                  });

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Active', style: GoogleFonts.montserrat()),
                onTap: () {
                  setState(() {
                    _filterStatus = 'Active';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Inactive', style: GoogleFonts.montserrat()),
                onTap: () {
                  setState(() {
                    _filterStatus = 'Inactive';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Notice Period', style: GoogleFonts.montserrat()),
                onTap: () {
                  setState(() {
                    _filterStatus = 'Notice Period';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConsultancyPopup(
      BuildContext context, Map<String, dynamic> consultancy) {
    print('consultanc111y $consultancy');
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.black.withOpacity(0.2), // Optional dim effect
              ),
            ),
            Center(
              child: HrConsultantDetailPopup(
                consultant: consultancy,
                onEdit: (){

                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultantState = ref.watch(hrProvider);
    final allConsultants =
        (consultantState.consultantList ?? []).cast<Map<String, dynamic>>();

    final List<Map<String, dynamic>> consultancies = _filterStatus == 'All'
        ? allConsultants
        : allConsultants.where((consultant) {
            final status =
                (consultant['status'] ?? '').toString().toLowerCase();
            return status == _filterStatus.toLowerCase();
          }).toList();

    print('consultancies $consultancies');
    final isLoading = consultantState.isLoading;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          showBackButton: false, image: 'assets/icons/cons_logo.png'),
      body: Stack(children: [
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                child: Column(
                  children: [
                    _buildHeaderContent(),
                    consultancies.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'No consultant found',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : Expanded(
                            child: SfDataGrid(
                              source: GenericDataSource(
                                data: consultancies,
                                columns: [
                                  'emp_name',
                                  'status',
                                  'designation',
                                  'actions'
                                ],
                                onZoomTap: (consultancy) {
                                  print('Zoom on consultancy: $consultancy');
                                  _showConsultancyPopup(context, consultancy);
                                },
                              ),
                              columnWidthMode: ColumnWidthMode.fill,
                              headerRowHeight: 38,
                              rowHeight: 52,
                              verticalScrollPhysics:
                                  const NeverScrollableScrollPhysics(),
                              columns: [
                                GridColumn(
                                  columnName: 'emp_name',
                                  width: 100,
                                  label: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: const Color(0xFFF2F2F2),
                                    child: Text(
                                      'Name',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'status',
                                  width: 60, // 👈 Increase this width
                                  label: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: const Color(0xFFF2F2F2),
                                    child: Text(
                                      'Queue',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'designation',
                                  width: 120, // 👈 Increase this width
                                  label: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    color: const Color(0xFFF2F2F2),
                                    child: Text(
                                      'Designation',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'actions',
                                  // width: 110,
                                  label: Container(
                                    alignment: Alignment.center,
                                    color: const Color(0xFFF2F2F2),
                                    child: Text(
                                      'Actions',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              );
            },
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
      ]),
    );
  }

  Widget _buildHeaderContent() {
    print('selectec $_selectedClient');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                const Spacer(),
                CustomButton(
                  svgAsset: 'assets/icons/onboard_consultant_icon.svg',
                  text: 'Onboard Consultants',
                  onPressed: () async {
                    context.push(Constant.hrAddConsultantScreen);
                  },
                  height: 39,
                  width: 150,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Base Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_rawClientList.isNotEmpty && _selectedClient != null)
                    SizedBox(
                      width: 290,
                      child: CustomClientDropdown(
                        clients: _rawClientList,
                        initialClientName: _selectedClient,
                        onChanged: (selectedName, selectedId) async {
                          FocusScope.of(context).unfocus();
                          setState(() {
                            _selectedClient = selectedName;
                            _selectedClientId = selectedId;
                          });
                          await getConsultantByClient();
                        },
                      ),
                    ),
                  const SizedBox(width: 20),
                  // Keep filter icon always fixed in place
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 12), // aligns vertically with search box
                    child: GestureDetector(
                      onTap: () {
                        _showFilterDialog(context);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/filter_icon.svg',
                        height: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class Consultancy {
  final String name;
  final String expiryDate;
  final String status;
  Consultancy({
    required this.name,
    required this.expiryDate,
    required this.status,
  });
}
