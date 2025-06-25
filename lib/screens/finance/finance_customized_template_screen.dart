
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
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Curved top corners
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: screenHeight * 0.9, // Limit height to 90% of screen height
          minWidth: screenWidth, // Full width
        ),
        decoration:  BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, // Minimum height for dialog
              crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch content horizontally
              children: [
// Header with curved top corners
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF1901), // Same red color as ScheduleInvoiceDialog
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16), // Curved top corners
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and close icon
                      children: [
                        Text(
                          'Customize Template',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                  child: SingleChildScrollView( // Scrollable view to prevent overflow
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04, // 4% of screen width for horizontal padding
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
// Title
                        Text(
                          'Choose Invoice Template',
                          style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.04, // Responsive font size (4% of screen width)
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02), // 2% of screen height
// Template Labels in One Line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: screenWidth * 0.025, // Responsive radius
                                  backgroundColor: const Color(0xff5A5A5A),
                                  child: Icon(
                                    Icons.circle,
                                    size: screenWidth * 0.025,
                                    color: const Color(0xff5A5A5A),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Template 1',
                                  style: GoogleFonts.montserrat(fontSize: screenWidth * 0.035),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: screenWidth * 0.025,
                                  backgroundColor: const Color(0xff5A5A5A),
                                  child: Icon(
                                    Icons.circle,
                                    size: screenWidth * 0.025,
                                    color: const Color(0xff5A5A5A),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  'Template 2',
                                  style: GoogleFonts.montserrat(fontSize: screenWidth * 0.035),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.01),
// Templates Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
// Template 1
                            Expanded(
                              child: InvoicePreview(
                                templateType: 'Template1',
                                date: 'Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                dueDate: 'Due Date: ${DateTime.now().month == 12 ? 1 : DateTime.now().month + 1}-${DateTime.now().year}',
                                invoiceNumber: 'Invoice#: #EM098789',
                                billFrom: 'Harris J System',
                                billFromAddress: 'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                billTo: 'Encore Films',
                                billToAddress: 'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                totalAmount: '\$500',
                                taxPercent: '4%',
                                total: '\$520',
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.04),
// Template 2
                            Expanded(
                              child: InvoicePreview(
                                templateType: 'Template2',
                                date: 'Date: ${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                dueDate: 'Due Date: ${DateTime.now().month == 12 ? 1 : DateTime.now().month + 1}-${DateTime.now().year}',
                                invoiceNumber: 'Invoice#: #EM098790',
                                billFrom: 'Harris J System',
                                billFromAddress: 'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                billTo: 'Encore Films',
                                billToAddress: 'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India',
                                totalAmount: '\$800',
                                taxPercent: '4%',
                                total: '\$832',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.03),
// Image Upload Section
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          color: const Color.fromRGBO(141, 145, 160, 0.1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upload Invoice Template',
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                'Contact harrisjs.info@harrrisjs.com to get more information for uploading company template',
                                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.03),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color.fromRGBO(168, 185, 202, 1)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Upload Company Logo',
                                    prefixIcon: SvgPicture.asset(
                                      'assets/icons/uploadd.svg',
                                      height: screenWidth * 0.04, // Responsive icon size
                                      width: screenWidth * 0.04,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(screenWidth * 0.025),
                                  ),
                                  enabled: false, // Disable text input for file upload
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              Text(
                                '*Allow to upload file PNG,JPG (Max.file size: 1MB)',
                                style: GoogleFonts.montserrat(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.grey,
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
  final String billTo;
  final String billToAddress;
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
    required this.billTo,
    required this.billToAddress,
    required this.totalAmount,
    required this.taxPercent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
// Logo and Invoice text at top-left
          Row(
            children: [
              Image.asset(
                'assets/icons/cons_logo.png',
                height: screenWidth * 0.05, // Responsive logo height
              ),
              SizedBox(width: screenWidth * 0.02),
            ],
          ),
          SizedBox(height: screenWidth * 0.02),
// Added "Simple Invoice" at the top
          Text(
            'Invoice',
            style: GoogleFonts.montserrat(
              fontSize: screenWidth * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: screenWidth * 0.01),
// Date, Due Date, and Invoice Number
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.01),
              ),
              Text(
                dueDate,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.01),
              ),
              Text(
                invoiceNumber,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.01),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.025),
// Conditional Bill From and Bill To layout based on templateType
          templateType == 'Template1'
              ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill From:',
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.02,
                        color: const Color(0xff007BFF),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.005),
                    Text(
                      billFrom,
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.0125),
                    Text(
                      billFromAddress,
                      style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
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
                        fontSize: screenWidth * 0.02,
                        color: const Color(0xff28A745),
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.005),
                    Text(
                      billTo,
                      style: GoogleFonts.montserrat(
                        fontSize: screenWidth * 0.025,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.0125),
                    Text(
                      billToAddress,
                      style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
                    ),
                  ],
                ),
              ),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
// Bill From section (yellow background for entire section)
              Container(
                color: const Color.fromRGBO(255, 150, 27, 0.3), // Highlight entire Bill From section in yellow
                width: double.infinity, // Ensure full row width
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill From: ',
                          style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.02,
                            color: const Color(0xff007BFF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            billFromAddress,
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.0175,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.005),
                    Padding(
                      padding: const EdgeInsets.only(left: 0), // Align with address
                      child: Text(
                        billFrom,
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.02),
// Bill To section (grey background for entire section)
              Container(
                color: const Color.fromRGBO(242, 242, 242, 1), // Highlight entire Bill To section in grey
                width: double.infinity, // Ensure full row width
                padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bill To:     ',
                          style: GoogleFonts.montserrat(
                            fontSize: screenWidth * 0.02,
                            color: const Color(0xff28A745),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            billToAddress,
                            style: GoogleFonts.montserrat(
                              fontSize: screenWidth * 0.02,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenWidth * 0.005),
                    Padding(
                      padding: const EdgeInsets.only(left: 0), // Align with address
                      child: Text(
                        billTo,
                        style: GoogleFonts.montserrat(
                          fontSize: screenWidth * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
              Text(
                'Tax %',
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
              Text(
                'Total',
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.0125),
          Divider(
            color: Colors.grey[400], // Match the grey line at dialog bottom
            thickness: 1, // Thin divider
            indent: screenWidth * 0.001, // Small indent for alignment
            endIndent: screenWidth * 0.001,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalAmount,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
              Text(
                taxPercent,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
              Text(
                total,
                style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
              ),
            ],
          ),
          SizedBox(height: screenWidth * 0.0125),
// Added Divider below Total Amount, Tax %, and Total
          Divider(
            color: Colors.grey[400], // Match the grey line at dialog bottom
            thickness: 1, // Thin divider
            indent: screenWidth * 0.001, // Small indent for alignment
            endIndent: screenWidth * 0.001,
          ),
          SizedBox(height: screenWidth * 0.025),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Total Billing Amt. $total',
              style: GoogleFonts.montserrat(fontSize: screenWidth * 0.02),
            ),
          ),
        ],
      ),
    );
  }
}
