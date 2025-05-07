import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastHelper {
  static void showSuccess(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      containerColor:Colors.green.shade100,
      duration: const Duration(seconds: 2),
    );
  }

  static void showError(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.error,
      iconColor: Colors.red,
      containerColor:Colors.red.shade100,
      duration: const Duration(seconds: 4),
    );
  }

  static void showInfo(BuildContext context, String message) {
    _showCustomToast(
      context,
      message,
      icon: Icons.info,
      iconColor: Colors.blue,
      containerColor:Colors.blue.shade100,
      duration: const Duration(seconds: 3),
    );
  }

  static void _showCustomToast(
      BuildContext context,
      String message, {
        required IconData icon,
        required Color iconColor,
        required Color containerColor,
        required Duration duration,

      }) {
    DelightToastBar(
      builder: (context) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: iconColor, size: 20), // Smaller icon
              const SizedBox(width: 6), // Reduced spacing
              Flexible(
                child: Text(
                  message,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      position: DelightSnackbarPosition.bottom,
      autoDismiss: true,
      snackbarDuration: duration,
    ).show(context);
  }
}
