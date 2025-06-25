import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:harris_j_system/screens/finance/finance_attached_files_screen.dart';
import 'package:harris_j_system/screens/finance/finance_customized_template_screen.dart';
import 'package:harris_j_system/screens/finance/finance_invoice_preview_2_screen.dart';
import 'package:harris_j_system/screens/finance/finance_invoice_preview_screen.dart';
import 'package:harris_j_system/screens/finance/finance_schedule_screen.dart';
import 'package:harris_j_system/screens/finance/finance_terms_and_condition_screen.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ComposeButton2Screen extends StatefulWidget {
  const ComposeButton2Screen({super.key});

  @override
  _ComposeButton2ScreenState createState() => _ComposeButton2ScreenState();
}

class _ComposeButton2ScreenState extends State<ComposeButton2Screen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    _ccController.dispose();
    _subjectController.dispose();
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
          _buildLineField(
              label: 'From:', controller: _fromController, showPen: false),
          _buildLineField(
              label: 'To:', controller: _toController, showPen: true),
          _buildLineField(
              label: 'CC:', controller: _ccController, showPen: true),
          _buildLineField(
              label: 'Subject:', controller: _subjectController, showPen: true),
          const SizedBox(height: 20),
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
              foregroundColor: Colors.white,
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
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 800),
                              child: const FinanceInvoicePreview2Screen(),
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
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      builder: (BuildContext context) {
                        return CustomizeTemplateDialog();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (bool? value) {},
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  side: BorderSide(color: Colors.black),
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
                                  return TermsConditionsDialog();
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
          const SizedBox(height: 80),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Download pressed');
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
                        return ScheduleInvoiceDialog();
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

  Widget _buildLineField({
    required String label,
    required TextEditingController controller,
    required bool showPen,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8), // Space between label and TextField
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero, // Remove default padding
                  ),
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
          const Divider(
            color: Color(0xFFE8E8E8),
            thickness: 1,
            height: 10, // Adjusted to bring divider closer
          ),
        ],
      ),
    );
  }
}
