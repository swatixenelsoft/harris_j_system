import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_consultancy_screen.dart';
import 'package:harris_j_system/ulits/custom_icon_container.dart';
import 'package:intl/intl.dart';


class HrConsultantDetailPopup extends StatelessWidget {
  final Map<String,dynamic> consultant;
  final VoidCallback onDelete; // Callback to notify parent of deletion

  const HrConsultantDetailPopup({super.key, required this.consultant, required this.onDelete});

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
          constraints: const BoxConstraints(maxHeight: 600),
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
                      backgroundImage: AssetImage(
                          'assets/images/profile.jpg'),
                      radius: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        consultant['name']??'Bruce Lee',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff2A282F),
                        ),
                      ),  Text(
                        'Employee Code : Emp14982 ',
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
                leftValue: "Specialty@gmail.com",
                rightLabel: 'Gender',
                rightValue: 'Male',
              ),
              const SizedBox(height: 16),

              // Country and Primary Email
              _buildFieldPair(
                leftLabel: 'Date Of Birth',
                leftValue: '12 / 08 / 1996',
                rightLabel: 'Age',
                rightValue: '27',
              ),
              const SizedBox(height: 16),

              // Primary Contact No and Fee Structure
              _buildFieldPair(
                leftLabel: 'Mobile Number',
                leftValue: '+65 87879809',
                rightLabel: 'Whatsapp Number',
                rightValue: "+65 87879809",
              ),
              const SizedBox(height: 16),  _buildFieldPair(
                leftLabel: 'Joining Date',
                leftValue: '12 / 08 / 2024',
                rightLabel: 'Last Working Date',
                rightValue: "12 / 08 / 2026",
              ),
              const SizedBox(height: 16),  _buildFieldPair(
                leftLabel: 'Designation',
                leftWidget: Container(
                  padding:
                  const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4),
                  decoration: BoxDecoration(
                    color:
                    // 'Active'
                    // ?
                    const Color(0xFFE5F1FF),
                    // : const Color(0xFFFBE7E8),
                    borderRadius:
                    BorderRadius.circular(6),
                  ),
                  child:        Text(
                    "Consultant",
                    style: GoogleFonts
                        .spaceGrotesk(
                      color:
                      // consultancy['consultancy_status']==
                      //     'Active'
                      //     ?
                      const Color(

                          0xFF037EFF),
                      // : const Color(
                      // 0xFFF5230C),
                      fontWeight:
                      FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                rightLabel: 'Contract Period',
                rightValue: "2 Years",
              ),
              const SizedBox(height: 16),
              _buildFieldPair(
                leftLabel: 'Designation',
           leftWidget: Container(
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
                 const Icon(
                     Icons.circle,
                     size: 8,
                     color:
                     // consultancy['consultancy_status'] ==
                     //     'Active'
                     //     ?
                     Color(0xFF1F9254)
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
                rightLabel: '',
                rightValue: "",
              ),

              const SizedBox(height: 16),
              // License Expiry & Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Last Activity',
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
                          const Color(0xFFE5F1FF),
                          // : const Color(0xFFFBE7E8),
                          borderRadius:
                          BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                                Icons.circle,
                                size: 8,
                                color:
                                // consultancy['consultancy_status'] ==
                                //     'Active'
                                //     ?
                                Color(0xFF037EFF)
                              // : const Color(
                              // 0xFFF5230C),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Online",
                              style: GoogleFonts
                                  .spaceGrotesk(
                                color:
                                // consultancy['consultancy_status']==
                                //     'Active'
                                //     ?
                                const Color(

                                    0xFF037EFF),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff1D212D)
              ),
            ),
      ],
    );
  }
}