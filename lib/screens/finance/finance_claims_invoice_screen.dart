import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/finance_provider.dart';
import 'package:harris_j_system/screens/consultancy/widget/consultancy_client_data_table_widget.dart';
import 'package:harris_j_system/screens/finance/compose_button_page.dart';
import 'package:harris_j_system/screens/finance/finance_edit_screen.dart';
import 'package:harris_j_system/ulits/custom_loader.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_client_dropdown_claim_invoice.dart';
import 'package:harris_j_system/widgets/custom_month_year.dart';
import 'package:harris_j_system/widgets/remark_section.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class FinanceClaimsInvoiceScreen extends ConsumerStatefulWidget {
  const FinanceClaimsInvoiceScreen({super.key});

  @override
  ConsumerState<FinanceClaimsInvoiceScreen> createState() => _FinanceClaimsInvoiceScreenState();
}

class _FinanceClaimsInvoiceScreenState extends ConsumerState<FinanceClaimsInvoiceScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  bool areContactsVisible = true;
  String? token;

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
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
DateTime selectedMonthYear=DateTime.now();
  OverlayEntry? _overlayEntry;

  List<String> _clientList = [];
  List<Map<String, dynamic>> _rawClientList = [];
  String? _selectedClient;
  String? _selectedClientId;
  String? _selectedConsultant;
  String? _selectedConsultantId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      fetchData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    ref.read(financeProvider.notifier).setLoading(true);
    await getClientList();
    await financeClaimClientConsultants();
    ref.read(financeProvider.notifier).setLoading(false);
  }


  getClientList() async {

    final client = await ref.read(financeProvider.notifier).clientListClaimInvoice(token!);

    print('client list $client');

    _rawClientList = List<Map<String, dynamic>>.from(client['data']);

    _clientList = _rawClientList
        .map<String>((item) => item['serving_client'].toString())
        .toList();

    // ✅ Set _selectedClientId as the first client's ID if available
    if (_rawClientList.isNotEmpty) {
      _selectedClientId = _rawClientList[0]['id'].toString();
      _selectedClient = _rawClientList[0]['serving_client'].toString();
    }
    print('data in clientr $_rawClientList,$_selectedClientId,$_selectedClient');

    setState(() {});
  }



  Future<void> financeClaimClientConsultants() async {
    if (_selectedClientId != null && token != null) {
      await ref.read(financeProvider.notifier).financeClaimClientConsultants(
        _selectedClientId!,
        selectedMonth,
        selectedYear,
        token!,
      );

    }
  }

  Future<void> financeClaimConsultantDetails(selectedConsultantId) async {
    if (_selectedClientId != null && token != null) {
       ref.read(financeProvider.notifier).selectConsultantById(
      selectedConsultantId
      );

    }
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
                      TextSpan(text: 'Claim Status : ('),
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
                      TextSpan(text: ') / 45'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          if (_rawClientList.isNotEmpty && _selectedClient != null)
            CustomClientDropDownClaimInvoice(
              clients: _rawClientList,
              initialClientName: _selectedClient,
              onChanged: (selectedClientName, selectedClientId) async {
                FocusScope.of(context).unfocus();
                final selectedClient = _rawClientList.firstWhere(
                      (client) => client['id'].toString() == selectedClientId,
                  orElse: () => {},
                );

                if (selectedClient.isNotEmpty) {
                  setState(() {
                    _selectedClient = selectedClientName;
                    _selectedClientId = selectedClientId;

                    // Clear consultant selection on client change
                    _selectedConsultant = null;
                    _selectedConsultantId = null;
                  });

                  print('_selectedClientId $_selectedClientId');
                  await financeClaimClientConsultants();
                }
              },
              onConsultantChanged: (selectedConsultantName, selectedConsultantId) async {
                setState(() {
                  _selectedConsultant = selectedConsultantName;
                  _selectedConsultantId = selectedConsultantId;
                });

                print('_selectedConsultantId $_selectedConsultantId');
                // Call your provider method or logic to fetch/show consultant details here
                await financeClaimConsultantDetails(_selectedConsultantId);
              },
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
                  fontSize: 7,
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
          // Top Label
          // Top Red Label - now full width
          Container(
            width: 250, // make it stretch full width
            height: 25,
            padding:
            const EdgeInsets.only(left: 20), // label text padding from left
            alignment: Alignment.centerLeft, // align text to the left
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

          // Gray background for name, address and location
          Container(
            width: double.infinity,
            color: const Color(0xFFFAFAFA),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
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

                // Address Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only( right: 6),
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

                // Location Row
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

  Widget _buildRemarksSection(List<dynamic> selectedClientRemarks) {
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
      child:  RemarksSection(selectedClientRemarks:selectedClientRemarks),
    );
  }

  Widget _buildClaimsTable(List<dynamic> consultants) {
    print('consultants $consultants');
    return  SizedBox(
      height: consultants.isEmpty ? 50 : 200,
      child: consultants.isEmpty
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
          data: consultants.expand<Map<String, dynamic>>((consultant) {
            final empName = consultant['emp_name'] ?? 'N/A';
            final claims = consultant['claimsData'] ?? [];

            // If no claims, return one row with basic info
            if (claims.isEmpty) {
              return [
                {
                  'emp_name': empName,
                  'status': 'No Claims',
                  'claim_no': '-',
                  'total_amount': '\$0',
                  'invoice_amount': '\$0',
                  'invoice_no': '-',
                  'invoice_status':'-',
                }
              ];
            }

            // For each claim, make a row
            return claims.map<Map<String, dynamic>>((claim) {
              final record = claim['record'] ?? {};
              return {
                'emp_name': empName,
                'status': claim['status'] ?? 'Pending',
                'claim_no': claim['form_count'] ?? '-',
                'total_amount': '\$${record['amount'] ?? '0'}',
                'invoice_amount': '\$${record['amount'] ?? '0'}', // replace with actual if available
                'invoice_no': record['claim_no'] ?? '-',
                'invoice_status': claim['status'] ?? 'Pending',
              };
            });
          }).toList(),

          columns: [
            'emp_name',
            'status',
            'claim_no',
            'total_amount',
            'invoice_amount',
            'invoice_no',
            'invoice_status'
          ],
          onZoomTap: (rowData) {
            // _showConsultancyPopup(context, rowData['full_data']);
          },

        ),
        columnWidthMode: ColumnWidthMode.auto,
        headerRowHeight: 40,
        rowHeight: 52,
        selectionMode: SelectionMode.single,
        onCellTap: (details) async {
          final index = details.rowColumnIndex.rowIndex - 1;
          if (index < 0 || index >= consultants.length) return;

          final selectedData = consultants[index];
          ref
              .read(financeProvider.notifier)
              .getSelectedConsultantDetails(selectedData);

        },
        columns: [
          GridColumn(
            columnName: 'emp_name',
            width: 110,
            label: _buildHeaderCell('Name',
                iconPath: 'assets/icons/search_o.svg'),
          ),
          GridColumn(
            columnName: 'status',
            width: 80,
            label: _buildHeaderCell('Queue',
                iconPath: 'assets/icons/queue.svg',),
          ),
          GridColumn(
            columnName: 'claim_no',
            width: 80,
            label: _buildHeaderCell('#Claims'),
          ),
          GridColumn(
            columnName: 'total_amount',
            width: 80,
            label: _buildHeaderCell('Total Amt',
                 ),
          ),
          GridColumn(
            columnName: 'invoice_amount',
            width: 80,
            label: _buildHeaderCell('Invoice Amt',),
          ),
          GridColumn(
            columnName: 'invoice_no',
            width: 100,
            label: _buildHeaderCell('Invoice No',
            ),
          ),
            GridColumn(
              columnName: 'invoice_status',
              width: 100,
              label: _buildHeaderCell('Invoice Status',
              ),
          ),


        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title,
      {String? iconPath, Alignment alignment = Alignment.centerLeft}) {
    return Align(
      alignment: alignment,
      child: Row(
        mainAxisAlignment: alignment == Alignment.center
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
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
            SizedBox(width: title == 'Name' ? 40 : 6),
            SvgPicture.asset(iconPath, width: 15, height: 15),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final financeState = ref.watch(financeProvider);

    final List<dynamic> fullConsultantData = financeState.claimInvoiceConsultantList ?? [];
    final List<Map<String, dynamic>> selectedClientInvoiceSummary=financeState.selectedClientInvoiceSummary??[];
    final List<dynamic> selectedClientRemarks=financeState.selectedClientRemarks??[];

    final isConsultantSelected = _selectedConsultantId != null;
    final isLoading = financeState.isLoading;
    print('selectedClientRemarks $selectedClientRemarks');



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
      body: Stack(
        children:[ SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeaderContent(),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _showMonthYearPicker(context),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/month_calendar_icon.svg',
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat("MMMM - y").format(selectedMonthYear),
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff5A5A5A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: _buildClaimsTable(isConsultantSelected?[financeState.selectedConsultantDetail]:fullConsultantData),
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
                          padding:
                          const EdgeInsets.only(left: 20, right: 15, top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedClient??"",
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
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20)),
                                        ),
                                        builder: (context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom,
                                            ),
                                            child:
                                            const EditInvoiceDetailDialog(),
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
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, bottom: 15),
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.0,
                            ),
                            itemCount: selectedClientInvoiceSummary.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = selectedClientInvoiceSummary[index];
                              print('selectedClientInvoiceSummary $item');
                              return consultancyCard(
                                count: item['count'] ?? '0',
                                label: item['label'] ?? 'Unknown',
                                iconPath: item['iconPath'] ??
                                    'assets/icons/default.svg',
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
                          address: 'No.22,Abcd Street, RR Nager, Chennai-600016,'
                              'Tamil Nadu, India',
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
                      address: 'No.22,Abcd Street, RR Nager, Chennai-600016,'
                          'Tamil Nadu, India',
                      location: 'X5JX+HX Chennai, Tamil Nadu',
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 16),
                _buildRemarksSection(selectedClientRemarks),
                const SizedBox(height: 16),
              ],
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

  Future<void> _showMonthYearPicker(BuildContext context) async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => MonthYearPickerDialog(
        initialDate: selectedMonthYear,
      ),
    );

    if (selectedDate != null) {
      setState(() {
         selectedMonth = selectedDate.month;
         selectedYear = selectedDate.year;
         selectedMonthYear=selectedDate;
      });

      await financeClaimClientConsultants();

    }
  }
}
