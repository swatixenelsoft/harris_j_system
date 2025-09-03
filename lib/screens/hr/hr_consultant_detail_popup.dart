import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/ulits/common_function.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:intl/intl.dart';

class HrConsultantDetailPopup extends StatelessWidget {
  final Map<String, dynamic> consultant;
  final VoidCallback onEdit;

  const HrConsultantDetailPopup(
      {super.key, required this.consultant,required this.onEdit});

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
          // constraints: const BoxConstraints(maxHeight: 630),
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
                    'Consultant Information',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          onEdit();
                        },
                        child: const CustomIconContainer(
                            path: 'assets/icons/edit_pen.svg',
                            bgColor: Color(0xffF5230C)),
                      ),

                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xffFF8403),
                        width: 2,
                      ),
                    ),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consultant['emp_name'] ?? 'N/A',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2A282F),
                        ),
                      ),
                      Text(
                        'Employee Code : ${consultant['emp_code']}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xffA8A6AC),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Fields in Column with Pair-wise Rows
              _buildFieldPair(
                leftLabel: 'Email ID',
                leftValue: consultant['email'],
                rightLabel: 'Gender',
                rightValue: consultant['sex'],
              ),
              const SizedBox(height: 16),

              // Primary Contact No and Fee Structure
              _buildFieldPair(
                leftLabel: 'Mobile Number',
                leftValue:
                    "${consultant['mobile_number_code']} ${consultant['mobile_number']}",
                rightLabel: 'Whatsapp Number',
                rightValue:
                    "${consultant['mobile_number_code']} ${consultant['mobile_number']}",
              ),



              const SizedBox(height: 16),
              _buildFieldPair(
                leftLabel: 'Designation',
                leftWidget: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        // 'Active'
                        // ?
                        const Color(0xFFE5F1FF),
                    // : const Color(0xFFFBE7E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    consultant['designation'],
                    style: GoogleFonts.spaceGrotesk(
                      color:
                          // consultancy['consultancy_status']==
                          //     'Active'
                          //     ?
                          const Color(0xFF037EFF),
                      // : const Color(
                      // 0xFFF5230C),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                rightLabel: 'Contract Period',
                rightValue: consultant['contract_period'] ?? "N/A",
              ),
              const SizedBox(height: 16),
              _buildFieldPair(
                leftLabel: 'Status',
                leftWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: consultant['status'] == 'Active'
                          ? const Color(0xFF1F9254)
                          : consultant['status'] == 'Notice Period'
                              ? const Color(0xff8D91A0)
                              : const Color(0xFFF5230C),
                    ),

                  ],
                ),
                rightLabel: '',
                rightValue: "",
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
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1D212D)),
            ),
      ],
    );
  }
}
