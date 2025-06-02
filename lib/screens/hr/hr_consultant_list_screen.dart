import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultancy_provider.dart';
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
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // Default filter

  String? token;
  List<Map<String, dynamic>> consultanciesData = [
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'active',
      'designation': 'Consultant',
      'actions': {}
    },
    {
      'name': 'Bruce Lee',
      'queue': 'Inactive',
      'designation': 'Consultant',
      'actions': {}
    },
  ];

  @override
  void initState() {
    super.initState();
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
            ],
          ),
        );
      },
    );
  }

  void _showConsultancyPopup(
      BuildContext context, Map<String, dynamic> consultancy) {
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
                onDelete: () {},
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filter consultancies based on search and status
    final searchQuery = _searchController.text.toLowerCase();

    // final consultancyState = ref.watch(consultancyProvider);
    final consultancies = consultanciesData ?? [];

    final filteredConsultancies = consultancies.where((consultancy) {
      final name =
          consultancy['consultancy_name']?.toString().toLowerCase() ?? '';
      final type = consultancy['consultancy_status']?.toString() ?? '';

      final matchesSearch =
          searchQuery.isEmpty || name.contains(searchQuery.toLowerCase());
      final matchesStatus = _filterStatus == 'All' || type == _filterStatus;

      return matchesSearch && matchesStatus;
    }).toList();

    print('filteredConsultancies $filteredConsultancies');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          showBackButton: false, image: 'assets/icons/cons_logo.png'),
      body: SafeArea(
        child:
            // consultancyState.isLoading
            //     ? const CustomLoader(
            //         color: Color(0xffFF1901),
            //         size: 35,
            //       )
            //     :

            filteredConsultancies.isEmpty
                ? Center(
                    child: Text(
                      'No consultancies found',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Column(
                          children: [
                            _buildHeaderContent(),
                            Expanded(
                              child: SfDataGrid(
                                source: GenericDataSource(
                                  data: consultancies,
                                  columns: [
                                    'name',
                                    'queue',
                                    'designation',
                                    'actions'
                                  ],
                                  onZoomTap: (consultancy) {
                                    print('Zoom on consultancy: $consultancy');
                                    _showConsultancyPopup(context,
                                        consultancy); // Use context from the parent scope
                                  },
                                ),
                                columnWidthMode: ColumnWidthMode.fill,
                                headerRowHeight: 38,
                                rowHeight: 52,
                                columns: [
                                  GridColumn(
                                    columnName: 'name',
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
                                    columnName: 'queue',
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
    );
  }

  Widget _buildHeaderContent() {
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
          Row(
            children: [
              SizedBox(
                width: 280,
                child: CustomTextField(
                  label: "Search",
                  hintText: "Search Consultant...",
                  controller: _searchController,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(
                        14.0), // optional padding for spacing
                    child: SizedBox(
                      height: 10,
                      width: 10,
                      child: SvgPicture.asset(
                        'assets/icons/search_icon.svg',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {
                  _showFilterDialog(context);
                },
                child: SvgPicture.asset('assets/icons/filter_icon.svg',
                    height: 15),
              ),
            ],
          ),
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
