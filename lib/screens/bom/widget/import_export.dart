import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:harris_j_system/screens/bom/widget/import_consultancy_screen.dart';

void _showBlurBottomSheet(BuildContext context, Widget child) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: '',
    barrierColor: Colors.transparent,
    pageBuilder: (_, __, ___) {
      return Stack(
        children: [
          // Blurred background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

class ImportExportMenu extends StatelessWidget {
  final VoidCallback onClose;

  const ImportExportMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 4,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuItem(
              label: 'Import',
              iconPath: 'assets/icons/import.svg',
              onTap: () {
                onClose();
                _showBlurBottomSheet(
                    context,
                    const ImportConsultancyScreen(
                      fromImport: true,
                    ));
              },
            ),
            MenuItem(
              label: 'Export',
              iconPath: 'assets/icons/export.svg',
              onTap: () {
                onClose();
                _showBlurBottomSheet(
                    context,
                    const ImportConsultancyScreen(
                      fromImport: false,
                    ));
              },
            ),
            MenuItem(
              label: 'Download Template',
              iconPath: 'assets/icons/download_icon.svg',
              onTap: () {
                onClose();
                print('Download Template tapped');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String label;
  final String iconPath;
  final VoidCallback onTap;

  const MenuItem({
    super.key,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
