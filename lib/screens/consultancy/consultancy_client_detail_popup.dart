import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:intl/intl.dart';


class ConsultancyClientDetailPopup extends StatelessWidget {
  final Map<String,dynamic> consultancy;
  final VoidCallback onDelete; // Callback to notify parent of deletion

  const ConsultancyClientDetailPopup({super.key, required this.consultancy, required this.onDelete});

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
          constraints: const BoxConstraints(maxHeight: 400),
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
              const SizedBox(height: 15),

              // Header with title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Serving Client Information',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Row(
                    children: [
                      CustomIconContainer(
                          path: 'assets/icons/edit_pen.svg',
                          bgColor:
                          Color(0xffF5230C)),
                      SizedBox(width: 7),
                      CustomIconContainer(
                          path:  'assets/icons/red_delete_icon.svg'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Encore Films',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              // Fields in Column with Pair-wise Rows
              _buildFieldPair(
                leftLabel: 'Primary Contact Person',
                leftValue: "contact person",
                rightLabel: 'Primary Email',
                rightValue: 'email',
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
                          image: AssetImage('assets/icons/singapore_flag.png'),
                          // image: NetworkImage(consultancy['flag']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 2),

                    // const SizedBox(width: 4),
                    Text(
                      'Singapore',
                      style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                rightLabel: 'Primary Contact No',
                rightValue: 'contact number',
              ),
              const SizedBox(height: 16),

              // Primary Contact No and Fee Structure
              _buildFieldPair(
                leftLabel: 'Consultants',
                leftValue: '10',
                rightLabel: '',
                rightValue: "",
              ),
              const SizedBox(height: 16),

              // License Expiry & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agreement Expiry & Status Details',
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.black
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       '12 / 08 / 2024  10 : 12 : 34 AM',
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff1D212D)
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              // 'Active'
                              // ?
                              const Color(0xFFEBF9F1),
                              // : const Color(0xFFFBE7E8),
                          borderRadius:
                          BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color:
                              // consultancy['consultancy_status'] ==
                              //     'Active'
                              //     ?
                              const Color(
                                  0xFF1F9254)
                                  // : const Color(
                                  // 0xFFF5230C),
                            ),
                            const SizedBox(width: 4),
                            Text(
                             "Active",
                              style: GoogleFonts
                                  .spaceGrotesk(
                                color:
                                // consultancy['consultancy_status']==
                                //     'Active'
                                //     ?
                                const Color(

                                    0xFF1F9254),
                                    // : const Color(
                                    // 0xFFF5230C),
                                fontWeight:
                                FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  color: const Color(0xff1D212D)
              ),
            ),
      ],
    );
  }
}