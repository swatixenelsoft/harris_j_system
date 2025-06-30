import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harris_j_system/providers/static_system_provider.dart';
import 'package:harris_j_system/services/api_constant.dart';
import 'package:harris_j_system/widgets/custom_button.dart';
import 'package:harris_j_system/widgets/custom_dropdown.dart';
import 'package:harris_j_system/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddBottomSheet extends ConsumerStatefulWidget {
  final String title;
  final String label;
  final String hintText;
  final List<String> tags;
  final Function(Map<String, dynamic>)? onSubmit;

  const AddBottomSheet({
    super.key,
    required this.title,
    required this.label,
    required this.hintText,
    required this.tags,
    this.onSubmit,
  });

  @override
  ConsumerState<AddBottomSheet> createState() => _AddBottomSheetState();
}

class _AddBottomSheetState extends ConsumerState<AddBottomSheet> {
  final TextEditingController _textController = TextEditingController();
  String? selectedTag;

  Future<Map<String, dynamic>> _submitForm() async {
    final prefs = await SharedPreferences.getInstance();
    final consultancyId = prefs.getInt('userId') ?? 0;
    final token = prefs.getString('token') ?? '';
    FocusScope.of(context).unfocus();

    final name = _textController.text.trim();
    final tag = selectedTag;

    try {
      final response = await ref.read(staticSettingProvider.notifier).addRole(
        widget.title == 'Add Designation'
            ? ApiConstant.addDesignation
            : ApiConstant.addRole,
        consultancyId.toString(),
        name,
        tag ?? '',
        token,
      );

      final bool success = response['success'] == true;

      if (!mounted) return {'success': false, 'message': 'Widget not mounted'};

      return response; // Always return a Map
    } catch (e) {
      return {
        'success': false,
        'message': 'Something went wrong: $e',
      };
    }
  }


  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      initialChildSize: 0.40,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: screenWidth,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF1901),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SvgPicture.asset(
                          'assets/icons/closee.svg',
                          width: 25,
                          height: 25,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Input Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomTextField(
                    label: widget.label,
                    hintText: widget.hintText,
                    controller: _textController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter ${widget.label.toLowerCase()}';
                      }
                      return null;
                    },
                    borderRadius: 8,
                  ),
                ),

                const SizedBox(height: 16),

                // Dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomDropdownField(
                    label: 'Add Tag',
                    items: widget.tags,
                    value: selectedTag,
                    onChanged: (value) {
                      print('tag_value $value');
                      setState(() {

                        selectedTag = value;
                      });
                    },
                    borderRadius: 8,
                    borderColor: 0xffE8E6EA,
                  ),
                ),

                const SizedBox(height: 45),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'Cancel',
                      width: 116,
                      isOutlined: true,
                    ),
                    const SizedBox(width: 8),
                    CustomButton(
                      text: "Save",
                      onPressed: () async {
                        if (_textController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill in the name')),
                          );
                          return;
                        }

                        final result = await _submitForm();

                        if (result['success'] == true) {
                          widget.onSubmit?.call(result);
                          if (mounted) {
                            Navigator.pop(context, result);
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'] ?? 'Failed to save')),
                          );
                        }
                      },

                      width: 116,
                    )
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

