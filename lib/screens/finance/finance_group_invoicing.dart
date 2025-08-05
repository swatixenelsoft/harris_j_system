import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/widget/finance_popup.dart';
import 'package:harris_j_system/screens/finance/compose_button_page.dart';
import 'package:harris_j_system/screens/finance/finance_edit_screen.dart';
import 'package:harris_j_system/screens/operator/action_click.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';

class FinanceGroupInvoiceScreen extends StatefulWidget {
  const FinanceGroupInvoiceScreen({super.key});

  @override
  State<FinanceGroupInvoiceScreen> createState() => _FinanceGroupInvoiceScreenState();
}

class _FinanceGroupInvoiceScreenState extends State<FinanceGroupInvoiceScreen> {
  final GlobalKey _menuIconKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool areContactsVisible = true;// global/local is shown globally in the program

  final List<Map<String, String>> consultancyData = [
    {
      'count': '200',
      'label': 'Total Consultants',
      'iconPath': 'assets/icons/total_consultants.svg',
    },
    {
      'count': '\$500',
      'label': 'Total Amount',
      'iconPath': 'assets/icons/total_amount.svg',
    },
    {
      'count': '4%',
      'label': 'Tax %',
      'iconPath': 'assets/icons/tax.svg',
    },
    {
      'count': '\$600',
      'label': 'Total Billing Amt.',
      'iconPath': 'assets/icons/total_billing.svg',
    },
  ];

  final List<Map<String, dynamic>> consultanciesData = [
    {
      'name': 'Bruce Lee',
      'queueColor': const Color.fromRGBO(0, 123, 255, 1),
      'numClaims': '2',
      'totalAmount': '\$300',
      'invoiceAmount': '\$250',
      'invoiceNo': 'INV001',
      'invoiceMonth': 'Aug 2024',
      'status': 'Completed',
    },
    {
      'name': 'Allison Schleifer',
      'queueColor': const Color.fromRGBO(255, 193, 7, 1),
      'numClaims': '2',
      'totalAmount': '\$500',
      'invoiceAmount': '\$450',
      'invoiceNo': 'INV002',
      'invoiceMonth': 'Aug 2024',
      'status': 'Draft',
    },

    {
      'name': 'Charlie Vetrovs',
      'queueColor': const Color.fromRGBO(40, 167, 69, 1),
      'numClaims': '3',
      'totalAmount': '\$600',
      'invoiceAmount': '\$550',
      'invoiceNo': 'INV003',
      'invoiceMonth': 'Aug 2024',
      'status': 'Completed',
    },
    {
      'name': 'Lincoln Geidt',
      'queueColor': const Color.fromRGBO(255, 25, 1, 1),
      'numClaims': '2',
      'totalAmount': '\$800',
      'invoiceAmount': '\$750',
      'invoiceNo': 'INV004',
      'invoiceMonth': 'Aug 2024',
      'status': 'Draft',
    },
  ];

  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.remove();
    _overlayEntry = null;
    super.dispose();
  }
  void _showImportExportPopupBelow(BuildContext context) {
    final RenderBox? renderBox = _menuIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null || !mounted) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    double leftPosition = screenWidth * 0.60;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  _overlayEntry?.remove();
                  _overlayEntry = null;
                });
              }
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
            child: FinancePopupMenu(
              onClose: () {
                if (mounted) {
                  setState(() {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Color(0xffE8E8E8)),
          left: BorderSide(color: Color(0xffE8E8E8)),
          right: BorderSide(color: Color(0xffE8E8E8)),
          bottom: BorderSide.none,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              children: [
                GestureDetector(
                  key: _menuIconKey, // Attach the key here
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                ),
                const SizedBox(width: 30),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff5A5A5A),
                    ),
                    children: const [
                      TextSpan(text: 'BILLING STATUS : '),
                      TextSpan(
                        text: '10',
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(text: ','),
                      TextSpan(
                        text: '30',
                        style: TextStyle(color: Colors.green),
                      ),
                      TextSpan(text: ','),
                      TextSpan(
                        text: '12',
                        style: TextStyle(color: Colors.orange),
                      ),
                      TextSpan(text: ','),
                      TextSpan(
                        text: '3',
                        style: TextStyle(color: Colors.blue),
                      ),
                      TextSpan(text: ') / 100'),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _showImportExportPopupBelow(context),
                  child: SvgPicture.asset('assets/icons/menu.svg', height: 20), // Example icon
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          CustomTextField(
            hintText: 'Start typing or click to see clients/consultant',
            label: 'Start typing or click to see clients/consultant',
            controller: _searchController,
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 30,
              color: Color(0xff8D91A0),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(14.0),
              child: SizedBox(
                height: 10,
                width: 10,
                child: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget consultancyCard({
    required String count,
    required String label,
    required String iconPath,
  }) {
    return Container(
      height: 90,
      width: 180,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, height: 40, width: 40),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 26,
                  color: Colors.black,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: 8,
                  color: const Color(0xffA7A7A7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactCard({
    required String label,
    required String name,
    required String address,
    required String location,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 7,
            spreadRadius: 1,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 250,
            height: 25,
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Color(0xffFF1901),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(13),
                topLeft: Radius.circular(6),
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color(0xFFFAFAFA),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SvgPicture.asset(
                        'assets/icons/address_invoice.svg',
                        width: 27,
                        height: 27,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        address,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true,
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: SvgPicture.asset(
                        'assets/icons/location_invoice.svg',
                        width: 27,
                        height: 27,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        location,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true,
                        maxLines: 3,
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

  Widget _buildRemarksSection() {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: const RemarksSection(),
    );
  }
  Widget _buildHeaderText(String text, double fontSize) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildQueueHeader(double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Queue',
          style: GoogleFonts.montserrat(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  DataCell _buildCell(String text, double width, double fontSize, {bool center = false}) {
    return DataCell(
      SizedBox(
        width: width,
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: fontSize,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: center ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }

  Widget _buildClaimsTable() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xffE8E8E8),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'Total Consultants: 4',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth = constraints.maxWidth;
              const double minColumnWidth = 80.0;
              const double maxColumnWidth = 150.0;
              final double nameWidth = (availableWidth * 0.20).clamp(minColumnWidth, maxColumnWidth);
              final double queueWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double hrsLgdFcstWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double totalAmtWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double invoiceAmtWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double invoiceNoWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double invoiceMonthWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double statusWidth = (availableWidth * 0.15).clamp(minColumnWidth, maxColumnWidth);
              final double fontSize = (availableWidth < 600 ? 10 : 12).toDouble();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: availableWidth),
                  child: Column(
                    children: [
                      DataTable(
                        columnSpacing: 8,
                        headingRowHeight: 40,
                        dataRowHeight: 60,
                        dividerThickness: 1,
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Color(0xffE8E8E8),
                            width: 1,
                          ),
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                              (states) => const Color(0xFFD3D3D3),
                        ),
                        columns: [
                          DataColumn(label: SizedBox(width: nameWidth, child: _buildHeaderText('Name', fontSize))),
                          DataColumn(label: SizedBox(width: queueWidth, child: _buildQueueHeader(fontSize))),
                          DataColumn(label: SizedBox(width: hrsLgdFcstWidth, child: _buildHeaderText('Hrs Lgd/Fcst', fontSize))),
                          DataColumn(label: SizedBox(width: totalAmtWidth, child: _buildHeaderText('Total Amt', fontSize))),
                          DataColumn(label: SizedBox(width: invoiceAmtWidth, child: _buildHeaderText('Invoice Amt', fontSize))),
                          DataColumn(label: SizedBox(width: invoiceNoWidth, child: _buildHeaderText('Invoice No', fontSize))),
                          DataColumn(label: SizedBox(width: invoiceMonthWidth, child: _buildHeaderText('Invoice Month', fontSize))),
                          DataColumn(label: SizedBox(width: statusWidth, child: _buildHeaderText('Invoice Status', fontSize))),
                        ],
                        rows: consultanciesData.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;
                          final name = item['name'] as String? ?? 'Unknown';
                          final queueColor = item['queueColor'] as Color? ?? const Color.fromRGBO(0, 123, 255, 1);
                          final hrsLgdFcst = index == 0 || index == 3 ? '0/160' : '100/160';
                          final totalAmount = item['totalAmount'] as String? ?? '-';
                          final invoiceAmount = item['invoiceAmount'] as String? ?? '-';
                          final invoiceNo = item['invoiceNo'] as String? ?? '-';
                          final invoiceMonth = item['invoiceMonth'] as String? ?? '-';
                          final status = item['status'] as String? ?? 'Unknown';
                          final isCompleted = status == 'Completed';

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.selected)) {
                                return const Color(0xffE4E4EF);
                              }
                              return Colors.white;
                            }),
                            cells: [
                              _buildCell(name, nameWidth, fontSize),
                              DataCell(SizedBox(
                                width: queueWidth,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: queueColor,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              )),
                              _buildCell(hrsLgdFcst, hrsLgdFcstWidth, fontSize, center: true),
                              _buildCell(totalAmount, totalAmtWidth, fontSize, center: true),
                              _buildCell(invoiceAmount, invoiceAmtWidth, fontSize, center: true),
                              _buildCell(invoiceNo, invoiceNoWidth, fontSize, center: true),
                              _buildCell(invoiceMonth, invoiceMonthWidth, fontSize, center: true),
                              DataCell(SizedBox(
                                width: statusWidth,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isCompleted ? const Color(0xFFE6F0FA) : const Color(0xFFF5F5F5),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: isCompleted ? Colors.blue : Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        status,
                                        style: GoogleFonts.montserrat(
                                          fontSize: fontSize,
                                          fontWeight: FontWeight.w500,
                                          color: isCompleted ? Colors.blue : Colors.grey,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                      const Divider(
                        color: Color(0xffE8E8E8),
                        height: 1,
                        thickness: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xff969696),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: const BoxDecoration(
                          color: Color(0xffF2F2F2),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        'Selected Row',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: const Color(0xffF2F2F2),
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomButton(
        text: 'Compose',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ComposeButtonScreen(),
            ),
          );
        },
        height: 40,
        width: 120,
        color: const Color(0xffFF1901),
        svgAsset: 'assets/icons/white_edit.svg',
        textStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        leftPadding: 10,
      ),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
        onProfilePressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          context.go('/login');
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderContent(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildClaimsTable(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        blurRadius: 1,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 15, top: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Encore Films',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Invoice Number: EM098789',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context).viewInsets.bottom,
                                          ),
                                          child: const EditInvoiceDetailDialog(), // Ensure this widget is defined
                                        );
                                      },
                                    );
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/editor.svg',
                                    height: 25,
                                    width: 25,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      areContactsVisible = !areContactsVisible;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                    areContactsVisible
                                        ? 'assets/icons/upside.svg'
                                        : 'assets/icons/downside.svg',
                                    height: 20,
                                    width: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Divider(
                        color: Color(0xffE1E1E1),
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 2.0,
                          ),
                          itemCount: consultancyData.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = consultancyData[index];
                            return consultancyCard(
                              count: item['count'] ?? '0',
                              label: item['label'] ?? 'Unknown',
                              iconPath: item['iconPath'] ?? 'assets/icons/default.svg',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (areContactsVisible) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _contactCard(
                        label: 'Billing To',
                        name: 'Alfonso Mango',
                        address: 'No.22, Abcd Street, RR Nagar, Chennai-600016, Tamil Nadu, India',
                        location: 'X5JX+HX Chennai, Tamil Nadu',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: _contactCard(
                    label: 'Shipping To',
                    name: 'Abram Culhane',
                    address: 'No.22, Abcd Street, RR Nagar, Chennai-600016, Tamil Nadu, India',
                    location: 'X5JX+HX Chennai, Tamil Nadu',
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 16),
              _buildRemarksSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder for EditInvoiceDetailDialog (replace with actual implementation)
class EditInvoiceDetailDialog extends StatelessWidget {
  const EditInvoiceDetailDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Edit Invoice Details',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          // Add form fields or other widgets as needed
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}