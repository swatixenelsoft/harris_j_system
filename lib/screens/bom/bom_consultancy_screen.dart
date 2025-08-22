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
import 'package:harris_j_system/widgets/custom_app_bar2.dart';
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
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await ref.read(bomProvider.notifier).fetchConsultancy(token!);
  }

  OverlayEntry? _overlayEntry;

  void _showImportExportPopupBelow(BuildContext context, GlobalKey key) {
    final RenderBox renderBox =
    key.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;

    // Center the popup horizontally
    double leftPosition = (screenWidth - 200) / 2; // Adjust 200 to popup width

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlayEntry?.remove();
              _overlayEntry = null;
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.1),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
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
                title: Text('Disabled', style: GoogleFonts.montserrat()),
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
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            Center(
              child: ConsultancyDetailPopup(
                consultancy: consultancy,
                onDelete: () {
                  setState(() {
                    consultancies.removeWhere((c) =>
                    c['consultancy_name'] == consultancy['consultancy_name']);
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
    final consultancyState = ref.watch(bomProvider);
    final consultancies = consultancyState.consultancyList ?? [];

    final filteredConsultancies = consultancies.where((consultancy) {
      final name =
          consultancy['consultancy_name']?.toString().toLowerCase() ?? '';
      final type = consultancy['consultancy_status']?.toString() ?? '';
      final matchesSearch = _searchController.text.isEmpty ||
          name.contains(_searchController.text.toLowerCase());
      final matchesStatus = _filterStatus == 'All' || type == _filterStatus;
      return matchesSearch && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar2(
          showBackButton: false, image: 'assets/images/bom/bom_logo.png'),
      body: SafeArea(
        child: NestedScrollView(
          physics: const ClampingScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(
                child: _buildHeaderContent(),
              ),
            ];
          },
          body: consultancyState.isLoading
              ? const Center(
            child: CustomLoader(
              color: Color(0xffFF1901),
              size: 35,
            ),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: constraints.maxWidth,
                  ),
                  child: DataTable(
                    columnSpacing: 16,
                    headingRowHeight: 40,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 56,
                    headingRowColor:
                    MaterialStateProperty.all(
                        const Color(0xFFF2F2F2)),
                    dataTextStyle: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: const Color(0xff1D212D)),
                    columns: [
                      DataColumn(
                        label: Container(
                          width: 140,
                          child: Text(
                            'Consultancy Name',
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          width: 80,
                          child: Text(
                            'Status',
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          width: 60,
                          child: Text(
                            'Actions',
                            style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                    rows: filteredConsultancies.map((consultancy) {
                      return DataRow(
                        cells: [
                          DataCell(
                            Container(
                              width: 140,
                              child: Text(
                                consultancy['consultancy_name'],
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color:
                                    const Color(0xff1D212D)),
                              ),
                            ),
                          ),
                          // ✅ Updated Status Column → Single Clean Dot
                          DataCell(
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.circle,
                                size: 12,
                                color: consultancy[
                                'consultancy_status'] ==
                                    'Active'
                                    ? const Color(0xFF1F9254)
                                    : consultancy[
                                'consultancy_status'] ==
                                    'Disabled'
                                    ? const Color(0xff8D91A0)
                                    : const Color(0xFFF5230C),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () => _showConsultancyPopup(
                                    context, consultancy),
                                child: const CustomIconContainer(
                                    path: 'assets/icons/zoom.svg'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
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
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset('assets/icons/back.svg', height: 18),
                ),
                const SizedBox(width: 12),
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
                    : Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSearchBarVisible = true;
                          });
                        },
                        child: SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            height: 18),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          _showFilterDialog(context);
                        },
                        child: SvgPicture.asset(
                            'assets/icons/filter_icon.svg',
                            height: 18),
                      ),
                      const SizedBox(width: 16),
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
                        height: 40,
                        width: 180,
                      ),
                    ],
                  ),
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
