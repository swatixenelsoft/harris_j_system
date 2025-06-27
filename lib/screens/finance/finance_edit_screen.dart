import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class EditInvoiceDetailDialog extends StatefulWidget {
  const EditInvoiceDetailDialog({super.key});

  @override
  State<EditInvoiceDetailDialog> createState() =>
      _EditInvoiceDetailDialogState();
}

class _EditInvoiceDetailDialogState extends State<EditInvoiceDetailDialog> {
  final Color brandRed = const Color(0xFFFF1901);

  final TextEditingController totalConsultantsController =
  TextEditingController();
  final TextEditingController totalAmountController = TextEditingController();
  final TextEditingController totalBillingController = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Bar
              Container(
                decoration: BoxDecoration(
                  color: brandRed,
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/person.svg',
                      height: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Edit Invoice Detail",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset('assets/icons/closee.svg', height: 30),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "General Information",
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: brandRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Input Fields and Remarks
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: totalConsultantsController,
                      hintText: "Total Consultants",
                      padding: 0,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: totalAmountController,
                      hintText: "Total Amount",
                      padding: 0,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: totalBillingController,
                      hintText: "Total Billing Amount",
                      padding: 0,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: taxController,
                      hintText: "Tax %",
                      padding: 0,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Remarks *",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    CustomTextField(
                      controller: remarksController,
                      hintText: "Max 200 words are allowed",
                      padding: 0,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: SvgPicture.asset('assets/icons/clearr.svg', height: 36),
                    ),

                    Expanded(
                      child: SvgPicture.asset('assets/icons/savee.svg', height: 36),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
