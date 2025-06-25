import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/bom_provider.dart';
import 'package:harris_j_system/providers/consultant_provider.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:harris_j_system/widgets/custom_app_bar.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HrFeedBackScreen extends ConsumerStatefulWidget {
  const HrFeedBackScreen({super.key});

  @override
  ConsumerState<HrFeedBackScreen> createState() => _HrFeedBackScreenState();
}

class _HrFeedBackScreenState extends ConsumerState<HrFeedBackScreen> {
  final reports = [
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summaryyyyyyyyy",
    "Per Consultancy Data Summary",
    "All Consultancy Data Summary",
    "Offboarded Consultancy Data Summary",
    "Per Consultancy Data Summary",
  ];

  final TextEditingController _feedBackController = TextEditingController();

  Future<void> _addFeedback() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    final feedbackResponse =
        await ref.read(consultantProvider.notifier).addConsultantFeedback(
              token!,
              _feedBackController.text.trim(),
              userId!,
            );

    if (feedbackResponse['success'] == true) {
      _feedBackController.clear();
      ToastHelper.showSuccess(
        context,
        feedbackResponse['message'] ?? 'Feedback submitted successfully.',
      );
    } else {
      ToastHelper.showError(
        context,
        feedbackResponse['message'] ?? 'Failed to submit feedback.',
      );
    }
  }

  @override
  void dispose() {
    _feedBackController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        showBackButton: false,
        image: 'assets/icons/cons_logo.png',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderContent(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Need help? Your request will notify Harris J. Support, & they’ll contact you by email.',
                      style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomTextField(
                      label: '',
                      hintText: "",
                      controller: _feedBackController,
                      maxLines: 6,
                    ),
                  ),
                  const SizedBox(height: 35),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Disclaimer: Your feedback will be shared directly to Harris J. System to enhance the product. Please avoid including personal or sensitive information. ',
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(90, 90, 90, 0.8)),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: CustomButton(
                        width: 124,
                        text: 'Submit',
                        onPressed: () async {
                          await _addFeedback();
                        }),
                  ),
                ],
              ),
            ),
          ),
          // if (isLoading)
          //   Positioned.fill(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          //       child: Container(
          //         color: Colors.black.withOpacity(0.2),
          //         alignment: Alignment.center,
          //         child: const CustomLoader(
          //           color: Color(0xffFF1901),
          //           size: 35,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
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
          bottom: BorderSide.none, // 👈 removes bottom border
        ),
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
                const SizedBox(width: 30),
                Text(
                  'Feedback to Harris J.',
                  style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xffFF1901)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
