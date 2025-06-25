import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/consultancy_provider.dart';
import 'package:harris_j_system/screens/consultancy/consultancy_client_detail_popup.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/ulits/delete_pop_up.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ConsultancyClientListScreen extends ConsumerStatefulWidget {
  const ConsultancyClientListScreen({super.key});

  @override
  ConsumerState<ConsultancyClientListScreen> createState() =>
      _ConsultancyClientListScreenState();
}

class _ConsultancyClientListScreenState
    extends ConsumerState<ConsultancyClientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // Default filter

  String? token;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // triggers UI rebuild on search input change
    });
    Future.microtask(() {
      getClientList();
    });
  }

  getClientList() async {
    ref.read(consultancyProvider.notifier).setLoading(true);
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    await ref.read(consultancyProvider.notifier).getClientList(token!);

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
                    _filterStatus = 'Disable';
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
      BuildContext context, Map<String, dynamic> client) {
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
              child: ConsultancyClientDetailPopup(
                client: client,
                onEdit: () {
                  context.pop();
                  context.push(Constant.consultancyAddClientScreen,
                      extra: client);
                },
                onDelete: () {
                  print('fhgfd');
                  DeleteConfirmationDialog.show(
                      context: context,
                      itemName: 'client',
                      onConfirm: () async {
                        final deleteResponse = await ref
                            .read(consultancyProvider.notifier)
                            .deleteClient(client['id'], token!);

                        if (deleteResponse['status'] == true) {
                          Navigator.of(context).pop();
                          ToastHelper.showSuccess(
                            context,
                            deleteResponse['message'] ??
                                'Client deleted successfully',
                          );
                        } else {
                          ToastHelper.showError(
                            context,
                            deleteResponse['message'] ??
                                'Failed to delete client',
                          );
                        }
                      });
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

    final allClients =
        (consultancyState.clientList ?? []).cast<Map<String, dynamic>>();
    final List<Map<String, dynamic>> clientList = allClients.where((client) {
      final status = (client['client_status'] ?? '').toString().toLowerCase();
      final searchText = _searchController.text.toLowerCase();

      // Match status
      final statusMatches =
          _filterStatus == 'All' ? true : status == _filterStatus.toLowerCase();

      // Match search
      final name = (client['serving_client'] ?? '').toString().toLowerCase();
      final consultant = (client['consultants'] ?? '').toString().toLowerCase();
      final searchMatches =
          name.contains(searchText) || consultant.contains(searchText);

      return statusMatches && searchMatches;
    }).toList();

    final isLoading = consultancyState.isLoading;
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
                      clientList.isEmpty
                          ? Expanded(
                              child: Center(
                                child: Text(
                                  'No client found',
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
                                  data: clientList,
                                  columns: [
                                    'serving_client',
                                    'consultants',
                                    'actions'
                                  ],
                                  onZoomTap: (client) {
                                    print('Zoom on consultancy: $client');
                                    _showConsultancyPopup(context,
                                        client); // Use context from the parent scope
                                  },
                                ),
                                columnWidthMode: ColumnWidthMode.fill,
                                headerRowHeight: 38,
                                rowHeight: 52,
                                columns: [
                                  GridColumn(
                                    columnName: 'serving_client',
                                    width: 130,
                                    label: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: const Color(0xFFF2F2F2),
                                      child: Text(
                                        'Serving Client',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'consultants',
                                    width: 130, // 👈 Increase this width
                                    label: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      color: const Color(0xFFF2F2F2),
                                      child: Text(
                                        'Consultants',
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
                  'Clients List',
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
                const Spacer(),
                CustomButton(
                  svgAsset: 'assets/icons/add_icon.svg',
                  text: 'Add Client',
                  onPressed: () {
                    // print("Navigating to consultancyAddClientScreen");

                    context.push(Constant.consultancyAddClientScreen);
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
