import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;
import 'package:harris_j_system/providers/bom_provider.dart';
import 'package:harris_j_system/screens/bom/widget/import_export.dart';
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

class BomConsultancyScreen extends ConsumerStatefulWidget {
  const BomConsultancyScreen({super.key});

  @override
  ConsumerState<BomConsultancyScreen> createState() =>
      _BomConsultancyScreenState();
}

class _BomConsultancyScreenState extends ConsumerState<BomConsultancyScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterStatus = 'All'; // Default filter
  bool isSearchBarVisible = false; // Track search bar visibility
  late List<Map<String, dynamic>> consultancies;
  final GlobalKey _menuIconKey = GlobalKey();
  String? token;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getConsultancyData();
    });
  }

  Future<void> _getConsultancyData() async {
    print('ghkjhk');

    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await ref.read(bomProvider.notifier).fetchConsultancy(token!);
  }

  // void _showConsultancyPopup(BuildContext context, Consultancy consultancy) {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     builder: (BuildContext context) {
  //       return Stack(
  //         children: [
  //           BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Container(color: Colors.transparent),
  //           ),
  //           Center(
  //             child: ConsultancyPopup(
  //               consultancy: consultancy,
  //               onDelete: () {
  //                 setState(() {
  //                   consultancies.removeWhere((c) => c.name == consultancy.name);
  //                 });
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  OverlayEntry? _overlayEntry;

  void _showImportExportPopupBelow(BuildContext context, GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive left position
    double leftPosition = screenWidth * 0.40;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background blur with dismiss
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1), // Light overlay
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),

          // Positioned popup
          Positioned(
            left: leftPosition,
            top: position.dy + size.height + 10,
            child: ImportExportMenu(
              onClose: () {
                _overlayEntry?.remove();
                _overlayEntry = null;
              },
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
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

  // void _showImportExportPopup(BuildContext context) {
  //
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     builder: (BuildContext context) {
  //       return Stack(
  //         children: [
  //           BackdropFilter(
  //             filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //             child: Container(color: Colors.transparent),
  //           ),
  //           ImportExportMenu(),
  //         ],
  //       );
  //     },
  //   );
  // }

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
              child: ConsultancyDetailPopup(
                consultancy: consultancy,
                onDelete: () {
                  setState(() {
                    consultancies.removeWhere((c) =>
                        c['consultancy_name'] ==
                        consultancy['consultancy_name']);
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
    // Filter consultancies based on search and status
    final searchQuery = _searchController.text.toLowerCase();

    final consultancyState = ref.watch(bomProvider);
    final consultancies = consultancyState.consultancyList ?? [];

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
          showBackButton: false, image: 'assets/images/bom/bom_logo.png'),
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeaderContent(),
                  ],
                ),
              ),
            ];
          },
          body: consultancyState.isLoading
              ? const CustomLoader(
                  color: Color(0xffFF1901),
                  size: 35,
                )
              : filteredConsultancies.isEmpty
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
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columnSpacing: 8,
                                headingRowHeight: 38,
                                dataRowMinHeight: 52,
                                dataRowMaxHeight: 52,
                                headingRowColor: MaterialStateProperty.all(
                                    const Color(0xFFF2F2F2)),
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      'Consultancy Name',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'License Expiry & Status',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                                rows: filteredConsultancies.map((consultancy) {
                                  return DataRow(
                                    cells: [
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 110, maxWidth: 110),
                                          child: Text(
                                            consultancy['consultancy_name'],
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff1D212D)),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 130, maxWidth: 130),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    DateFormat('dd / MM / yyyy')
                                                        .format(DateTime.parse(
                                                            consultancy[
                                                                'license_end_date'])),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xff1D212D)),
                                                  ),
                                                  const SizedBox(width: 2),
                                                  // Text(
                                                  //   consultancy.expiryDate
                                                  //       .split(' ')[1],
                                                  //   style:
                                                  //       GoogleFonts.montserrat(
                                                  //           fontSize: 10,
                                                  //           fontWeight:
                                                  //               FontWeight.w500,
                                                  //           color: const Color(
                                                  //               0xff1D212D)),
                                                  // ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: consultancy[
                                                              'consultancy_status'] ==
                                                          'Active'
                                                      ? const Color(0xFFEBF9F1)
                                                      : const Color(0xFFFBE7E8),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      size: 8,
                                                      color: consultancy[
                                                                  'consultancy_status'] ==
                                                              'Active'
                                                          ? const Color(
                                                              0xFF1F9254)
                                                          : const Color(
                                                              0xFFF5230C),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      consultancy[
                                                          'consultancy_status'],
                                                      style: GoogleFonts
                                                          .spaceGrotesk(
                                                        color: consultancy[
                                                                    'consultancy_status'] ==
                                                                'Active'
                                                            ? const Color(
                                                                0xFF1F9254)
                                                            : const Color(
                                                                0xFFF5230C),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              minWidth: 120, maxWidth: 120),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                  onTap: () =>
                                                      _showConsultancyPopup(
                                                          context, consultancy),
                                                  child: const CustomIconContainer(
                                                      path:
                                                          'assets/icons/zoom.svg')),
                                              const SizedBox(width: 7),
                                              GestureDetector(
                                                onTap: () {
                                                  context.push(
                                                      Constant
                                                          .bomAddConsultancyScreen,
                                                      extra: consultancy);
                                                },
                                                child: const CustomIconContainer(
                                                    path:
                                                        'assets/icons/edit_pen.svg',
                                                    bgColor: Color(0xffF5230C)),
                                              ),
                                              const SizedBox(width: 7),
                                              GestureDetector(
                                                onTap: () =>
                                                    DeleteConfirmationDialog.show(
                                                        context: context,
                                                        itemName: 'consultancy',
                                                        onConfirm: () async {
                                                          final deleteResponse =
                                                              await ref
                                                                  .read(bomProvider
                                                                      .notifier)
                                                                  .deleteConsultancy(
                                                                      consultancy[
                                                                          'id'],
                                                                      token!);

                                                          if (deleteResponse[
                                                                  'status'] ==
                                                              true) {
                                                            ToastHelper
                                                                .showSuccess(
                                                              context,
                                                              deleteResponse[
                                                                      'message'] ??
                                                                  'Consultancy deleted successfully',
                                                            );
                                                          } else {
                                                            ToastHelper
                                                                .showError(
                                                              context,
                                                              deleteResponse[
                                                                      'message'] ??
                                                                  'Failed to delete consultancy',
                                                            );
                                                          }
                                                        }),
                                                child: const CustomIconContainer(
                                                    path:
                                                        'assets/icons/red_delete_icon.svg'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      context.pop();
                    },
                    child:
                        SvgPicture.asset('assets/icons/back.svg', height: 15)),
                const SizedBox(width: 10),
                isSearchBarVisible
                    ? Expanded(
                        child: CustomTextField(
                          label: "Search",
                          hintText: "Search Consultancies...",
                          controller: _searchController,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close,
                                size: 20, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                isSearchBarVisible = false;
                              });
                            },
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSearchBarVisible = true;
                              });
                            },
                            child: SvgPicture.asset(
                                'assets/icons/search_icon.svg',
                                height: 15),
                          ),
                          const SizedBox(width: 15),
                          GestureDetector(
                            onTap: () {
                              _showFilterDialog(context);
                            },
                            child: SvgPicture.asset(
                                'assets/icons/filter_icon.svg',
                                height: 15),
                          ),
                          const SizedBox(width: 15),
                          CustomButton(
                            svgAsset: 'assets/icons/add_icon.svg',
                            text: 'Add Consultancy',
                            onPressed: () async {
                              final response = await context
                                  .push(Constant.bomAddConsultancyScreen);

                              if (response == true) {
                                _getConsultancyData();
                              }
                            },
                            height: 39,
                            width: 160,
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            key: _menuIconKey,
                            onTap: () => _showImportExportPopupBelow(
                                context, _menuIconKey),
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                'assets/icons/menu.svg',
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
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
