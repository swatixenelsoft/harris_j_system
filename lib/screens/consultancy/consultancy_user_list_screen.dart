import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/bom_provider.dart';
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

class ConsultancyUserListScreen extends ConsumerStatefulWidget {
  const ConsultancyUserListScreen({super.key});

  @override
  ConsumerState<ConsultancyUserListScreen> createState() =>
      _ConsultancyUserListScreenState();
}

class _ConsultancyUserListScreenState
    extends ConsumerState<ConsultancyUserListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // Default filter

  String? token;
  final List<Map<String, dynamic>> consultancies = [
    {
      'user_id': 'Specialty@gmail.com',
      'designation': 'Consultant',
      'actions': {}
    },
    {'user_id': 'Specialty@gmail.com', 'designation': 'Advisor', 'actions': {}},
    {
      'user_id': 'Specialty@gmail.com',
      'designation': 'Human Resources',
      'actions': {}
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Rebuild UI when search text changes
    });
    Future.microtask(() {
      getUserList();
    });
  }

  getUserList() async {
    ref.read(consultancyProvider.notifier).setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    await ref.read(consultancyProvider.notifier).getUsers(token!);

    ref.read(consultancyProvider.notifier).setLoading(false);
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
                title: Text('Disable', style: GoogleFonts.montserrat()),
                onTap: () {
                  setState(() {
                    _filterStatus = 'Disabled';
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
      BuildContext context, Map<String, dynamic> user) {
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
                consultant: user,
                onEdit: (){
                  context.pop();
                  context.push(Constant.consultancyAddUserScreen,
                      extra:user );
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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final consultancyState = ref.watch(consultancyProvider);

    final allUserList =
        (consultancyState.usersList ?? []).cast<Map<String, dynamic>>();

    final List<Map<String, dynamic>> userList = allUserList.where((user) {
      final email = (user['email'] ?? '').toString().toLowerCase();
      final designation = (user['designation'] ?? '').toString().toLowerCase();
      final status = (user['status'] ?? '')
          .toString()
          .toLowerCase(); // You must have a status field in API

      final searchText = _searchController.text.toLowerCase();

      final matchesSearch =
          email.contains(searchText) || designation.contains(searchText);
      final matchesFilter =
          _filterStatus == 'All' ? true : status == _filterStatus.toLowerCase();

      return matchesSearch && matchesFilter;
    }).toList();

    final isLoading = consultancyState.isLoading;
    log('consultancy client $userList');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
          showBackButton: false, image: 'assets/icons/cons_logo.png'),
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  width: constraints.maxWidth,
                  child: Column(
                    children: [
                      _buildHeaderContent(),
                      userList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'No consultancies found',
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
                                  data: userList,
                                  columns: ['email', 'designation','status', 'actions'],
                                  onZoomTap: (user) {
                                    print('Zoom on user: $user');
                                    _showConsultancyPopup(context, user);
                                  },
                                ),
                                columnWidthMode: ColumnWidthMode.fill,
                                headerRowHeight: 38,
                                rowHeight: 52,
                                verticalScrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                columns: [
                                  GridColumn(
                                    columnName: 'email',
                                    width: 130,
                                    label: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: const Color(0xFFF2F2F2),
                                      child: Text(
                                        'User ID',
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
                                    width: 100, // 👈 Increase this width
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
                                    columnName: 'status',
                                    width: 50, // 👈 Increase this width
                                    label: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: const Color(0xFFF2F2F2),
                                      child: Text(
                                        'Status',
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
        ],
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
                const SizedBox(width: 15),
                Text(
                  'User List',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                const Spacer(),
                CustomButton(
                  svgAsset: 'assets/icons/add_icon.svg',
                  text: 'Add User',
                  onPressed: () async {
                    context.push(Constant.consultancyAddUserScreen);
                  },
                  height: 39,
                  width: 110,
                ),
                const SizedBox(width: 10),
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
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                          },
                        )
                      : null,
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
