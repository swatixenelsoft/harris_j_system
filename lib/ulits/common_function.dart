import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:harris_j_system/ulits/toast_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonFunction {
  Future<String?> selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();

    // Prevent selecting today's date by starting from tomorrow.
    final DateTime firstSelectableDate =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    // Set a last selectable date (adjust as needed)
    final DateTime lastSelectableDate =
        DateTime(now.year + 1, now.month, now.day);

    // Show date range picker with a custom theme (if needed)
    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: firstSelectableDate,
        end: firstSelectableDate.add(const Duration(days: 1)),
      ),
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
    );

    if (pickedRange != null) {
      return '${DateFormat('dd / MM / yyyy').format(pickedRange.start)} - ${DateFormat('dd / MM / yyyy').format(pickedRange.end)}';
    }
    return null;
  }

  Future<String?> selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime now = DateTime.now();
    final DateTime lastSelectableDate = DateTime(2050);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: lastSelectableDate,
    );

    if (pickedDate != null) {
      final formattedDate =
          DateFormat('dd/MM/yyyy').format(pickedDate.toLocal());
      controller.text = formattedDate;
      return formattedDate;
    } else {
      return null;
    }
  }

  List<DateTime> getDaysInMonth(DateTime month) {
    int firstWeekday = DateTime(month.year, month.month, 1).weekday;
    int daysInMonth = DateTime(month.year, month.month + 1, 0).day;

    List<DateTime> days = [];
    for (int i = 1 - (firstWeekday - 1); i <= daysInMonth; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    return days;
  }

  Future<PlatformFile?> pickFileOrCapture(BuildContext context) async {
    final String? choice = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select Source"),
          content: const Text("Choose from Camera or File Manager"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, "camera"),
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, "file"),
              child: const Text("File Manager"),
            ),
          ],
        );
      },
    );

    if (choice == null) return null;

    // If the user chose "Camera", use image_picker.
    if (choice == "camera") {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        XFile file = XFile(pickedFile.path);
        int size = await file.length();

        // Check if file size exceeds 1MB.
        if (size > 1024 * 1024) {
          // Compress the image.
          final Directory tempDir = await getTemporaryDirectory();
          final String targetPath =
              '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}${pickedFile.name}';

          // You can adjust the quality parameter (0-100)
          final XFile? compressedFile =
              await FlutterImageCompress.compressAndGetFile(
            pickedFile.path,
            targetPath,
            quality: 80,
          );

          if (compressedFile != null) {
            // Update file and size after compression.
            file = compressedFile;
            size = await file.length();

            // Optionally check again if the size is still too high.
            if (size > 1024 * 1024) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("Compressed file size still exceeds 1MB.")),
              );
              return null;
            }
          } else {
            // Compression failed.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Image compression failed.")),
            );
            return null;
          }
        }

        return PlatformFile(
          name: pickedFile.name,
          size: size,
          path: file.path,
        );
      }
      return null;
    }
    // If the user chose "File Manager", use file_picker.
    else if (choice == "file") {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
      );
      if (result != null) {
        final PlatformFile file = result.files.first;
        // For file manager, compress only if it's an image.
        if (['png', 'jpg', 'jpeg'].contains(file.extension?.toLowerCase())) {
          if (file.size > 1024 * 1024 && file.path != null) {
            final Directory tempDir = await getTemporaryDirectory();
            final String targetPath =
                '${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}_${file.name}';

            final XFile? compressedFile =
                await FlutterImageCompress.compressAndGetFile(
              file.path!,
              targetPath,
              quality: 80,
            );
            if (compressedFile != null) {
              final int newSize = await compressedFile.length();
              if (newSize > 1024 * 1024) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text("Compressed file size still exceeds 1MB.")),
                );
                return null;
              }
              return PlatformFile(
                name: file.name,
                size: newSize,
                path: compressedFile.path,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image compression failed.")),
              );
              return null;
            }
          }
        }
        // For PDFs or images below 1MB, just return the file.
        return file;
      }
      return null;
    }
    return null;
  }

  Future<void> storeCustomerData(
      {int? userId, int? roleId, String? token}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId ?? 0);
    await prefs.setInt('roleId', roleId ?? 0);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('token', token ?? '');
  }

  void showPopupBelowWidget({
    required BuildContext context,
    required GlobalKey targetKey,
    required Widget popupWidget,
    double offsetY = 10.0,
    double? leftPercent, // Optional, e.g., 0.40 for 40% screen width
  }) {
    final renderBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final double leftPosition =
        leftPercent != null ? screenWidth * leftPercent : position.dx;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              overlayEntry.remove();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: leftPosition,
            top: position.dy + size.height + offsetY,
            child: popupWidget,
          ),
        ],
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  String getCurrentTimeFormatted() {
    final now = DateTime.now();
    final formatter = DateFormat('hh:mm a'); // 12-hour format with AM/PM
    return formatter.format(now); // e.g., "10:25 AM"
  }

  Future<void> downloadAndOpenPdf(String url, String fileName) async {
    try {
      // if (Platform.isAndroid) {
      //   var status = await Permission.manageExternalStorage.request();
      //   if (!status.isGranted) {
      //     print("Permission denied");
      //     return;
      //   }
      // }

      final downloadsDir = Directory('/storage/emulated/0/Download');
      final filePath = '${downloadsDir.path}/$fileName';

      final dio = Dio();
      await dio.download(url, filePath);

      print('Downloaded to $filePath');

      final result = await OpenFilex.open(filePath);
      print('Open result: ${result.message}');
    } catch (e) {
      print('Error downloading/opening PDF: $e');
    }
  }

  String formatDate(String isoDate) {
    try {
      DateTime parsedDate = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }
}
