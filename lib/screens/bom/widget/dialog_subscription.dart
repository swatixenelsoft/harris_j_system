import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class ChooseSubscriptionDialog extends StatefulWidget {
  final TextEditingController controller;

  const ChooseSubscriptionDialog({super.key, required this.controller});

  @override
  State<ChooseSubscriptionDialog> createState() =>
      _ChooseSubscriptionDialogState();
}

class _ChooseSubscriptionDialogState extends State<ChooseSubscriptionDialog> with SingleTickerProviderStateMixin {
  final TextEditingController freeOfferController = TextEditingController();
  final TextEditingController slab1Controller = TextEditingController();
  final TextEditingController slab1CostController = TextEditingController();
  final TextEditingController slab2Controller = TextEditingController();
  final TextEditingController slab2CostController = TextEditingController();
  final TextEditingController slab3Controller = TextEditingController();
  final TextEditingController slab3CostController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150), // Adjust duration for smoothness
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    freeOfferController.dispose();
    slab1Controller.dispose();
    slab1CostController.dispose();
    slab2Controller.dispose();
    slab2CostController.dispose();
    slab3Controller.dispose();
    slab3CostController.dispose();
    super.dispose();
  }

  void _closeDialog() async {
    if (!_isClosing) {
      setState(() {
        _isClosing = true;
      });
      await _animationController.forward();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.59,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildTopHeader("Choose Subscription", _closeDialog),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey[400]!,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Subscription Plans",
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFFF1901),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Divider(
                                color: Colors.black54,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          hintText: "Enter Free Offer Count",
                          controller: freeOfferController,
                          borderRadius: 10,
                          useUnderlineBorder: false,
                          padding: 14,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Slab 1 Value",
                                controller: slab1Controller,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Cost / Consultant",
                                controller: slab1CostController,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Slab 2 Value",
                                controller: slab2Controller,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Cost / Consultant",
                                controller: slab2CostController,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Slab 3 Value",
                                controller: slab3Controller,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomTextField(
                                hintText: "Enter Cost / Consultant",
                                controller: slab3CostController,
                                borderRadius: 10,
                                useUnderlineBorder: false,
                                padding: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: CustomButton(
                  text: "Submit",
                  onPressed: _closeDialog,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTopHeader(String title, VoidCallback onClose) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFFFF1901),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/subscription.svg',
              width: 22,
              height: 22,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onClose,
              child: SvgPicture.asset(
                'assets/icons/closee.svg',
                height: 28,
                width: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}