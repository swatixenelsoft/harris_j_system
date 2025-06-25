import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AttachmentsDialog extends StatelessWidget {
  const AttachmentsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              children: [
                // 🔴 Header with icon before title
                buildTopHeader('Attachments', () {
                  Navigator.of(context).pop();
                }),

                // 📄 Attachment list
                Expanded(
                  child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.black12),
                          ),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/attachment_icon.svg', // Your icon
                              width: 20,
                              height: 20,

                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Attachment ${index + 1}',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔺 Reusable top header widget
  Widget buildTopHeader(String title, VoidCallback onClose) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFF1901),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            const SizedBox(width: 10),
            // 📎 Attachment icon before title
            SvgPicture.asset(
              'assets/icons/attach.svg', // Update this path
              width: 20,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),

            // Title text
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // ❌ Close icon
            GestureDetector(
              onTap: onClose,
              child: SvgPicture.asset(
                'assets/icons/closee.svg', // Your close icon
                height: 28,
                width: 28,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
