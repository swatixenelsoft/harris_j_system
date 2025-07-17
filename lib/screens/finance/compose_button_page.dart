import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/finance/finance_attached_files_screen.dart';
import 'package:harris_j_system/screens/finance/finance_customized_template_screen.dart';
import 'package:harris_j_system/screens/finance/finance_invoice_preview_2_screen.dart';
import 'package:harris_j_system/screens/finance/finance_schedule_screen.dart';
import 'package:harris_j_system/screens/finance/finance_terms_and_condition_screen.dart';
import 'package:harris_j_system/screens/finance/invoice_model_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComposeButtonScreen extends StatefulWidget {
  const ComposeButtonScreen({super.key});

  @override
  _ComposeButtonScreenState createState() => _ComposeButtonScreenState();
}

class _ComposeButtonScreenState extends State<ComposeButtonScreen> {
  List<InvoiceItem> invoiceItems = [
    InvoiceItem(name: 'Resource 1', fee: 100.0),
    InvoiceItem(name: 'Resource 2', fee: 100.0),
    InvoiceItem(name: 'Resource 3', fee: 100.0),
    InvoiceItem(name: 'Resource 4', fee: 100.0),
    InvoiceItem(name: 'Resource 5', fee: 100.0),
  ];
  double taxPercentage = 4.0; // Default tax percentage
  late TextEditingController taxController;

  @override
  void initState() {
    super.initState();
    taxController = TextEditingController(text: taxPercentage.toStringAsFixed(2));
  }

  double get subtotal {
    double sum = 0.0;
    for (var item in invoiceItems) {
      sum += item.fee;
    }
    return sum;
  }
  double get taxAmount => subtotal * (taxPercentage / 100);
  double get total => subtotal - taxAmount;
  @override
  void dispose() {
    taxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
        onProfilePressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeaderContent(),
                  const SizedBox(height: 16),
                ],
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
          // Back + Icons (unchanged)
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/fullgood.svg', height: 29),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/fullhold.svg', height: 29),
                    const SizedBox(width: 5),
                    SvgPicture.asset('assets/icons/reject.svg', height: 29),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          // Email Fields (unchanged)
          _buildLineField(label: 'From:', showPen: false),
          _buildLineField(label: 'To:', showPen: true),
          _buildLineField(label: 'CC:', showPen: true),
          _buildLineField(label: 'Subject:', showPen: true),
          const SizedBox(height: 20),
          // Attached Files Section (unchanged)
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (BuildContext context) {
                  return const AttachmentsDialog();
                },
              );
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffFFEEDA),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    'assets/icons/attach.svg',
                    height: 20,
                    colorFilter: null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Attached Files',
                  style: GoogleFonts.montserrat(
                    color: const Color(0xFFFF1901),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                    decorationColor: const Color(0xFFFF1901),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Maximum allowed file size is 512 MB',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: const Color(0xFF5A5A5A),
            ),
          ),
          const SizedBox(height: 60),
          // Divider above Invoice Preview (unchanged)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
              indent: 0,
              endIndent: 0,
            ),
          ),
          // Invoice Preview and Customize Template Section (unchanged)
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Dialog(
                          insetPadding: const EdgeInsets.all(24),
                          shape: RoundedRectangleBorder(
                            borderRadius:

                            BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: FinanceInvoicePreview2Screen(
                                initialItems: invoiceItems,
                                initialTaxPercentage: taxPercentage,
                                onSave: (updatedItems, updatedTax) {
                                  setState(() {
                                    invoiceItems = updatedItems;
                                    taxPercentage = updatedTax;
                                    taxController.text = taxPercentage.toStringAsFixed(2);
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Invoice Preview',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF1901),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFFF1901),
                    ),
                  ),
                ),
                const SizedBox(width: 70),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return const CustomizeTemplateDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Customize Template',
                    style: GoogleFonts.montserrat(
                      color: const Color(0xFFFF1901),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFFFF1901),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/icons/fullscreen.svg',
                  height: 18,
                ),
              ],
            ),
          ),
          // Divider below Invoice Preview (unchanged)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 1,
              height: 1,
              indent: 0,
              endIndent: 0,
            ),
          ),
          // Invoice Section (Modified to be Non-Editable)
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/cons_logo.png',
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Invoice',
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: 01-04-2025',
                      style: GoogleFonts.montserrat(fontSize: 12),
                    ),
                    Text(
                      'Due Date: 01-04-2025',
                      style: GoogleFonts.montserrat(fontSize: 12),
                    ),
                    Text(
                      'Invoice#: #EM098789',
                      style: GoogleFonts.montserrat(fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill From:',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Color(0xff007BFF),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Encore Films',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                            style: GoogleFonts.montserrat(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill To:',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: Color(0xff28A745),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Encore Films',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                            style: GoogleFonts.montserrat(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    // Header Row
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Name',
                              style: GoogleFonts.montserrat(color: Colors.grey),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Service Fee',
                              style: GoogleFonts.montserrat(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Non-Editable Data Rows
                    for (int i = 0; i < invoiceItems.length; i++)
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                invoiceItems[i].name,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '\$${invoiceItems[i].fee.toStringAsFixed(2)}',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    // Labels
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Subtotal',
                            style: GoogleFonts.montserrat(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Tax Deduction %',
                            style: GoogleFonts.montserrat(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Total',
                            style: GoogleFonts.montserrat(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Divider(height: 32, color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '\$${subtotal.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${taxPercentage.toStringAsFixed(2)}%',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '\$${total.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Colors.grey),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Billing Amt.',
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Auto generated by the system',
                  style: GoogleFonts.spaceGrotesk(
                      color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Terms and Conditions Checkbox (unchanged)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (bool? value) {},
                  activeColor: const Color(0xFFFF1901),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text:
                      'By sending this invoice further you are agreeing to the ',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: const Color(0xff007BFF),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (BuildContext context) {
                                  return const TermsConditionsDialog();
                                },
                              );
                            },
                        ),
                        TextSpan(
                          text: ' of Encore Films.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action Buttons (unchanged)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Download pressed');
                    // TODO: Implement download functionality
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/downloadd.svg',
                    height: 30,
                    colorFilter: null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('Email pressed');
                    // TODO: Implement email functionality
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/email.svg',
                    height: 30,
                    colorFilter: null,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return const ScheduleInvoiceDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SvgPicture.asset(
                    'assets/icons/schedule.svg',
                    height: 30,
                    colorFilter: null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineField({required String label, required bool showPen}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
              if (showPen)
                SvgPicture.asset(
                  'assets/icons/editor.svg',
                  height: 18,
                ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}