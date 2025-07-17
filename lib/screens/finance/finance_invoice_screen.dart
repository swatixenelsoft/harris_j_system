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
import 'package:harris_j_system/ulits/custom_loader.dart'; // Added for CustomLoader

class FinanceInvoiceScreen extends StatefulWidget {
  const FinanceInvoiceScreen({super.key});

  @override
  State<FinanceInvoiceScreen> createState() => _FinanceInvoiceScreenState();
}

class _FinanceInvoiceScreenState extends State<FinanceInvoiceScreen> {
  final GlobalKey _menuIconKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool areContactsVisible = true;

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
      'queueColor': const Color.fromRGBO(0, 123, 255, 1),
      'numClaims': '2',
      'totalAmount': '\$500',
      'invoiceAmount': '\$450',
      'invoiceNo': 'INV002',
      'invoiceMonth': 'Aug 2024',
      'status': 'Draft',
    },
    {
      'name': 'Charlie Vetrovs',
      'queueColor': const Color.fromRGBO(0, 123, 255, 1),
      'numClaims': '3',
      'totalAmount': '\$600',
      'invoiceAmount': '\$550',
      'invoiceNo': 'INV003',
      'invoiceMonth': 'Aug 2024',
      'status': 'Completed',
    },
    {
      'name': 'Lincoln Geidt',
      'queueColor': const Color.fromRGBO(0, 123, 255, 1),
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
    super.dispose();
  }

  void _showImportExportPopupBelow(BuildContext context) {
    final RenderBox? renderBox =
        _menuIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
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
            child: FinancePopupMenu(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: SvgPicture.asset('assets/icons/back.svg', height: 15),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff5A5A5A),
                        ),
                        children: [
                          const TextSpan(text: 'BILLING STATUS : ('),
                          TextSpan(
                            text: '10',
                            style: TextStyle(color: Colors.red),
                          ),
                          const TextSpan(text: ','),
                          TextSpan(
                            text: '30',
                            style: TextStyle(color: Colors.green),
                          ),
                          const TextSpan(text: ','),
                          TextSpan(
                            text: '12',
                            style: TextStyle(color: Colors.orange),
                          ),
                          const TextSpan(text: ','),
                          TextSpan(
                            text: '3',
                            style: TextStyle(color: Colors.blue),
                          ),
                          const TextSpan(text: ') / 100'),
                        ],
                      ),
                    ),
                  ],
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(iconPath, height: 40, width: 40),
          const SizedBox(width: 10),
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
                  fontSize: 10,
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
    required String phone,
    required String email,
  }) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
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
            width: 160,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xffFF1901),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(6),
              ),
            ),
            child: Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              name,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/phone_icon.svg'),
                    const SizedBox(width: 4),
                    Text(
                      phone,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/mail_icon.svg'),
                    const SizedBox(width: 4),
                    Text(
                      email,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildClaimsTable() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double nameWidth = screenWidth * 0.25;
    final double queueWidth = screenWidth * 0.15;
    final double numClaimsWidth = screenWidth * 0.15;
    final double totalAmountWidth = screenWidth * 0.20;
    final double invoiceAmountWidth = screenWidth * 0.20;
    final double invoiceNoWidth = screenWidth * 0.20;
    final double invoiceMonthWidth = screenWidth * 0.20;
    final double statusWidth = screenWidth * 0.20;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: screenWidth * 1.35),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: DataTable(
            columnSpacing: 16,
            headingRowHeight: 40,
            dataRowHeight: 60,
            headingRowColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFFF5F5F5),
            ),
            columns: [
              DataColumn(
                label: SizedBox(
                  width: nameWidth,
                  child: Text(
                    'Name/Group',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: queueWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Queue',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff000000),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        'assets/icons/queue.svg',
                        width: 18,
                        height: 18,
                      ),
                    ],
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: numClaimsWidth,
                  child: Text(
                    '#Emp',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: totalAmountWidth,
                  child: Text(
                    'Total Amt',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: invoiceAmountWidth,
                  child: Text(
                    'Invoice Amt',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: invoiceNoWidth,
                  child: Text(
                    'Invoice No.',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: invoiceMonthWidth,
                  child: Text(
                    'Invoice Month',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              DataColumn(
                label: SizedBox(
                  width: statusWidth,
                  child: Text(
                    'Invoice Status',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            rows: consultanciesData.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final name = item['name'] as String? ?? 'Unknown';
              final queueColor = item['queueColor'] as Color? ??
                  const Color.fromRGBO(0, 123, 255, 1);
              final numClaims = item['numClaims'] as String? ?? '-';
              final totalAmount = item['totalAmount'] as String? ?? '-';
              final invoiceAmount = item['invoiceAmount'] as String? ?? '-';
              final invoiceNo = item['invoiceNo'] as String? ?? '-';
              final invoiceMonth = item['invoiceMonth'] as String? ?? '-';
              final status = item['status'] as String? ?? 'Unknown';
              final isCompleted = status == 'Completed';

              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: nameWidth,
                      child: Text(
                        name,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
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
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: numClaimsWidth,
                      child: Text(
                        numClaims,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: totalAmountWidth,
                      child: Text(
                        totalAmount,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: invoiceAmountWidth,
                      child: Text(
                        invoiceAmount,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: invoiceNoWidth,
                      child: Text(
                        invoiceNo,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: invoiceMonthWidth,
                      child: Text(
                        invoiceMonth,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: 90,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? const Color(0xFFE6F0FA)
                              : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isCompleted ? Colors.blue : Colors.grey,
                              ),
                            ),
                          ],
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:  CustomButton(
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Encore Films',
                                style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Invoice Number: EM098789',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(
                                color: Color(0xffE8E8E8),
                                thickness: 1,
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
                                        child: const EditInvoiceDetailDialog(),
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
                      const SizedBox(height: 16),
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
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
                            iconPath:
                                item['iconPath'] ?? 'assets/icons/default.svg',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Compose button placed here

              const SizedBox(height: 12),
              if (areContactsVisible) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _contactCard(
                        label: 'Billing To',
                        name: 'Alfonso Mango',
                        phone: '+65 7863 4563',
                        email: 'sales877@gmail.com',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _contactCard(
                    label: 'Shipping To',
                    name: 'Abram Culhane',
                    phone: '+65 8963 9863',
                    email: 'sales98@gmail.com',
                  ),
                ),
                const SizedBox(height: 12),
              ],

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: _buildRemarksSection(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
