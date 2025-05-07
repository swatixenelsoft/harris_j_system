import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/widgets/custom_button.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String? itemName;

  const DeleteConfirmationDialog({
    super.key,
    required this.onConfirm,
    this.itemName = 'user',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        width: 380,
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Custom Trash Icon in a square box
            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: const Color(0XFFF2F2F2),
                borderRadius: BorderRadius.circular(8),

              ),
              child: SvgPicture.asset(
                'assets/icons/red_delete_icon.svg',
                width: 20,
                height: 20,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Are you sure you want to delete this $itemName?',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              color: const Color(0xff54595E)
              ),
              textAlign: TextAlign.center,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'This action cannot be undone. The $itemName\'s data will be permanently removed.',
                style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(84, 89, 94, 0.6)
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // No, cancel button with red border
                  CustomButton(text: 'No, cancel', onPressed: (){ Navigator.pop(context);},isOutlined: true,height: 32),
                  const SizedBox(height: 10), // Space between buttons
                  // Yes, confirm button with red background
                  CustomButton(text: 'Yes, confirm', onPressed: (){
                    Navigator.pop(context);
                    onConfirm();
                  },
                      height: 32
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
    String? itemName,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: onConfirm,
        itemName: itemName,
      ),
    );
  }
}
