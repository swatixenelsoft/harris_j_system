import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../widgets/custom_app_bar.dart';

class consultancyFeedbackScreen extends StatelessWidget {
  const consultancyFeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: const CustomAppBar(showBackButton: false,image: 'assets/icons/cons_logo.png'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                GestureDetector(
                onTap: () {
      Navigator.pop(context); // Navigates back to the previous screen
      },
        child: SvgPicture.asset(
          'assets/icons/back.svg',
          height: 16,
        ),
      ),
      const SizedBox(width: 60),
      const Text(
        'Feedback to Harris J.',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Send your feedback',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            const TextField(
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Say something...',

              ),
              style: TextStyle(fontSize: 13, color: Color.fromRGBO(90, 90, 90, 0.8),),
            ),
            const SizedBox(height: 100),
            const Text(
              'Disclaimer: Your feedback will be shared directly to Harris J. System to enhance the product. Please avoid including personal or sensitive information.',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromRGBO(90, 90, 90, 0.8),
                fontFamily:'montserrat',
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 124, // Reduced width
                height: 40, // Reduced height
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF1901),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8), // Adjusted padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(width: 1, color: Color(0xFFFF1901)),
                    ),
                  ),
                  onPressed: () {
                    // Handle submit action
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 12,fontFamily: 'montserrat',fontWeight: FontWeight.w600), // Slightly reduced font size
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
