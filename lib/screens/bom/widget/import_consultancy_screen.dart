import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/screens/bom/bom_add_consultancy_screen.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';

class ImportConsultancyScreen extends StatefulWidget {
  const ImportConsultancyScreen({super.key, required this.fromImport});

  final bool fromImport;
  @override
  State<ImportConsultancyScreen> createState() =>
      _ImportConsultancyScreenState();
}

class _ImportConsultancyScreenState extends State<ImportConsultancyScreen> {
  File? selectedFile;
  final Color primaryRed = const Color(0xFFFF1901);
  final TextEditingController _consultancyNameController =
      TextEditingController(text: 'New Consultancy');
  final TextEditingController _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _consultancyNameController.addListener(_updateFileName);
  }

  @override
  void dispose() {
    _consultancyNameController.dispose();
    _fileNameController.dispose();
    super.dispose();
  }

  void _updateFileName() {
    if (selectedFile != null) {
      final extension = selectedFile!.path.split('.').last;
      _fileNameController.text =
          '${_consultancyNameController.text}.$extension';
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx', 'csv', 'docx', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          selectedFile = File(result.files.single.path!);
          _updateFileName();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  void _uploadFile() {
    if (selectedFile != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File uploaded successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.fromImport ? 'Import' : 'Export'} Consultancy List',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFF1901),
                ),
              ),
              GestureDetector(
                child: Image.asset('assets/icons/close.png', height: 25),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 15),
          CustomTextField(
            hintText: 'Consultancy Name *',
            label: 'Consultancy Name *',
            controller: _consultancyNameController,
            borderRadius: 8,
          ),
          const SizedBox(height: 10),
          Text(
            widget.fromImport ? 'Import :' : 'Export :',
            style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xff1D212D)),
          ),
          const SizedBox(height: 10),
          DottedBorder(
            dashPattern: const [6, 4],
            color: const Color(0xffA8B9CA),
            borderType: BorderType.RRect,
            radius: const Radius.circular(8),
            child: InkWell(
              onTap: _pickDocument,
              child: Container(
                height: 130,
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/import_icon.svg',
                        height: 20, width: 20),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Browse',
                            style: GoogleFonts.lato(
                              color: const Color(0xFFFF1901),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: ' to choose file',
                            style: GoogleFonts.lato(
                              color: const Color(0xFF5D6C87),
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '(500 × 500 Max recommended, up to 2 MB each)',
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        color: const Color(0xff798AA3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // if (selectedFile != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xffA8B9CA)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedFile != null
                        ? selectedFile!.path.split('/').last
                        : 'file-name .dox',
                    style: GoogleFonts.montserrat(
                        color: const Color(0xffA8B9CA),
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    selectedFile = null;
                    _fileNameController.clear();
                  }),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      context.pop();
                    },
                    width: 150,
                    isOutlined: true),
                CustomButton(
                  text: 'Upload',
                  onPressed: () {
                    context.pop();
                  },
                  width: 150,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
