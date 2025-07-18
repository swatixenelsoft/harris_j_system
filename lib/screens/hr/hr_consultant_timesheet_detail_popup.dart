import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:intl/intl.dart';

class HrConsultantTimesheetDetailPopup extends StatelessWidget {
  final Map<String, dynamic> consultant;
  final VoidCallback onDelete; // Callback to notify parent of deletion
  final bool isFromClaims;
  const HrConsultantTimesheetDetailPopup(
      {super.key,
      required this.consultant,
      required this.onDelete,
      required this.isFromClaims});

  @override
  Widget build(BuildContext context) {
    print('consultant12 $consultant');
    return Container(
      padding: const EdgeInsets.all(16.0),
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
                child:  CircleAvatar(
                  backgroundImage:  (consultant['consultant_info']['profile_image'] != null && consultant['consultant_info']['profile_image'].toString().isNotEmpty)
                      ? NetworkImage(consultant['consultant_info']['profile_image'])
                      : AssetImage('assets/images/profile.jpg') as ImageProvider,
                  radius: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    consultant['consultant_info']['emp_name'] ?? 'N/A',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff2A282F),
                    ),
                  ),
                  Text(
                   'Employee Id: ${consultant['consultant_info']['emp_code'] ?? ""}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xffA8A6AC),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      // 'Active'
                      // ?
                      const Color(0xFFEBF9F1),
                  // : const Color(0xFFFBE7E8),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: consultant['consultant_info']['status'] == 'Active'
                          ? const Color(0xFF1F9254)
                          : consultant['consultant_info']['status'] ==
                                  'Notice Period'
                              ? const Color(0xff8D91A0)
                              : const Color(0xFFF5230C),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      consultant['consultant_info']['status'],
                      style: GoogleFonts.spaceGrotesk(
                        color:
                            consultant['consultant_info']['status'] == 'Active'
                                ? const Color(0xFF1F9254)
                                : consultant['consultant_info']['status'] ==
                                        'Notice Period'
                                    ? const Color(0xff8D91A0)
                                    : const Color(0xFFF5230C),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Color(0xffD9D9D9),
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/company_icon.svg'),
                  SizedBox(width: 5),
                  Text(
                    consultant['consultant_info']['client_name'] ?? 'N/A',
                    style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.montserrat(
                    color: const Color(0xffD1D1D6),
                    fontSize: 10,
                  ),
                  children: [
                    TextSpan(
                        text: 'Joining Date : \n',
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff037EFF))), // Reduce space
                    TextSpan(
                        text: consultant['consultant_info']['joining_date']??"",
                        style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)), // Reduce space
                    // Reduce space further
                  ],
                ),
              ),
            ],
          ),

          Text(
            consultant['consultant_info']['designation']??'',
            style: GoogleFonts.montserrat(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: const Color(0xff037EFF)),
          ),
          const Divider(
            color: Color(0xffD9D9D9),
            thickness: 1,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 150, 27, 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/icons/phone_icon.svg')),
                  const SizedBox(width: 6),
                  Text(
                    '${consultant['consultant_info']['mobile_number_code']??''} ${consultant['consultant_info']['mobile_number']??''}',
                    style: GoogleFonts.spaceGrotesk(
                        fontSize: 12, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(255, 150, 27, 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/icons/mail_icon.svg')),
                  const SizedBox(width: 6),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      consultant['consultant_info']['email']??'',
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 150, 27, 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xffFF1901),
                  size: 15,
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  consultant['consultant_info']['show_address_input']??'',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true, // This is optional; true by default
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(255, 150, 27, 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                    child: SvgPicture.asset(
                  'assets/icons/google_code.svg',
                  height: 10,
                  width: 10,
                  color: const Color(0xffFF1901),
                )),
              ),
              const SizedBox(width: 6),
              Text(
                consultant['consultant_info']['plus_code'] ??'' ,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 12, fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Color(0xffD9D9D9),
            thickness: 1,
          ),
          if (!isFromClaims) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Queue',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black),
                ),
                Text(
                  'Hours Logged',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black),
                ),
                Text(
                  'Logged Time Off',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0xff007BFF),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  '${consultant['work_log']['logged_hours']}/${consultant['work_log']['forecasted_hours']}',
                  style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1D212D)),
                ),
                Text(
                  '5/2/2',
                  style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1D212D)),
                ),
              ],
            ),
            const Divider(
              color: Color(0xffD9D9D9),
              thickness: 1,
            ),
          ],

          if (isFromClaims) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60, // Make all widths equal or as needed
                  child: Text(
                    'Queue',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Submitted',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Claim No',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration: const BoxDecoration(
                        color: Color(0xff007BFF),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    '12/08/2024',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1D212D),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Cl09892F12',
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff1D212D),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Color(0xffD9D9D9),
              thickness: 1,
            ),
          ],

          const SizedBox(height: 10),

          // Fields in Column with Pair-wise Rows
          if (!isFromClaims) ...[
            _buildFieldPair(
              leftLabel: 'AL Overview',
              leftValue: consultant['work_log']['leave_summary']['AL'],
              rightLabel: 'ML Overview',
              rightValue: consultant['work_log']['leave_summary']['ML'],
            ),
            const SizedBox(height: 16),

            // Country and Primary Email
            _buildFieldPair(
              leftLabel: 'PDO Overview',
              leftValue: consultant['work_log']['leave_summary']['PDO'],
              rightLabel: 'UL Overview',
              rightValue: consultant['work_log']['leave_summary']['UL'],
            ),
          ],

          if (isFromClaims)
            _buildFieldPair(
              leftLabel: 'Number of claims',
              leftValue: "03",
              rightLabel: 'Total Amounts',
              rightValue: '\$800.00',
            ),
        ],
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
