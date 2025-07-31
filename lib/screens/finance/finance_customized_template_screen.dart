import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

// Dialog content widget
class CustomizeTemplateDialog extends StatelessWidget {
  const CustomizeTemplateDialog({super.key});

  @override
  Widget build(BuildContext context) {
// Get screen dimensions using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      alignment: Alignment.bottomCenter, // Align dialog to bottom of screen
      insetPadding: const EdgeInsets.all(0), // Edge-to-edge (left to right)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Curved top corners
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9, // Limit height to 90% of screen height
          minWidth: screenWidth, // Full width
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, // Minimum height for dialog
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch content horizontally
              children: [
                // Header with curved top corners
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color(
                        0xFFFF1901), // Same red color as ScheduleInvoiceDialog
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16), // Curved top corners
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Space between title and close icon
                      children: [
                        Text(
                          'Customize Template',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: SvgPicture.asset(
                            'assets/icons/closee.svg', // Use the same close icon
                            height: 28,
                            width: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    // Scrollable view to prevent overflow

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// Title
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                0.04, // 4% of screen width for horizontal padding
                         vertical: 5
                          ),
                          child: Text(
                            'Choose Invoice Template',
                            style: GoogleFonts.montserrat(
                              fontSize:
                                  12, // Responsive font size (4% of screen width)
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
// Template Labels in One Line
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                0.04, // 4% of screen width for horizontal padding
                          ),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 6, // Responsive radius
                                    backgroundColor: Color(0xff5A5A5A),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    'Template 1',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              SizedBox(width: screenWidth * 0.23),
                              Row(
                                children: [
                                  const CircleAvatar(
                                    radius: 6, // Responsive radius
                                    backgroundColor: Color(0xff5A5A5A),
                                  ),
                                  SizedBox(width: screenWidth * 0.02),
                                  Text(
                                    'Template 2',
                                    style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
// Templates Row
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth *
                                0.04, // 4% of screen width for horizontal padding

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                          // Template 1
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop('Template1');
                                  },
                                  child: InvoicePreview(
                                    templateType: 'Template1',
                                    date:
                                        'Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                    dueDate:
                                        'Due Date: ${DateTime.now().month == 12 ? 1 : DateTime.now().month + 1}-${DateTime.now().year}',
                                    invoiceNumber: 'Invoice#: #EM098789',
                                    billFrom: 'Harris J System',
                                    billFromAddress:
                                        'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                    billFromCode:'X5JX+HX Chennai, Tamil Nadu',
                                    billTo: 'Encore Films',
                                    billToAddress:
                                        'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                    billToCode:'X5JX+HX Chennai, Tamil Nadu',
                                    totalAmount: '\$500',
                                    taxPercent: '4%',
                                    total: '\$520',
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.04),
                          // Template 2
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop('Template2');
                                  },
                                  child: InvoicePreview(
                                    templateType: 'Template2',
                                    date:
                                        'Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                    dueDate:
                                        'Due Date: ${DateTime.now().month == 12 ? 1 : DateTime.now().month + 1}-${DateTime.now().year}',
                                    invoiceNumber: 'Invoice#: #EM098790',
                                    billFrom: 'Harris J System',
                                    billFromAddress:
                                    'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                    billFromCode:'X5JX+HX Chennai, Tamil Nadu',
                                    billTo: 'Encore Films',
                                    billToAddress:
                                    'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                    billToCode:'X5JX+HX Chennai, Tamil Nadu',
                                    totalAmount: '\$800',
                                    taxPercent: '4%',
                                    total: '\$832',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          color: const Color(0xffF1F4F6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Invoice Template',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xffFF1901)
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              RichText(
                                text: TextSpan(
                                  text: 'Contact ',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: screenWidth * 0.027,
                                    color: const Color(0xff5D6C87),
                                    fontWeight: FontWeight.w500                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'harrisjs.info@harrrisjs.com',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: screenWidth * 0.027,
                                          color: const Color(0xff0369D7),
                                          fontWeight: FontWeight.w500                                  ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' to get more information for uploading company template',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: screenWidth * 0.027,
                                          color: const Color(0xff5D6C87),
                                          fontWeight: FontWeight.w500                                  ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xffA8B9CA)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child:Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/upload.svg',height: 20,width: 20,),
                                    const SizedBox(width: 10),
                                    Text('Upload Company Logo',style: GoogleFonts.spaceGrotesk(fontSize: 12,fontWeight: FontWeight.w500,color: const Color(0xff5D6C87)),)
                                  ],
                                )
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              RichText(
                                text: TextSpan(
                                  text: '*Allow to upload file ',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: screenWidth * 0.025,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff798AA3), // Default grey color
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'PNG,JPG',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: screenWidth * 0.025,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff037EFF), // Default grey color
                                        )
                                    ),
                                    TextSpan(
                                      text: ' (Max.file size: 1MB)',
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: screenWidth * 0.025,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff798AA3), // Default grey color
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
// Grey line at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 2, // Slightly thicker for visibility
                color: Colors.grey[400], // Slightly darker grey for prominence
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// InvoicePreview widget (updated with MediaQuery for responsiveness and divider)
class InvoicePreview extends StatelessWidget {
  final String templateType;
  final String date;
  final String dueDate;
  final String invoiceNumber;
  final String billFrom;
  final String billFromAddress;
  final String billFromCode;
  final String billTo;
  final String billToAddress;
  final String billToCode;
  final String totalAmount;
  final String taxPercent;
  final String total;

  const InvoicePreview({
    super.key,
    required this.templateType,
    required this.date,
    required this.dueDate,
    required this.invoiceNumber,
    required this.billFrom,
    required this.billFromAddress,
    required this.billFromCode,
    required this.billTo,
    required this.billToAddress,
    required this.billToCode,
    required this.totalAmount,
    required this.taxPercent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      height: 290,
      padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 2.5, // Responsive radius
                backgroundColor: Color(0xffFF1901),
              ),
              const SizedBox(width: 2),
              Text(
                'Invoice Preview',
                style: GoogleFonts.montserrat(
                    fontSize: 5,
                    color: const Color(0xffFF1901),
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              )
            ],
          ),
          SizedBox(height: screenWidth*0.01),
          templateType == 'Template1'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/bom/bom_logo.png',
                    height: 10, // Responsive logo height
                  ),

                  Text(
                    'Invoice',
                    style: GoogleFonts.montserrat(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenWidth*0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.01),
                      ),
                      Text(
                        dueDate,
                        style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.01),
                      ),
                      Text(
                        invoiceNumber,
                        style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.01),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth*0.01),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bill From:',
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.015,
                                  color: const Color(0xff007BFF),
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.005),
                              Text(
                                billFrom,
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.0125),
                              Text(
                                billFromAddress,
                                style: GoogleFonts.montserrat(
                                    fontSize: screenWidth * 0.018),
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              Text(
                                billFromCode,
                                style: GoogleFonts.montserrat(
                                    fontSize: screenWidth * 0.018),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.025),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bill To:',
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.015,
                                  color: const Color(0xff28A745),
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.005),
                              Text(
                                billTo,
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: screenWidth * 0.0125),
                              Text(
                                billToAddress,
                                style: GoogleFonts.montserrat(
                                    fontSize: screenWidth * 0.018),
                              ),
                              SizedBox(height: screenWidth * 0.01),
                              Text(
                                billToCode,
                                style: GoogleFonts.montserrat(
                                    fontSize: screenWidth * 0.018),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
// Bill From section (yellow background for entire section)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          'assets/images/bom/bom_logo.png',
                          height: 10, // Responsive logo height
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              date,
                              style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.01),
                            ),
                            Text(
                              dueDate,
                              style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.01),
                            ),
                            Text(
                              invoiceNumber,
                              style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.01),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Added "Simple Invoice" at the top
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        'Invoice',
                        style: GoogleFonts.montserrat(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: screenWidth*0.03),
                    Container(
                      width: double.infinity, // Ensure full row width
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.015,
                        horizontal: screenWidth * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 150, 27,
                            0.3), // Highlight entire Bill From section in yellow
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill From:',
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.015,
                              color: const Color(0xff007BFF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                billFrom,
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Location Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/location_marker.svg',
                                            height: 5,
                                            width: 5,
                                            color: const Color(0xffFF1901),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            billFromAddress,
                                            style: GoogleFonts.montserrat(
                                              fontSize: screenWidth * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Google Code Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/google_code.svg',
                                            height: 5,
                                            width: 5,
                                            color: const Color(0xffFF1901),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            billFromCode,
                                            style: GoogleFonts.montserrat(
                                              fontSize: screenWidth * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.02),
// Bill To section (grey background for entire section)
                    Container(
                      width: double.infinity, // Ensure full row width
                      padding: EdgeInsets.symmetric(
                        vertical: screenWidth * 0.015,
                        horizontal: screenWidth * 0.015,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey
                            .shade200, // Highlight entire Bill From section in yellow
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bill To:',
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.015,
                              color: const Color(0xff1F9254),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                billTo,
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.02,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Location Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/location_marker.svg',
                                            height: 5,
                                            width: 5,
                                            color: const Color(0xffFF1901),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            billToAddress,
                                            style: GoogleFonts.montserrat(
                                              fontSize: screenWidth * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // Google Code Row
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 10,
                                          height: 10,
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/google_code.svg',
                                            height: 5,
                                            width: 5,
                                            color: const Color(0xffFF1901),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Expanded(
                                          child: Text(
                                            billToCode,
                                            style: GoogleFonts.montserrat(
                                              fontSize: screenWidth * 0.015,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          SizedBox(height: screenWidth * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.015,
                    color: const Color(0xffA7A7A7),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Tax %',
                style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.015,
                    color: const Color(0xffA7A7A7),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                'Total',
                style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.015,
                    color: const Color(0xffA7A7A7),
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Divider(
            color: Color(0xffE1E1E1), // Match the grey line at dialog bottom
            height: 1, // Thin divider
            // indent: screenWidth * 0.001, // Small indent for alignment
            // endIndent: screenWidth * 0.001,
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalAmount,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: screenWidth * 0.02, fontWeight: FontWeight.w600),
              ),
              Text(
                taxPercent,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: screenWidth * 0.02, fontWeight: FontWeight.w600),
              ),
              Text(
                total,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: screenWidth * 0.02, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Divider(
            color: Color(0xffE1E1E1), // Match the grey line at dialog bottom
            height: 1, // Thin divider
            // indent: screenWidth * 0.001, // Small indent for alignment
            // endIndent: screenWidth * 0.001,
          ),

          const SizedBox(height: 5),
          Align(
            alignment: Alignment.topRight,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Total Billing Amt.',
                style: GoogleFonts.montserrat(
                    fontSize: screenWidth * 0.015,
                    color: const Color(0xffA7A7A7),
                    fontWeight: FontWeight.w500),
              ),
              Text(
                total,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: screenWidth * 0.02, fontWeight: FontWeight.w600),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
