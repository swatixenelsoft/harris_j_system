import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class InvoicePreview extends StatelessWidget {
  const InvoicePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return    Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/icons/cons_logo.png',
                height: 30,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Invoice',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Date: 01-04-2025',
                style: GoogleFonts.montserrat(fontSize: 12),
              ),
              Text(
                'Due Date: 01-04-2025',
                style: GoogleFonts.montserrat(fontSize: 12),
              ),
              Text(
                'Invoice#: #EM098789',
                style: GoogleFonts.montserrat(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                        fontSize: 14,
                        color: Color(0xff007BFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text( //
                      'Encore Films',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                      style: GoogleFonts.montserrat(fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bill To:',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Color(0xff28A745),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Encore Films',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'No.22,Abcd Street,RR Nager,\nChennai-600016,Tamil Nadu,India\nX5JX+HX Chennai, Tamil Nadu',
                      style: GoogleFonts.montserrat(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              // Header Row (no shade, with bottom line)
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Name',
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Service Fee',
                        style: GoogleFonts.montserrat(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),

              // Data Rows with underline
              for (int i = 0; i < 5; i++)
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Resource 1',
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '\$100',
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),
          Column(
            children: [
              // Labels in one line
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Total Amount',
                      style: GoogleFonts.montserrat(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Tax %',
                      style: GoogleFonts.montserrat(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Total',
                      style: GoogleFonts.montserrat(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Divider(height: 32, color: Colors.grey),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '\$500',
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '4%',
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '\$540',
                      style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total Billing Amt.',
                  style: GoogleFonts.montserrat(color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$540',
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Auto generated by the system',
            style: GoogleFonts.spaceGrotesk(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}