import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/screens/navigation/constant.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';

class ConsultancyDetailPopup extends StatelessWidget {
  final Map<String, dynamic> consultancy;
  final VoidCallback onDelete; // Callback to notify parent of deletion

  const ConsultancyDetailPopup(
      {super.key, required this.consultancy, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 356,
          constraints: const BoxConstraints(maxHeight: 380),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button at top right
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.asset('assets/icons/close.png', height: 25),
                ),
              ),
              const SizedBox(height: 20),

              // Header with title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Consultancy Information',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.pop();
                          context.push(Constant.bomAddConsultancyScreen,
                              extra: consultancy);
                        },
                        child: CustomIconContainer(
                            path: 'assets/icons/edit_pen.svg',
                            bgColor: Color(0xffF5230C)),
                      ),
                      SizedBox(width: 7),
                      // CustomIconContainer(
                      //     path: 'assets/icons/red_delete_icon.svg'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fields in Column with Pair-wise Rows
              Column(
                children: [
                  // Consultancy Name and Primary Contact Person
                  _buildFieldPair(
                    leftLabel: 'Consultancy Name',
                    leftValue: consultancy['consultancy_name'],
                    rightLabel: 'Primary Contact Person',
                    rightValue: consultancy['primary_contact'],
                  ),
                  const SizedBox(height: 16),

                  // Country and Primary Email
                  _buildFieldPair(
                    leftLabel: 'Country',
                    leftWidget: Row(
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(consultancy['flag']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          consultancy['country'],
                          style: GoogleFonts.montserrat(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    rightLabel: 'Primary Email',
                    rightValue: consultancy['primary_email'],
                  ),
                  const SizedBox(height: 16),

                  // Primary Contact No and Fee Structure
                  _buildFieldPair(
                    leftLabel: 'Primary Contact No',
                    leftValue: consultancy['primary_mobile'] == null
                        ? "No Number"
                        : '${consultancy['primary_mobile_country_code']} ${consultancy['primary_mobile']}',
                    rightLabel: 'Fee Structure',
                    rightValue: consultancy['fees_structure'],
                  ),
                  const SizedBox(height: 16),

                  // Status on the left (only colored dot with background)
                  _buildFieldPair(
                    leftLabel: 'Status',
                    leftWidget: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: consultancy['consultancy_status'] == 'Active'
                            ? const Color(0xFFEBF9F1)
                            : const Color(0xFFFBE7E8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: consultancy['consultancy_status'] == 'Active'
                            ? const Color(0xFF1F9254)
                            : const Color(0xFFF5230C),
                      ),
                    ),
                    rightLabel: '',
                    rightValue: '',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldPair({
    required String leftLabel,
    String? leftValue,
    Widget? leftWidget,
    required String rightLabel,
    String? rightValue,
    Widget? rightWidget,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildField(
            label: leftLabel,
            value: leftValue,
            widget: leftWidget,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildField(
            label: rightLabel,
            value: rightValue,
            widget: rightWidget,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    String? value,
    Widget? widget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        widget ??
            Text(
              value ?? '',
              style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1D212D)),
            ),
      ],
    );
  }
}