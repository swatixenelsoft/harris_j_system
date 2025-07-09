import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class operatorActionPopup extends StatelessWidget {
  final Map<String, dynamic> consultant;
  final VoidCallback onDelete;
  final bool isFromClaims;

  const operatorActionPopup({
    super.key,
    required this.consultant,
    required this.onDelete,
    required this.isFromClaims,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Close button
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
                    consultant['consultant_info']['emp_name'] ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff2A282F),
                    ),
                  ),
                  Text(
                    consultant['consultant_info']['emp_code']??'',
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
                  color: const Color(0xFFEBF9F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Color(0xFF1F9254)),
                    const SizedBox(width: 4),
                    Text(
                      consultant['consultant_info']['status']??'',
                      style: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF1F9254),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xffD9D9D9), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/icons/company_icon.svg'),
                  const SizedBox(width: 5),
                  Text(
                    consultant['consultant_info']['client_name']??'',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
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
                      text: 'Joining Date: \n',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff037EFF),
                      ),
                    ),
                    TextSpan(
                      text:  consultant['consultant_info']['joining_date']??'',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            consultant['consultant_info']['emp_code']??'',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xff037EFF),
            ),
          ),
          const Divider(color: Color(0xffD9D9D9), thickness: 1),
          const SizedBox(height: 20),
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
                    child: SvgPicture.asset('assets/icons/phone_icon.svg'),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "${consultant['consultant_info']['mobile_number_code'] ?? ''} ${consultant['consultant_info']['mobile_number'] ?? ''}",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
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
                    child: SvgPicture.asset('assets/icons/mail_icon.svg'),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    consultant['consultant_info']['email']??'',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                  consultant['consultant_info']['address_by_user']??'',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                child: SvgPicture.asset(
                  'assets/icons/google_code.svg',
                  height: 10,
                  width: 10,
                  color: const Color(0xffFF1901),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'W772+M6 Chennai, Tamil Nadu',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xffD9D9D9), thickness: 1),
        ],
      ),
    );
  }
}